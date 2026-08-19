import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/register_model.dart';
import 'register_state.dart';
import '../../data/auth_repository.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_exception.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final PageController pageController = PageController();
  // 1: Basic Info -> register | 2: Verify Email -> verify-code
  // 3: Personal Details (محلي) | 4: Review -> complete-profile
  final int totalSteps = 4;

  final AuthRepository _authRepository;

  RegisterCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(RegisterInitial());

  void updateRegisterModel(RegisterModel updatedModel) {
    emit(RegisterStepChanged(
      currentStep: state.currentStep,
      model: updatedModel,
    ));
  }

  /// كل خطوة إلها منطق مختلف لأنه كل وحدة مرتبطة بنداء API مختلف بالباك اند.
  Future<void> nextStep(GlobalKey<FormState> formKey) async {
    if (!(formKey.currentState?.validate() ?? true)) return;

    switch (state.currentStep) {
      case 1:
        await _submitRegister();
        break;
      case 2:
        await _verifyEmailStep();
        break;
      case 3:
        _moveToNextStepLocally();
        break;
      default:
        submitRegistration();
    }
  }

  /// خطوة 1: نداء فعلي لـ /auth/register
  Future<void> _submitRegister() async {
    final model = state.model;
    final currentStep = state.currentStep;

    emit(RegisterStepSubmitting(currentStep: currentStep, model: model));

    try {
      await _authRepository.register({
        'role': 'patient',
        'first_name': model.firstName,
        'last_name': model.lastName,
        'email': model.email,
        'password': model.password,
        ApiConstants.passwordConfirmationKey: model.confirmPassword,
        'ID_card_number': model.idCardNumber,
      });

      _advanceToStep(currentStep + 1, model);
    } on ApiException catch (e) {
      emit(RegisterSubmitFailure(
        currentStep: currentStep,
        model: model,
        errorMessage: e.message,
        fieldErrors: e.errors,
      ));
    }
  }

  /// خطوة 2: نداء فعلي لـ /auth/email/verify-code
  /// السيرفر بيكون بعت الكود تلقائياً وقت نجاح الـ register بالخطوة السابقة
  Future<void> _verifyEmailStep() async {
    final model = state.model;
    final currentStep = state.currentStep;
    final code = model.verificationCode?.trim();

    if (code == null || code.isEmpty) {
      emit(RegisterSubmitFailure(
        currentStep: currentStep,
        model: model,
        errorMessage: 'الرجاء إدخال كود التحقق المرسل إلى بريدك الإلكتروني',
      ));
      return;
    }

    emit(RegisterStepSubmitting(currentStep: currentStep, model: model));

    try {
      await _authRepository.verifyEmailCode(code);
      _advanceToStep(currentStep + 1, model);
    } on ApiException catch (e) {
      emit(RegisterSubmitFailure(
        currentStep: currentStep,
        model: model,
        errorMessage: e.message,
        fieldErrors: e.errors,
      ));
    }
  }

  /// إعادة إرسال كود التفعيل - بترجع true/false حتى الـ Widget يقرر شو يعمل
  Future<bool> resendVerificationCode() async {
    try {
      await _authRepository.resendCode();
      return true;
    } on ApiException catch (e) {
      emit(RegisterSubmitFailure(
        currentStep: state.currentStep,
        model: state.model,
        errorMessage: e.message,
        fieldErrors: e.errors,
      ));
      return false;
    }
  }

  void _moveToNextStepLocally() {
    final nextStepNumber = state.currentStep + 1;
    _advanceToStep(nextStepNumber, state.model);
  }

  void _advanceToStep(int stepNumber, RegisterModel model) {
    emit(RegisterStepChanged(currentStep: stepNumber, model: model));
    pageController.animateToPage(
      stepNumber - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousStep(BuildContext context) {
    if (state.currentStep > 1) {
      final prevStepNumber = state.currentStep - 1;
      emit(RegisterStepChanged(currentStep: prevStepNumber, model: state.model));
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
      emit(RegisterStepChanged(currentStep: stepNumber, model: state.model));
      pageController.animateToPage(
        stepNumber - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  /// خطوة 4 (الأخيرة): نداء فعلي لـ /auth/complete-profile
  Future<void> submitRegistration() async {
    final model = state.model;
    final currentStep = state.currentStep;

    emit(RegisterStepSubmitting(currentStep: currentStep, model: model));

    try {
      await _authRepository.completeProfile({
        'phone': model.phone,
        'gender': model.gender,
        'dob': model.dateOfBirth,
        'address': model.homeAddress,
        'blood_type': model.bloodType,
<<<<<<< HEAD
        // ⚠️ lat/lng: مضافة حديثاً بالفرونت (تحديد الموقع من خريطة حقيقية)
        // مو موثّقة/مؤكدة بعد بالـ Postman collection كحقول يقبلها الباك
        // بـ complete-profile - لازم فريق الباك يتأكد إنه العمودين هدول
        // موجودين بجدول المرضى ومسموح تحديثهن هون (وإلا ممكن ينلقطوا
        // ويتجاهلوا بهدوء بدون أي خطأ ظاهر).
        if (model.latitude != null) 'latitude': model.latitude,
        if (model.longitude != null) 'longitude': model.longitude,
=======
>>>>>>> 6f2cf5c88c0f04be6d75e9a7241f4aeaf98d82f7
      });
      emit(RegisterSubmitSuccess(currentStep: currentStep, model: model));
    } on ApiException catch (e) {
      emit(RegisterSubmitFailure(
        currentStep: currentStep,
        model: model,
        errorMessage: e.message,
        fieldErrors: e.errors,
      ));
    } catch (error) {
      emit(RegisterSubmitFailure(
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
