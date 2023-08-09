import 'dart:convert';

import 'package:creative_blogger_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> handleError(Response res) async {
  await showDialog(
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
