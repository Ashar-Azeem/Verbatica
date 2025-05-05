import 'package:flutter/material.dart';
import 'package:verbatica/Utilities/Captcha/NumberCaptchaDialogue.dart';

class FlutterNumberCaptcha {
  static Future<bool> show(
    context, {
    String titleText = 'Enter correct number',
    String placeholderText = 'Enter Number',
    String checkCaption = 'Check',
    String invalidText = 'Invalid Code',
    Color? accentColor,
  }) async {
    bool? result = await showDialog(
      context: context,
      builder: (context) {
        return NumberCaptchaDialog(
          titleText,
          placeholderText,
          checkCaption,
          invalidText,
          accentColor: accentColor,
        );
      },
    );
    if (result == true) {
      return true;
    }
    return false;
  }
}
