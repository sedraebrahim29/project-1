// المسار: lib/features/patient_auth/view_models/login_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  // الحالة الابتدائية الافتراضية للـ Cubit
  LoginCubit() : super(const LoginState());

  // 1. التبديل بين واجهة الـ Login و الـ Register (Tabs)
  void switchTab(LoginTab tab) {
    emit(state.copyWith(
      activeTab: tab,
      status: LoginStatus.initial, // تصفير الحالة لضمان عدم تكرار الـ Listener
    ));
  }

  // 2. إظهار وإخفاء كلمة المرور (تغيير الأيقونة وحالة النص)
  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  // 3. دالة الـ Remember Me التي كان يعترض عليها الـ UI
  void toggleRememberMe(bool? value) {
    emit(state.copyWith(rememberMe: value ?? false));
  }

  // 4. دالة تسجيل الدخول المحدثة مع المنطق المؤقت للمريض
  Future<void> login(String email, String password) async {
    // إطلاق حالة التحميل وتغيير الـ status
    emit(state.copyWith(isLoading: true, status: LoginStatus.loading));

    // محاكاة تأخير السيرفر (800 مللي ثانية)
    await Future.delayed(const Duration(milliseconds: 800));

    // أولاً: نطلق حالة الانتظار (Pending) لكي يظهر السناك بار للمريض
    emit(state.copyWith(
        isLoading: false,
        status: LoginStatus.pending,
        pendingMessage: "Your account is under review by the admin. Redirecting to home..."
    ));

    // ثانياً: التمرير المؤقت لفتح الـ Home Page حالياً للاختبار والتطوير
    emit(state.copyWith(
      isLoading: false,
      status: LoginStatus.success,
    ));
  }
}
