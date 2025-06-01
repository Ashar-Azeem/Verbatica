// ignore_for_file: use_build_context_synchronously, library_prefixes

import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/LOGIN%20AND%20REGISTRATION/login_registeration_bloc.dart';
import 'package:verbatica/Utilities/Captcha/captcha.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Utilities/ErrorSnackBar.dart';
import 'package:verbatica/Views/Authentication%20Screens/EmailVerification.dart';
import 'package:verbatica/Views/Authentication%20Screens/login.dart'
    as loginRoute;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String gender = "Male";
  String? selectedCountry;
  bool isCountryValid = true;
  bool visibility = false;
  bool confirmVisibility = false;
  final GlobalKey<FormState> _email = GlobalKey<FormState>();
  final GlobalKey<FormState> _password = GlobalKey<FormState>();
  final GlobalKey<FormState> _confirmPassword = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confirmPassword;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    // Use email_validator for basic validation
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    // Additional check for multiple TLDs (e.g., .com.com)
    final domainPart = value.split('@')[1];
    final domainSegments = domainPart.split('.');
    // Check if there are too many segments or repeated TLD-like parts
    if (domainSegments.length > 2 &&
        domainSegments[domainSegments.length - 2].length <= 3) {
      return 'Invalid domain format';
    }
    return null;
  }

  bool _validateAllFields() {
    bool isEmailValid = _email.currentState!.validate();
    bool isPasswordNameValid = _password.currentState!.validate();
    bool isConfirmPasswordValid = _confirmPassword.currentState!.validate();
    setState(() {
      isCountryValid = (selectedCountry != null) ? true : false;
    });

    if (isEmailValid &&
        isPasswordNameValid &&
        isConfirmPasswordValid &&
        isCountryValid) {
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 40,
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: keyboardVisible ? 30.w : 40.w,
                    width: keyboardVisible ? 30.w : 40.w,
                    child: Image.asset('assets/Logo.png'),
                  ),

                  const Spacer(flex: 3),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _email,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        enableSuggestions: false,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),

                        autocorrect: false,
                        cursorColor:
                            Theme.of(context).textTheme.bodyLarge?.color,
                        controller: email,
                        validator: validateEmail,
                        decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          labelText: 'Email',
                          errorStyle: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 10,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _password,
                      child: TextFormField(
                        obscureText: !visibility,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),

                        cursorColor:
                            Theme.of(context).textTheme.bodyLarge?.color,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter 'password'";
                          } else if (value.length < 8) {
                            return "Your password should be atleast 8 characters long";
                          } else if (value != confirmPassword.text) {
                            return "";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          labelText: 'Password',
                          errorStyle: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 10,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
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
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _confirmPassword,
                      child: TextFormField(
                        obscureText: !confirmVisibility,
                        cursorColor:
                            Theme.of(context).textTheme.bodyLarge?.color,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),

                        controller: confirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "";
                          } else if (value != password.text) {
                            return "Passwords do not match. Please try again";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true, // Added this
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          labelText: 'Confirm Password',
                          errorStyle: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 10,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                confirmVisibility = !confirmVisibility;
                              });
                            },
                            icon: Icon(
                              confirmVisibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        exclude: ["IL"],
                        useSafeArea: true,

                        countryListTheme: CountryListThemeData(
                          searchTextStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          flagSize: 10.w,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          textStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        context: context,
                        showPhoneCode: false,
                        onSelect: (Country country) {
                          setState(() {
                            selectedCountry = country.name;
                          });
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isCountryValid
                                    ? Theme.of(context).colorScheme.outline
                                    : Theme.of(context).colorScheme.error,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCountry ?? 'Select your country',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        Text(
                          'Gender:',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withOpacity(0.7),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 7.w),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Theme.of(context).cardColor,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(
                                  context,
                                ).iconTheme.color?.withOpacity(0.7),
                              ),
                              hint: Text(
                                'Select Gender',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.7),
                                  fontSize: 15,
                                ),
                              ),
                              value: gender,
                              onChanged: (String? value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                              items:
                                  ['Male', 'Female'].map((gender) {
                                    return DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(
                                        gender,
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.color,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 3),
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
                          MaterialPageRoute(
                            builder: (context) => EmailVerification(),
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
                        return ElevatedButton(
                          onPressed: () async {
                            bool value = _validateAllFields();
                            if (value) {
                              bool isValid = await FlutterNumberCaptcha.show(
                                titleText: "Confirm You're Not a Robot",
                                placeholderText: "Type the answer ",
                                context,
                              );
                              if (isValid) {
                                //call the register event of the bloc
                                if (mounted) {
                                  context.read<LoginRegisterationBloc>().add(
                                    Registration(
                                      email: email.text,
                                      password: password.text,
                                      gender: gender,
                                      country: selectedCountry!,
                                    ),
                                  );
                                }

                                //Temproray code for UI debugging, remove after adding the business logic
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => EmailVerification(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(370, 47),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              state.status ==
                                      Loginandregisterationstatus.loading
                                  ? LoadingAnimationWidget.staggeredDotsWave(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: 10.w,
                                  )
                                  : Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                  ),
                        );
                      },
                    ),
                  ),
                  const Spacer(flex: 3),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => loginRoute.Login(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Already registered?",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
