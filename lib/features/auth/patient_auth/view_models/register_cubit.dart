import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/register_model.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  // تعريف الـ PageController لإدارة التنقل بين شاشات الـ PageView
  final PageController pageController = PageController();

  // إجمالي عدد الخطوات في شاشة التسجيل
  final int totalSteps = 4;

  RegisterCubit() : super(RegisterInitial());

  // 1. الدالة المركزية لتحديث بيانات الموديل حياً من أي واجهة
  void updateRegisterModel(RegisterModel updatedModel) {
    emit(RegisterStepChanged(
      currentStep: state.currentStep,
      model: updatedModel,
    ));
  }

  // 2. الانتقال إلى الخطوة التالية مع عمل Validation
  void nextStep(GlobalKey<FormState> formKey) {
    if (state.currentStep < totalSteps) {
      // التحقق من صحة المدخلات في الخطوة الحالية قبل الانتقال
      if (formKey.currentState?.validate() ?? true) {
        final nextStepNumber = state.currentStep + 1;

        emit(RegisterStepChanged(
          currentStep: nextStepNumber,
          model: state.model,
        ));

        // تحريك الـ PageView للخطوة التالية بسلاسة
        pageController.animateToPage(
          nextStepNumber - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // إذا كنا في الخطوة الرابعة والأخيرة، يتم تنفيذ الإرسال النهائي للباك اند
      submitRegistration();
    }
  }

  // 3. العودة للخطوة السابقة عند ضغط زر الظهر أو السهم العلوي
  void previousStep(BuildContext context) {
    if (state.currentStep > 1) {
      final prevStepNumber = state.currentStep - 1;

      emit(RegisterStepChanged(
        currentStep: prevStepNumber,
        model: state.model,
      ));

      pageController.animateToPage(
        prevStepNumber - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // إذا كان في الخطوة الأولى وضغط خلف، يتم إغلاق الشاشة والعودة لصفحة اللوجن
      Navigator.pop(context);
    }
  }

  // 4. الدالة السحرية للقفز المباشر لأي خطوة (تُستدعى عند ضغط زر التعديل "القلم" في الخطوة 4)
  void jumpToStep(int stepNumber) {
    if (stepNumber >= 1 && stepNumber <= totalSteps) {
      emit(RegisterStepChanged(
        currentStep: stepNumber,
        model: state.model,
      ));

      pageController.animateToPage(
        stepNumber - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // 5. دالة الإرسال النهائي للـ API (الربط مع الـ Back-end مستقبلاً)
  Future<void> submitRegistration() async {
    try {
      // استخراج الـ Map الجاهز للإرسال كـ JSON body للـ API
      final Map<String, dynamic> requestData = state.model.toJson();

      // طباعة البيانات في الـ Console للتأكد من اكتمالها
      print('Sending Data to Back-end: $requestData');

      // هنا سيتم استدعاء الـ Repository والـ Dio لاحقاً:
      // await _authRepository.register(requestData);

      emit(RegisterSubmitSuccess(currentStep: state.currentStep, model: state.model));
    } catch (error) {
      emit(RegisterSubmitFailure(
        currentStep: state.currentStep,
        model: state.model,
        errorMessage: error.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    pageController.dispose(); // إغلاق الـ controller لحماية الذاكرة من الـ memory leaks
    return super.close();
  }
}
