// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/model/user.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool visibility = false;
  bool confirmVisibility = false;
  bool isLoading = false;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        User user = context.read<UserBloc>().state.user!;
        await ApiService().resetPasswordStep3(
          user.email,
          user.id,
          newPasswordController.text.trim(),
        );
        setState(() => isLoading = false);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Password successfully reset!')));

        Navigator.pop(context);
      } catch (e) {
        setState(() => isLoading = false);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Reset Your Password',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.secondary,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.secondary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                SizedBox(height: 6.h), // Extra spacing to avoid image cutoff

                Image.asset(
                  'assets/reset-password.png',
                  width: 50.w,
                  height: 50.w,
                ),

                SizedBox(height: 6.h),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // New Password
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: !visibility,
                        style: TextStyle(color: theme.colorScheme.secondary),
                        cursorColor: theme.colorScheme.secondary,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          isDense: true,
                          contentPadding: const EdgeInsets.all(16),
                          labelStyle: TextStyle(
                            color: theme.colorScheme.secondary,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              visibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: theme.colorScheme.secondary,
                            ),
                            onPressed: () {
                              setState(() {
                                visibility = !visibility;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: !confirmVisibility,
                        style: TextStyle(color: theme.colorScheme.secondary),
                        cursorColor: theme.colorScheme.secondary,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          isDense: true,
                          contentPadding: const EdgeInsets.all(16),
                          labelStyle: TextStyle(
                            color: theme.colorScheme.secondary,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              confirmVisibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: theme.colorScheme.secondary,
                            ),
                            onPressed: () {
                              setState(() {
                                confirmVisibility = !confirmVisibility;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 6.h),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    minimumSize: Size(100.w, 6.h),
                  ),
                  onPressed: isLoading ? null : _handleResetPassword,
                  child:
                      isLoading
                          ? LoadingAnimationWidget.staggeredDotsWave(
                            color: theme.colorScheme.onPrimary,
                            size: 8.w,
                          )
                          : Text(
                            'Reset Password',
                            style: TextStyle(fontSize: 3.8.w),
                          ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
