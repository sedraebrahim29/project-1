enum AccountActionStatus { idle, processing, done }

class AccountState {
  final AccountActionStatus status;

  const AccountState({this.status = AccountActionStatus.idle});

  AccountState copyWith({AccountActionStatus? status}) =>
      AccountState(status: status ?? this.status);
}
