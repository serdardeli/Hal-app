import 'package:flutter/material.dart';

class ScaffoldMessengerHelper {
  static ScaffoldMessengerHelper? _instance;

  static ScaffoldMessengerHelper get instance =>
      _instance ??= ScaffoldMessengerHelper._();

  ScaffoldMessengerHelper._();
  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void showSuccessfulSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }
   void showNormalSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
   //   backgroundColor: Colors.green,
    ));
  }
}
