// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/LOGIN%20AND%20REGISTRATION/login_registeration_bloc.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/Utilities/ErrorSnackBar.dart';
import 'package:verbatica/Views/Authentication%20Screens/login.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/mainBottomNavigationBar.dart';
import 'package:verbatica/model/user.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final int _otpLength = 5;
  String _enteredOtp = '';
  int _timerSeconds = 30;
  late Timer _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _timerSeconds = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _timerSeconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => LoginRegisterationBloc(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Email Icon
                    Image.asset(
                      'assets/EmailIcon.png',
                      width: 55.w,
                      height: 55.w,
                    ),

                    // Title
                    Text(
                      'Verify Your Email',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Instructions
                    Text(
                      'We\'ve sent a 5-digit code to your email address',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // OTP Field
                    BlocBuilder<
                      LoginRegisterationBloc,
                      LoginRegisterationState
                    >(
                      builder: (context, state) {
                        return OtpTextField(
                          numberOfFields: _otpLength,
                          borderColor: theme.dividerColor,
                          focusedBorderColor: theme.colorScheme.primary,
                          styles: [
                            for (int i = 0; i < _otpLength; i++)
                              theme.textTheme.headlineMedium?.copyWith(
                                color: theme.textTheme.headlineMedium?.color,
                                fontWeight: FontWeight.bold,
                              ),
                          ],
                          showFieldAsBox: true,
                          borderRadius: BorderRadius.circular(10),
                          fieldWidth: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          onSubmit: (code) async {
                            _enteredOtp = code;
                            if (_enteredOtp.length == _otpLength) {
                              // Add your OTP verification logic here
                              User user =
                                  await TokenOperations().loadUserProfile()
                                      as User;
                              //API OPERATION
                              context.read<LoginRegisterationBloc>().add(
                                VerifyOtp(
                                  email: user.email,
                                  userId: user.id,
                                  otp: int.parse(_enteredOtp),
                                  context: context,
                                ),
                              );
                            } else {
                              CustomSnackbar.showError(
                                context,
                                "Please enter a valid OTP",
                              );
                            }
                          },
                          onCodeChanged: (code) {
                            _enteredOtp = code;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Timer and Resend Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _canResend
                              ? 'Didn\'t receive code? '
                              : 'Resend code in ',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        if (!_canResend)
                          Text(
                            '$_timerSeconds s',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (_canResend)
                          BlocBuilder<
                            LoginRegisterationBloc,
                            LoginRegisterationState
                          >(
                            builder: (context, state) {
                              return TextButton(
                                onPressed: () async {
                                  if (_canResend) {
                                    User user =
                                        await TokenOperations()
                                                .loadUserProfile()
                                            as User;

                                    context.read<LoginRegisterationBloc>().add(
                                      ResendOTP(
                                        email: user.email,
                                        context: context,
                                      ),
                                    );

                                    _startTimer();
                                    setState(() {
                                      _enteredOtp = '';
                                    });
                                  }
                                },
                                child: Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Verify Button
                    BlocListener<
                      LoginRegisterationBloc,
                      LoginRegisterationState
                    >(
                      listenWhen: (previous, current) {
                        return previous.status != current.status;
                      },
                      listener: (context, state) {
                        if (state.status ==
                            Loginandregisterationstatus.failure) {
                          CustomSnackbar.showError(context, state.error);
                        } else if (state.status ==
                            Loginandregisterationstatus.sucess) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => BottomNavigationBarView(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      child: BlocBuilder<
                        LoginRegisterationBloc,
                        LoginRegisterationState
                      >(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_enteredOtp.length == _otpLength) {
                                  // Add your OTP verification logic here
                                  User user =
                                      await TokenOperations().loadUserProfile()
                                          as User;
                                  //API OPERATION
                                  context.read<LoginRegisterationBloc>().add(
                                    VerifyOtp(
                                      email: user.email,
                                      userId: user.id,
                                      otp: int.parse(_enteredOtp),
                                      context: context,
                                    ),
                                  );
                                } else {
                                  CustomSnackbar.showError(
                                    context,
                                    "Please enter a valid OTP",
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child:
                                  state.status ==
                                          Loginandregisterationstatus.loading
                                      ? LoadingAnimationWidget.staggeredDotsWave(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                        size: 10.w,
                                      )
                                      : Text(
                                        'Verify',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                      ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: "Try something different?",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    children: [
                      TextSpan(
                        text: " Login here",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
