import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void handleError(Response res) {
  if (res.statusCode == HttpStatus.unauthorized) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (innerContext) => AlertDialog(
        title: Text(AppLocalizations.of(navigatorKey.currentContext!)!.error),
        content: Text(AppLocalizations.of(navigatorKey.currentContext!)!
            .incorrect_credentials),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(innerContext);
            },
            child: Text(
              AppLocalizations.of(navigatorKey.currentContext!)!.ok,
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
    return;
  }
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (innerContext) => AlertDialog(
      title: Text(AppLocalizations.of(navigatorKey.currentContext!)!.error),
      content: Text(jsonDecode(res.body)["errors"][0]["message"]),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(innerContext);
          },
          child: Text(
            AppLocalizations.of(navigatorKey.currentContext!)!.ok,
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    ),
  );
  return;
}
