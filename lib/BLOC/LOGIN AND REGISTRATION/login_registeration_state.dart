part of 'login_registeration_bloc.dart';

class LoginRegisterationState extends Equatable {
  final Loginandregisterationstatus status;
  final String error;
  const LoginRegisterationState({
    this.status = Loginandregisterationstatus.sucess,
    this.error = '',
  });

  LoginRegisterationState copyWith({
    Loginandregisterationstatus? status,
    String? error,
  }) {
    return LoginRegisterationState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, error];
}

enum Loginandregisterationstatus { sucess, failure, loading }
