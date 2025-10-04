// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';
import 'package:sizer/sizer.dart';
import 'package:verbatica/Utilities/ErrorSnackBar.dart';
import 'package:verbatica/Views/Authentication%20Screens/login.dart';
import 'package:verbatica/Views/Authentication%20Screens/newpassword.dart';

class ForgotPasswordOTPVerification extends StatefulWidget {
  final String email;
  
  const ForgotPasswordOTPVerification({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordOTPVerification> createState() => _ForgotPasswordOTPVerificationState();
}

class _ForgotPasswordOTPVerificationState extends State<ForgotPasswordOTPVerification> {
  final int _otpLength = 5;
  String _enteredOtp = '';
  int _timerSeconds = 30;
  late Timer _timer;
  bool _canResend = false;
  bool _isLoading = false;

  // Dummy OTP for testing
  final String _dummyOtp = '12345';

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

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length != _otpLength) {
      CustomSnackbar.showError(
        context,
        "Please enter a valid 5-digit OTP",
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    // Verify OTP against dummy OTP
    if (_enteredOtp == _dummyOtp) {
      // OTP is correct - navigate to Reset Password screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResetPassword(
            email: widget.email,
            otp: _enteredOtp,
          ),
        ),
      );
    } else {
      // OTP is incorrect - show error
      CustomSnackbar.showError(
        context,
        "Invalid OTP. Please try again.",
      );
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'OTP has been resent to ${widget.email}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );

    // Reset timer
    _startTimer();
    
    // Clear entered OTP
    setState(() {
      _enteredOtp = '';
    });

    // In real implementation, you would call the resend OTP API here
    print('Resending OTP to ${widget.email}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.iconTheme.color,
                ),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),

              SizedBox(height: 2.h),

              // Email Icon
              Center(
                child: Image.asset(
                  'assets/EmailIcon.png',
                  width: 55.w,
                  height: 55.w,
                ),
              ),

              SizedBox(height: 3.h),

              // Title
              Center(
                child: Text(
                  'Verify OTP',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Instructions
              Center(
                child: Text(
                  'We\'ve sent a 5-digit code to',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
              
              SizedBox(height: 0.5.h),
              
              Center(
                child: Text(
                  widget.email,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              // OTP Field
              OtpTextField(
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
                  await _verifyOtp();
                },
                onCodeChanged: (code) {
                  _enteredOtp = code;
                },
              ),

              SizedBox(height: 4.h),

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
                    TextButton(
                      onPressed: _resendOtp,
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 4.h),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
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
                  child: _isLoading
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: theme.colorScheme.onPrimary,
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
              ),

              SizedBox(height: 3.h),

              // Info Text
              Center(
                child: Text(
                  'Hint: Use OTP "12345" for testing',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              SizedBox(height: 15.h),

              // Back to Login
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Try something different? ",
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      children: [
                        TextSpan(
                          text: "Login here",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
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
      ),
    );
  }
}