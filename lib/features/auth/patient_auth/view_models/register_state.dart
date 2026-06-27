import '../models/register_model.dart';

abstract class RegisterState {
  final int currentStep;
  final RegisterModel model;

  const RegisterState({
    required this.currentStep,
    required this.model,
  });
}

// الحالة الابتدائية عند فتح الشاشة لأول مرة
class RegisterInitial extends RegisterState {
  RegisterInitial() : super(currentStep: 1, model: RegisterModel());
}

// الحالة التي يتم إطلاقها عند تغير الحقول أو الانتقال بين الخطوات
class RegisterStepChanged extends RegisterState {
  const RegisterStepChanged({
    required super.currentStep,
    required super.model,
  });

  // دالة copyWith لتسهيل تعديل جزء معين من الحالة دون فقدان باقي البيانات
  RegisterStepChanged copyWith({
    int? currentStep,
    RegisterModel? model,
  }) {
    return RegisterStepChanged(
      currentStep: currentStep ?? this.currentStep,
      model: model ?? this.model,
    );
  }
}

// حالة النجاح النهائي عند إرسال البيانات للباك اند بنجاح
class RegisterSubmitSuccess extends RegisterState {
  const RegisterSubmitSuccess({required super.currentStep, required super.model});
}

// حالة الفشل في حال حدوث خطأ أثناء الاتصال بالـ API
class RegisterSubmitFailure extends RegisterState {
  final String errorMessage;
  const RegisterSubmitFailure({
    required super.currentStep,
    required super.model,
    required this.errorMessage,
  });
}
