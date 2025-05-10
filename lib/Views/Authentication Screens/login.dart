// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/LOGIN%20AND%20REGISTRATION/login_registeration_bloc.dart';
import 'package:verbatica/Utilities/Captcha/captcha.dart';
import 'package:verbatica/Utilities/Color.dart';
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

    return BlocProvider(
      create: (context) => LoginRegisterationBloc(),

      child: Scaffold(
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
                    style: TextStyle(color: Colors.white),

                    autocorrect: false,
                    cursorColor: Colors.white,
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter an email";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white),
                      ),
                      labelText: 'Email',
                      errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color.fromARGB(255, 199, 78, 69),
                        ),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
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
                        style: TextStyle(color: Colors.white),

                        cursorColor: Colors.white,
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
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          labelText: 'Password',
                          errorStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 199, 78, 69),
                            ),
                          ),
                          labelStyle: const TextStyle(color: Colors.white),
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
                          color: primaryColor,
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
                                  color: Colors.white,
                                  size: 10.w,
                                )
                                : const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                      );
                    },
                  ),
                ),

                const Spacer(flex: 3),

                if (!keyboardVisible)
                  Text(
                    'Or continue with',
                    style: TextStyle(color: Colors.white),
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
                      side: const BorderSide(color: Colors.grey),
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
                        const Text(
                          'Google',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
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
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: " Register here",
                            style: TextStyle(
                              color: primaryColor,
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
