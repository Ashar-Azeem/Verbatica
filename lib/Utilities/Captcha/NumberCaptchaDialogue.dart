import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbatica/Utilities/Captcha/numberCaptcha.dart';

class NumberCaptchaDialog extends StatefulWidget {
  const NumberCaptchaDialog(
    this.titleText,
    this.placeholderText,
    this.checkCaption,
    this.invalidText, {
    super.key,
    this.accentColor,
  });

  final String titleText;
  final String placeholderText;
  final String checkCaption;
  final String invalidText;
  final Color? accentColor;

  @override
  State<NumberCaptchaDialog> createState() => _NumberCaptchaDialogState();
}

class _NumberCaptchaDialogState extends State<NumberCaptchaDialog> {
  final TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String code = '';
  int number1 = 0;
  int number2 = 0;
  String operator = '';
  List<String> operators = ['+', '-', 'x'];
  bool? isValid;

  @override
  initState() {
    generateCode();
    super.initState();
  }

  void generateCode() {
    Random random = Random();
    number1 = random.nextInt(10) + 1;
    number2 = random.nextInt(10) + 1;
    operator = operators[random.nextInt(2)];

    code = '$number1 $operator $number2 = ?';
    setState(() {});
  }

  void checkAnswer(String value) {
    int result = 0;
    isValid = null;
    switch (operator) {
      case '+':
        result = number1 + number2;
        break;
      case '-':
        result = number1 - number2;
        break;
      case 'x':
        result = number1 * number2;
        break;
    }

    if (result.toString() == value) {
      isValid = true;
      Navigator.pop(context, true);
    } else {
      generateCode();
      isValid = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Card(
        color: isDarkMode ? const Color(0xFF121416) : Colors.white,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF121416) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.titleText,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 145, 179, 221),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NumberCaptcha(code, isDark: isDarkMode),
                      Ink(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 81, 144, 221),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: generateCode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            isValid == false
                                ? Colors.redAccent
                                : const Color.fromARGB(255, 81, 144, 221),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: textController,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),

                            decoration: InputDecoration(
                              hintText: widget.placeholderText,
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                            onSubmitted: checkAnswer,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              checkAnswer(textController.text);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    81,
                                    144,
                                    221,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.checkCaption,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isValid == false)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Invalid answer. Please try again.',
                          style: TextStyle(color: Colors.redAccent),
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
