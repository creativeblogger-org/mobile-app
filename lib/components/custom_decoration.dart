import 'package:flutter/material.dart';

BoxDecoration customDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(21, 184, 166, 1),
        Color.fromRGBO(99, 102, 241, 1)
      ],
    ),
  );
}
