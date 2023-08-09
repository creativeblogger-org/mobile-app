import 'package:creative_blogger_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showNoInternetConnection() {
  ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      content: Text(
        AppLocalizations.of(navigatorKey.currentContext!)!
            .no_Internet_connection,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.red,
    ),
  );
}
