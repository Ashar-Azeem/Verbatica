part of 'login_registeration_bloc.dart';

class LoginRegisterationState extends Equatable {
  final Loginandregisterationstatus status;
  final String error;
  final User? user;
  const LoginRegisterationState({
    this.user,
    this.status = Loginandregisterationstatus.sucess,
    this.error = '',
  });

  LoginRegisterationState copyWith({
    Loginandregisterationstatus? status,
    String? error,
    User? user,
  }) {
    return LoginRegisterationState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, error, user];
}

enum Loginandregisterationstatus {
  sucess,
  failure,
  loading,
  googleLoading,
  googleDone,
}
