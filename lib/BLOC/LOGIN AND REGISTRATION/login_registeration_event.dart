part of 'login_registeration_bloc.dart';

sealed class LoginRegisterationEvent extends Equatable {
  const LoginRegisterationEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends LoginRegisterationEvent {
  final String email;
  final String password;
  final BuildContext context;

  const LoginEvent({
    required this.email,
    required this.password,
    required this.context,
  });
}

class Registration extends LoginRegisterationEvent {
  final String email;
  final String password;
  final String gender;
  final String country;
  final BuildContext context;

  const Registration({
    required this.email,
    required this.password,
    required this.gender,
    required this.country,
    required this.context,
  });
}

class VerifyOtp extends LoginRegisterationEvent {
  final String email;
  final int userId;
  final int otp;
  final BuildContext context;

  const VerifyOtp({
    required this.email,
    required this.userId,
    required this.otp,
    required this.context,
  });
}

class ResendOTP extends LoginRegisterationEvent {
  final String email;
  final BuildContext context;

  const ResendOTP({required this.email, required this.context});
}

class SignInWithGoogle extends LoginRegisterationEvent {
  final BuildContext context;

  const SignInWithGoogle({required this.context});
}

class SignInWithGoogleCompleteInfo extends LoginRegisterationEvent {
  final BuildContext context;
  final String country;
  final String gender;

  const SignInWithGoogleCompleteInfo({
    required this.country,
    required this.gender,
    required this.context,
  });
}
