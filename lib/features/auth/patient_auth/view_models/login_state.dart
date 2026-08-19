enum LoginTab { login, register }

// 1. تحديد نوع حالة عملية تسجيل الدخول الحالية
enum LoginStatus { initial, loading, success, pending, error }

class LoginState {
  final LoginTab activeTab;
  final bool obscurePassword;
  final bool isLoading;
  final LoginStatus status;
  final String? errorMessage;
  final String? pendingMessage;
  // بيانات المستخدم الحقيقية القادمة من data.user برد /auth/login الناجح
  // - تُستخدم لتوجيه الملاح (Navigator) حسب الدور (طبيب/مريض) وتغذية
  // شاشة الطبيب/المريض الرئيسية ببياناته الحقيقية مباشرة بدون أي بيانات
  // وهمية.
  final Map<String, dynamic>? userData;

  const LoginState({
    this.activeTab = LoginTab.login,
    this.obscurePassword = true,
    this.isLoading = false,
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.pendingMessage,
    this.userData,
  });

  String get userRole => userData?['role']?.toString() ?? 'patient';

  LoginState copyWith({
    LoginTab? activeTab,
    bool? obscurePassword,
    bool? isLoading,
    LoginStatus? status,
    String? errorMessage,
    String? pendingMessage,
    Map<String, dynamic>? userData,
  }) {
    return LoginState(
      activeTab: activeTab ?? this.activeTab,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      // نمرر القيمة مباشرة أو نتركها لتتصفّر عند الحاجة
      errorMessage: errorMessage,
      pendingMessage: pendingMessage,
      userData: userData ?? this.userData,
    );
  }
}
