import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';
import '../../data/auth_repository.dart';
import '../../../../core/network/api_exception.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const LoginState());

  void switchTab(LoginTab tab) {
    emit(state.copyWith(
      activeTab: tab,
      status: LoginStatus.initial,
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  /// نداء فعلي لـ /auth/login. التوكن بينحفظ تلقائياً جوا AuthRepository.login
  /// لو نجح. الباك بيرجع نفس الـ 422 لحالتين مختلفتين (بيانات دخول غلط / حساب
  /// لسا قيد المراجعة) وما في حقل مميز بينهم غير نص الرسالة نفسها.
  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, status: LoginStatus.loading));

    try {
<<<<<<< HEAD
      final response = await _authRepository.login(email, password);
      final userData = response['data'] is Map ? response['data']['user'] as Map<String, dynamic>? : null;
      emit(state.copyWith(isLoading: false, status: LoginStatus.success, userData: userData));
=======
      await _authRepository.login(email, password);
      emit(state.copyWith(isLoading: false, status: LoginStatus.success));
>>>>>>> 6f2cf5c88c0f04be6d75e9a7241f4aeaf98d82f7
    } on ApiException catch (e) {
      final isPendingAccount = e.message.toLowerCase().contains('pending');
      if (isPendingAccount) {
        emit(state.copyWith(
          isLoading: false,
          status: LoginStatus.pending,
          pendingMessage: e.message,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          status: LoginStatus.error,
          errorMessage: e.message,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        status: LoginStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }
}
