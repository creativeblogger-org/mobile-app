import 'package:creative_blogger_app/main.dart';
import 'package:flutter/material.dart';

void showSuccessSnackbar(String text) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: Colors.green,
    ),
  );
}
