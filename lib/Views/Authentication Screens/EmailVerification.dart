import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'dart:async';

import 'package:sizer/sizer.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Utilities/ErrorSnackBar.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/mainBottomNavigationBar.dart';

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

  void _resendOtp() {
    if (_canResend) {
      // Add your OTP resend logic here
      _startTimer();
      setState(() {
        _enteredOtp = '';
      });
    }
  }

  void _verifyOtp() {
    if (_enteredOtp.length == _otpLength) {
      // Add your OTP verification logic here
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomNavigationBarView()),
        (Route<dynamic> route) => false,
      );
    } else {
      CustomSnackbar.showError(context, "Please enter a valid OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Email Icon
              Image.asset('assets/EmailIcon.png', width: 55.w, height: 55.w),

              // Title
              Text(
                'Verify Your Email',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 4.h),

              // Instructions
              Text(
                'We\'ve sent a 5-digit code to your email address',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 2.h),

              // OTP Field
              OtpTextField(
                numberOfFields: _otpLength,
                borderColor: Theme.of(context).primaryColor,
                focusedBorderColor: primaryColor,
                styles: [
                  for (int i = 0; i < _otpLength; i++)
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                ],
                showFieldAsBox: true,
                borderRadius: BorderRadius.circular(10),
                fieldWidth: 50,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                onSubmit: (code) {
                  _enteredOtp = code;
                  _verifyOtp();
                },
                onCodeChanged: (code) {
                  _enteredOtp = code;
                },
              ),
              const SizedBox(height: 32),

              // Timer and Resend Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _canResend ? 'Didn\'t receive code? ' : 'Resend code in ',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  if (!_canResend)
                    Text(
                      '$_timerSeconds s',
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor,
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
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 32),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Verify', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
