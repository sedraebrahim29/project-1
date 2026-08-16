import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_state.dart';

/// Backs both the "Delete account" and "Log out" confirmation flows, so the
/// dialog can show a loading state while the (simulated) request is in
/// flight instead of freezing the UI with no feedback.
class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(const AccountState());

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: AccountActionStatus.processing));
    await Future.delayed(const Duration(milliseconds: 900));
    emit(state.copyWith(status: AccountActionStatus.done));
  }

  Future<void> logOut() async {
    emit(state.copyWith(status: AccountActionStatus.processing));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(status: AccountActionStatus.done));
  }

  void reset() => emit(const AccountState());
}
