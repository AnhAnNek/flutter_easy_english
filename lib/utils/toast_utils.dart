import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  /// Dynamically adjusts the display time based on message length.
  static void _showToast({
    required String message,
    required Color backgroundColor,
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
    double fontSize = 16.0,
  }) {
    // Calculate display time: 1 second for every 20 characters, minimum 2 seconds
    int timeInSecForIosWeb = (message.length / 20).ceil().clamp(2, 10);

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, // Android will still use SHORT/LONG
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      timeInSecForIosWeb: timeInSecForIosWeb,
    );
  }

  /// Shows a success toast with dynamic timing.
  static void showSuccess(String message) {
    _showToast(
      message: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Shows an error toast with dynamic timing.
  static void showError(String message) {
    _showToast(
      message: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Shows an informational toast with dynamic timing.
  static void showInfo(String message) {
    _showToast(
      message: message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }
}
