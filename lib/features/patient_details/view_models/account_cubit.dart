import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/data/auth_repository.dart';
import 'account_state.dart';

/// Backs both the "Delete account" and "Log out" confirmation flows, so the
/// dialog can show a loading state while the request is in flight instead of
/// freezing the UI with no feedback.
class AccountCubit extends Cubit<AccountState> {
  final AuthRepository _authRepository;

  AccountCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AccountState());

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: AccountActionStatus.processing));
    await Future.delayed(const Duration(milliseconds: 900));
    emit(state.copyWith(status: AccountActionStatus.done));
  }

  Future<void> logOut() async {
    emit(state.copyWith(status: AccountActionStatus.processing));
    // نداء حقيقي: بيبعت /auth/logout للسيرفر (يلغي التوكن من جهته) وبكل
    // الحالات (نجاح أو فشل بالاتصال) بيمسح التوكن المحلي - راجع
    // AuthRepository.logout().
    await _authRepository.logout();
    emit(state.copyWith(status: AccountActionStatus.done));
  }

  void reset() => emit(const AccountState());
}
