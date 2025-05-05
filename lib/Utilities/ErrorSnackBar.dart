import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.redAccent.shade200,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 6,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
