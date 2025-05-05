part of 'login_registeration_bloc.dart';

sealed class LoginRegisterationEvent extends Equatable {
  const LoginRegisterationEvent();

  @override
  List<Object> get props => [];
}

class Login extends LoginRegisterationEvent {
  final String email;
  final String password;

  const Login({required this.email, required this.password});
}

class Registration extends LoginRegisterationEvent {
  final String email;
  final String password;
  final String gender;
  final String country;
  const Registration({
    required this.email,
    required this.password,
    required this.gender,
    required this.country,
  });
}
