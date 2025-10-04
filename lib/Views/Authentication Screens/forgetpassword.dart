// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/LOGIN%20AND%20REGISTRATION/login_registeration_bloc.dart';
import 'package:verbatica/Views/Authentication%20Screens/forgetpasswordotp.dart';
import 'package:verbatica/Views/Authentication%20Screens/login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _validateEmail() {
    return _emailFormKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocProvider(
      create: (context) => LoginRegisterationBloc(),
      child: Scaffold(
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
                  icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),

                SizedBox(height: 3.h),

                // Lock Icon
                Center(
                  child: Image.asset(
                    'assets/reset-password.png', // Make sure to add this asset
                    width: 40.w,
                    height: 40.w,
                  ),
                ),

                SizedBox(height: 4.h),

                // Title
                Text(
                  'Forgot Password?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),

                SizedBox(height: 2.h),

                // Instructions
                Text(
                  'Don\'t worry! Enter your email address and we\'ll send you a code to reset your password.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),

                SizedBox(height: 4.h),

                // Email Input Field
                Form(
                  key: _emailFormKey,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: true,
                    autocorrect: false,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    cursorColor: theme.textTheme.bodyLarge?.color,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter an email";
                      }
                      // Basic email validation
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color:
                              theme.textTheme.bodyLarge?.color ?? Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      labelText: 'Email',
                      errorStyle: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 10,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: theme.colorScheme.error,
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                // Send OTP Button
                // BlocListener<LoginRegisterationBloc, LoginRegisterationState>(
                //   listenWhen: (previous, current) {
                //     return previous.status != current.status;
                //   },
                //   listener: (context, state) {
                //     if (state.status == Loginandregisterationstatus.failure) {
                //     CustomSnackbar.showError(context, state.error);
                //   } else if (state.status == Loginandregisterationstatus.sucess) {
                //     // Navigate to OTP Verification screen

                //     );
                //   }
                // },
                // child: BlocBuilder<LoginRegisterationBloc, LoginRegisterationState>(
                //   builder: (context, state) {
                //     return
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // if (_validateEmail()) {
                      // Trigger the event to send OTP
                      // context.read<LoginRegisterationBloc>().add(
                      //   // ForgotPasswordSendOTP(
                      //   //   email: _emailController.text,
                      //   //   context: context,
                      //   // ),
                      // );
                      // }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => ForgotPasswordOTPVerification(
                                email: _emailController.text,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                    // state.status == Loginandregisterationstatus.loading
                    //     ? LoadingAnimationWidget.staggeredDotsWave(
                    //         color: theme.colorScheme.onPrimary,
                    //         size: 10.w,
                    //       )
                    //     :
                    Text(
                      'Send OTP',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),

                if (!keyboardVisible) SizedBox(height: 20.h),

                // Back to Login
                if (!keyboardVisible)
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
                          text: "Remember your password? ",
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
      ),
    );
  }
}
