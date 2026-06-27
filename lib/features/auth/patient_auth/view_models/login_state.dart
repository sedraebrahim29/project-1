enum LoginTab { login, register }

// 1. تحديد نوع حالة عملية تسجيل الدخول الحالية
enum LoginStatus { initial, loading, success, pending, error }

class LoginState {
  final LoginTab activeTab;
  final bool obscurePassword;
  final bool rememberMe;
  final bool isLoading; // محتفظين به لعدم كسر واجهتك الحالية
  final LoginStatus status; // الحالة الجديدة للتحكم بالـ Listener
  final String? errorMessage;
  final String? pendingMessage; // لتخزين رسالة الـ Admin review

  const LoginState({
    this.activeTab = LoginTab.login,
    this.obscurePassword = true,
    this.rememberMe = false,
    this.isLoading = false,
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.pendingMessage,
  });

  LoginState copyWith({
    LoginTab? activeTab,
    bool? obscurePassword,
    bool? rememberMe,
    bool? isLoading,
    LoginStatus? status,
    String? errorMessage,
    String? pendingMessage,
  }) {
    return LoginState(
      activeTab: activeTab ?? this.activeTab,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      // نمرر القيمة مباشرة أو نتركها لتتصفّر عند الحاجة
      errorMessage: errorMessage,
      pendingMessage: pendingMessage,
    );
  }
}
// أضيفي هذه الحالة داخل ملف login_state.dart
class LoginAccountPending extends LoginState {
  final String message;
  LoginAccountPending(this.message) : super(
    activeTab: LoginTab.login,
    isLoading: false,
    obscurePassword: true,
    rememberMe: false,
  );
}
