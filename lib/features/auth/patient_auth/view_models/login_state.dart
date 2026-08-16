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
  const LoginState({
    this.activeTab = LoginTab.login,
    this.obscurePassword = true,
    this.isLoading = false,
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.pendingMessage,
  });

  LoginState copyWith({
    LoginTab? activeTab,
    bool? obscurePassword,
    bool? isLoading,
    LoginStatus? status,
    String? errorMessage,
    String? pendingMessage,
  }) {
    return LoginState(
      activeTab: activeTab ?? this.activeTab,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      // نمرر القيمة مباشرة أو نتركها لتتصفّر عند الحاجة
      errorMessage: errorMessage,
      pendingMessage: pendingMessage,
    );
  }
}
