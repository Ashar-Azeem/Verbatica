// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/Utilities/ErrorSnackBar.dart';
import 'package:verbatica/Views/Authentication%20Screens/login.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPassword({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _newPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _confirmPasswordFormKey = GlobalKey<FormState>();
  
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _newPasswordVisibility = false;
  bool _confirmPasswordVisibility = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateAllFields() {
    bool isNewPasswordValid = _newPasswordFormKey.currentState!.validate();
    bool isConfirmPasswordValid = _confirmPasswordFormKey.currentState!.validate();

    return isNewPasswordValid && isConfirmPasswordValid;
  }

  Future<void> _resetPassword() async {
    if (!_validateAllFields()) {
      return;
    }

    // Check if passwords match
    if (_newPasswordController.text != _confirmPasswordController.text) {
      CustomSnackbar.showError(
        context,
        "Passwords do not match",
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // write code here to continue
    // This is where you would call your API to reset the password
    // You have access to:
    // - widget.email (user's email)
    // - widget.otp (verified OTP)
    // - _newPasswordController.text (new password)

    // For now, show success and navigate to login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Password reset successful! Please login with your new password.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate to login screen
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Login()),
      (Route<dynamic> route) => false,
    );
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
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.iconTheme.color,
                ),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),

              SizedBox(height: 3.h),

              // Lock Icon
              if (!keyboardVisible)
                Center(
                  child: Image.asset(
                    'assets/reset-password.png',
                    width: 40.w,
                    height:40.w,
                  ),
                ),

              if (!keyboardVisible) SizedBox(height: 4.h),

              // Title
              Text(
                'Reset Password',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),

              SizedBox(height: 2.h),

              // Instructions
              Text(
                'Please enter your new password below.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),

              SizedBox(height: 4.h),

              // New Password Field
              Form(
                key: _newPasswordFormKey,
                child: TextFormField(
                  controller: _newPasswordController,
                  obscureText: !_newPasswordVisibility,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  cursorColor: theme.textTheme.bodyLarge?.color,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a new password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
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
                    labelText: 'New Password',
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
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _newPasswordVisibility = !_newPasswordVisibility;
                        });
                      },
                      icon: Icon(
                        _newPasswordVisibility
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Confirm Password Field
              Form(
                key: _confirmPasswordFormKey,
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisibility,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  cursorColor: theme.textTheme.bodyLarge?.color,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
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
                    labelText: 'Confirm Password',
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
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisibility = !_confirmPasswordVisibility;
                        });
                      },
                      icon: Icon(
                        _confirmPasswordVisibility
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),

              if (!keyboardVisible) SizedBox(height: 15.h),

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
    );
  }
}