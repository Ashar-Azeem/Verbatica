// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/Utilities/ErrorSnackBar.dart';
import 'package:verbatica/Views/Authentication%20Screens/forgetpasswordotp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool loading = false;
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
                        color: theme.textTheme.bodyLarge?.color ?? Colors.grey,
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_validateEmail()) {
                      // Trigger the event to send OTP
                      setState(() {
                        loading = true;
                      });
                      try {
                        int token = await ApiService().resetPasswordStep1(
                          _emailController.text.trim(),
                        );
                        setState(() {
                          loading = false;
                        });

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => ForgotPasswordOTPVerification(
                                  email: _emailController.text,
                                  token: token,
                                ),
                          ),
                        );
                      } catch (e) {
                        CustomSnackbar.showError(context, e.toString());
                        setState(() {
                          loading = false;
                        });
                      }
                    }
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
                      loading
                          ? LoadingAnimationWidget.staggeredDotsWave(
                            color: theme.colorScheme.onPrimary,
                            size: 6.w,
                          )
                          : Text(
                            'Send OTP',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                ),
              ),

              if (!keyboardVisible) SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
