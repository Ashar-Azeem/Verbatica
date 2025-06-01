// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/LOGIN%20AND%20REGISTRATION/login_registeration_bloc.dart';
import 'package:verbatica/Utilities/Captcha/captcha.dart';
import 'package:verbatica/Utilities/ErrorSnackBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/Views/Authentication%20Screens/register.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/mainBottomNavigationBar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _email = GlobalKey<FormState>();
  final GlobalKey<FormState> _password = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visibility = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  bool _validateAllFields() {
    bool isEmailValid = _email.currentState!.validate();
    bool isPasswordNameValid = _password.currentState!.validate();

    if (isEmailValid && isPasswordNameValid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => LoginRegisterationBloc(),

      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 2.w, right: 2.w),
            child: Column(
              children: [
                const Spacer(flex: 3),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: keyboardVisible ? 30.w : 40.w,
                  width: keyboardVisible ? 30.w : 40.w,
                  child: Image.asset('assets/Logo.png'),
                ),
                const Spacer(flex: 2),
                Form(
                  key: _email,
                  child: TextFormField(
                    enableSuggestions: false,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),

                    autocorrect: false,
                    cursorColor: theme.textTheme.bodyLarge?.color,
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter an email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(16),
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
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Form(
                      key: _password,
                      child: TextFormField(
                        obscureText: !visibility,
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                        ),

                        cursorColor: theme.textTheme.bodyLarge?.color,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color:
                                  theme.textTheme.bodyLarge?.color ??
                                  Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          labelText: 'Password',
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
                                visibility = !visibility;
                              });
                            },
                            icon: Icon(
                              //ternary operator  bool ? open eye: close eye
                              visibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: theme.iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        //Forgot password Logic
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(top: 6), // minimal top padding
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                BlocListener<LoginRegisterationBloc, LoginRegisterationState>(
                  listenWhen: (previous, current) {
                    return previous.status != current.status;
                  },
                  listener: (context, state) {
                    if (state.status == Loginandregisterationstatus.failure) {
                      CustomSnackbar.showError(context, state.error);
                    } else if (state.status ==
                        Loginandregisterationstatus.sucess) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Register()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: BlocBuilder<
                    LoginRegisterationBloc,
                    LoginRegisterationState
                  >(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        onPressed: () async {
                          bool value = _validateAllFields();
                          if (value) {
                            //Add a number captcha
                            bool isValid = await FlutterNumberCaptcha.show(
                              titleText: "Confirm You're Not a Robot",
                              placeholderText: "Type the answer",
                              context,
                            );
                            if (isValid) {
                              //call the login event at the backend
                              context.read<LoginRegisterationBloc>().add(
                                LoginEvent(
                                  email: email.text,
                                  password: password.text,
                                ),
                              );

                              //Temprorary code for debugging the UI, remove after adding business logic
                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BottomNavigationBarView(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            }
                          }
                        },

                        child:
                            state.status == Loginandregisterationstatus.loading
                                ? LoadingAnimationWidget.staggeredDotsWave(
                                  color: theme.colorScheme.onPrimary,
                                  size: 10.w,
                                )
                                : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                      );
                    },
                  ),
                ),

                const Spacer(flex: 3),

                if (!keyboardVisible)
                  Text(
                    'Or continue with',
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),

                const Spacer(flex: 1),
                //Sign in with google
                if (!keyboardVisible)
                  OutlinedButton(
                    onPressed: () {
                      //Sign in with google
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(95.w, 6.h),
                      side: BorderSide(color: theme.dividerColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/googleIcon.png', // Make sure to add Google logo to your assets
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Google',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!keyboardVisible) const Spacer(flex: 4),

                if (!keyboardVisible)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Register()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Not registered yet?",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                        children: [
                          TextSpan(
                            text: " Register here",
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
