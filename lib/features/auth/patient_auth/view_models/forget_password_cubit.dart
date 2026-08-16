import 'package:flutter_bloc/flutter_bloc.dart';
import 'forget_password_state.dart';
import '../../data/auth_repository.dart';
import '../../../../core/network/api_exception.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const ForgotPasswordState());

  void toggleObscurePassword() => emit(state.copyWith(obscurePassword: !state.obscurePassword));

  void toggleObscureConfirmPassword() => emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));

  /// خطوة 1: نداء فعلي لـ /auth/forgot-password - بيرسل كود لإيميل المستخدم
  Future<void> sendCode(String email) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: 'الرجاء إدخال بريد إلكتروني صحيح'));
      return;
    }

    emit(state.copyWith(status: ForgotPasswordStatus.loading, errorMessage: null));
    try {
      await _authRepository.forgotPassword(email.trim());
      emit(state.copyWith(
        status: ForgotPasswordStatus.initial,
        step: ForgotPasswordStep.reset,
        email: email.trim(),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: e.message));
    }
  }

  /// خطوة 2: نداء فعلي لـ /auth/reset-password - الكود + كلمة المرور الجديدة
  Future<void> resetPassword({
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    if (code.trim().isEmpty) {
      emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: 'الرجاء إدخال الكود المرسل لبريدك'));
      return;
    }
    if (password.length < 8) {
      emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: 'كلمة المرور يجب أن تكون 8 أحرف على الأقل'));
      return;
    }
    if (password != confirmPassword) {
      emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: 'كلمتا المرور غير متطابقتين'));
      return;
    }

    emit(state.copyWith(status: ForgotPasswordStatus.loading, errorMessage: null));
    try {
      await _authRepository.resetPassword(
        email: state.email,
        code: code.trim(),
        password: password,
        passwordConfirmation: confirmPassword,
      );
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(status: ForgotPasswordStatus.failure, errorMessage: e.message));
    }
  }

  /// رجوع لخطوة إدخال الإيميل (لو المستخدم بدو يصحح إيميله)
  void backToEmailStep() {
    emit(state.copyWith(step: ForgotPasswordStep.email, status: ForgotPasswordStatus.initial, errorMessage: null));
  }
}
