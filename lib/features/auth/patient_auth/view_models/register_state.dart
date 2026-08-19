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
// ملاحظة مهمة: gender لازم تكون مكتوبة هون فعلياً كقيمة بالموديل من البداية
// (مش بس افتراض بالواجهة)، لأنه /auth/complete-profile بيرفض الطلب إذا وصلت null
// حتى لو الزر شكله محدد بصرياً كـ "female" بالواجهة.
class RegisterInitial extends RegisterState {
  RegisterInitial() : super(currentStep: 1, model: RegisterModel(gender: 'female'));
}

// الحالة عند تغير الحقول أو الانتقال بين الخطوات
class RegisterStepChanged extends RegisterState {
  const RegisterStepChanged({
    required super.currentStep,
    required super.model,
  });

  // تعديل جزء معين من الحالة دون فقدان باقي البيانات
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

// حالة انتظار أثناء تنفيذ نداء
class RegisterStepSubmitting extends RegisterState {
  const RegisterStepSubmitting({required super.currentStep, required super.model});
}

// حالة النجاح النهائي
class RegisterSubmitSuccess extends RegisterState {
  const RegisterSubmitSuccess({required super.currentStep, required super.model});
}

// حالة الفشل
// errors: خريطة أخطاء الحقول من الباك (مثلاً {"email": ["The email has already been taken."]})
// لو موجودة، بنستخدمها لعرض الخطأ تحت الحقل الصحيح بدل رسالة عامة بس بالسناك بار
class RegisterSubmitFailure extends RegisterState {
  final String errorMessage;
  final Map<String, dynamic>? fieldErrors;
  const RegisterSubmitFailure({
    required super.currentStep,
    required super.model,
    required this.errorMessage,
    this.fieldErrors,
  });
}
