import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import '../models/register_model.dart';
import 'register_state.dart';
import '../../data/auth_repository.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_exception.dart';

class DoctorRegisterCubit extends Cubit<DoctorRegisterState> {
  final PageController pageController = PageController();

  final int totalSteps = 6;

  final AuthRepository _authRepository;

  // بتمنع إعادة إرسال نداء /register أو /verify-email من جديد لو المستخدم
  // رجع لخطوة 1 أو 2 (مثلاً من شاشة المراجعة) وعدّل شي وضغط "التالي" تاني.
  // بدونها، الرجوع لخطوة 1 وتعديل أي حقل كان رح يعيد نداء التسجيل بنفس
  // الإيميل ويرجع خطأ "email already exists" من السيرفر.
  bool _step1Registered = false;
  bool _emailVerified = false;

  DoctorRegisterCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(DoctorRegisterInitial());

  void updateRegisterModel(DoctorRegisterModel updatedModel) {
    emit(DoctorRegisterStepChanged(
      currentStep: state.currentStep,
      model: updatedModel,
    ));
  }

  /// [formKey] صار اختياري (nullable): فقط الخطوة اللي فعليًا فيها Form
  /// وvalidators (خطوة 1 حاليًا) بترسل الكي متاعها. أي خطوة تانية بتمرر
  /// null فبيتم تجاوز التحقق بدون ما يوقف تقدّم المستخدم.
  Future<void> nextStep(GlobalKey<FormState>? formKey) async {
    if (formKey != null && !(formKey.currentState?.validate() ?? true)) return;

    switch (state.currentStep) {
      case 1:
        if (_step1Registered) {
          _moveToNextStepLocally();
        } else {
          await _submitRegister();
        }
        break;
      case 2:
        if (_emailVerified) {
          _moveToNextStepLocally();
        } else {
          await _verifyEmailStep();
        }
        break;
      case 3:
      case 4:
      case 5:
        _moveToNextStepLocally();
        break;
      default:
        await submitRegistration();
    }
  }

  Future<void> _submitRegister() async {
    final model = state.model;
    final currentStep = state.currentStep;

    emit(DoctorRegisterStepSubmitting(currentStep: currentStep, model: model));

    try {
      // TODO: أكّد أسماء الحقول هون (first_name, ID_card_number...) مطابقة
      // تمامًا لأسماء الـ Postman collection بعد ما ترفعه.
      await _authRepository.register({
        'role': 'doctor',
        'first_name': model.firstName,
        'last_name': model.lastName,
        'email': model.email,
        'password': model.password,
        ApiConstants.passwordConfirmationKey: model.confirmPassword,
        'ID_card_number': model.idCardNumber,
      });

      _step1Registered = true;
      _advanceToStep(currentStep + 1, model);
    } on ApiException catch (e) {
      emit(DoctorRegisterSubmitFailure(
        currentStep: currentStep,
        model: model,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _verifyEmailStep() async {
    final model = state.model;
    final currentStep = state.currentStep;
    final code = model.verificationCode?.trim();

    if (code == null || code.isEmpty) {
      emit(DoctorRegisterSubmitFailure(
        currentStep: currentStep,
        model: model,
        errorMessage: 'الرجاء إدخال كود التحقق المرسل إلى بريدك الإلكتروني',
      ));
      return;
    }

    emit(DoctorRegisterStepSubmitting(currentStep: currentStep, model: model));

    try {
      await _authRepository.verifyEmailCode(code);
      _emailVerified = true;
      _advanceToStep(currentStep + 1, model);
    } on ApiException catch (e) {
      emit(DoctorRegisterSubmitFailure(
        currentStep: currentStep,
        model: model,
        errorMessage: e.message,
      ));
    }
  }

  Future<bool> resendVerificationCode() async {
    try {
      await _authRepository.resendCode();
      return true;
    } on ApiException catch (e) {
      emit(DoctorRegisterSubmitFailure(
        currentStep: state.currentStep,
        model: state.model,
        errorMessage: e.message,
      ));
      return false;
    }
  }

  void _moveToNextStepLocally() {
    final nextStepNumber = state.currentStep + 1;
    _advanceToStep(nextStepNumber, state.model);
  }

  void _advanceToStep(int stepNumber, DoctorRegisterModel model) {
    emit(DoctorRegisterStepChanged(currentStep: stepNumber, model: model));
    pageController.animateToPage(
      stepNumber - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousStep(BuildContext context) {
    if (state.currentStep > 1) {
      final prevStepNumber = state.currentStep - 1;
      emit(DoctorRegisterStepChanged(currentStep: prevStepNumber, model: state.model));
      pageController.animateToPage(
        prevStepNumber - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void jumpToStep(int stepNumber) {
    if (stepNumber >= 1 && stepNumber <= totalSteps) {
      emit(DoctorRegisterStepChanged(currentStep: stepNumber, model: state.model));
      pageController.animateToPage(
        stepNumber - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> submitRegistration() async {
    final model = state.model;
    final currentStep = state.currentStep;

    emit(DoctorRegisterStepSubmitting(currentStep: currentStep, model: model));

    try {
      // TODO: أكّد أسماء الحقول هون (dob, address, registration_mode...)
      // مطابقة تمامًا لأسماء الـ Postman collection بعد ما ترفعه.
      final fields = <String, dynamic>{
        'phone': model.phone,
        'gender': model.gender,
        'dob': model.dateOfBirth,
        'address': model.homeAddress,
        'registration_mode': model.registrationMode,
        // مضافة: كانت مفقودة بالكامل بالكود القديم رغم إنها مطلوبة من
        // الباك بكلا وضعي join_clinic/create_clinic (شفناها بالـ Postman
        // response كخطأ validation لما تكون ناقصة).
        'department_ids': model.departmentIds,
        'practice_start_date': model.practiceStartDate,
      };

      // الملفات المشتركة - مضاف لها contentType حتى ما يرفضها السيرفر
      // على أساس إنها "application/octet-stream" بدل صورة فعلية.
      if (model.idCardBytes != null) {
        fields['id_card'] = MultipartFile.fromBytes(
          model.idCardBytes!,
          filename: 'id_card.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
      }
      if (model.photoBytes != null) {
        fields['photo'] = MultipartFile.fromBytes(
          model.photoBytes!,
          filename: 'photo.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
      }
      if (model.licenseBytes != null) {
        fields['license_file'] = MultipartFile.fromBytes(
          model.licenseBytes!,
          filename: 'license.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
      }
      if (model.certificatesBytes.isNotEmpty) {
        // ملاحظة: القائمة هون بتتبعت بمفتاح "certificates" وبيتحول
        // تلقائياً لـ "certificates[]" جوا AuthRepository.completeProfile
        // بفضل ListFormat.multiCompatible - ما تحتاج تضيف [] هون يدوياً.
        fields['certificates'] = model.certificatesBytes
            .map((bytes) => MultipartFile.fromBytes(
          bytes,
          filename: 'certificate.jpg',
          contentType: MediaType('image', 'jpeg'),
        ))
            .toList();
      }

      if (model.registrationMode == 'join_clinic') {
        fields['clinic_id'] = model.clinicId;
      } else if (model.registrationMode == 'create_clinic') {
        fields['clinic_name'] = model.clinicName;
        fields['clinic_address'] = model.clinicAddress;
        fields['clinic_phone'] = model.clinicPhone;
        if (model.clinicLicenseBytes != null) {
          fields['clinic_license_file'] = MultipartFile.fromBytes(
            model.clinicLicenseBytes!,
            filename: 'clinic_license.jpg',
            contentType: MediaType('image', 'jpeg'),
          );
        }
      }

      await _authRepository.completeProfile(fields);
      emit(DoctorRegisterSubmitSuccess(currentStep: currentStep, model: model));
    } on ApiException catch (e) {
      emit(DoctorRegisterSubmitFailure(
        currentStep: currentStep,
        model: model,
        errorMessage: e.message,
      ));
    } catch (error) {
      emit(DoctorRegisterSubmitFailure(
        currentStep: currentStep,
        model: model,
        errorMessage: error.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
