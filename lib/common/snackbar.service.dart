import 'package:flutter/material.dart';

class SnackbarService {

  static void show(String message, BuildContext context) {
    // ScaffoldMessenger.of(context).hideCurrentSnackBar();
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}