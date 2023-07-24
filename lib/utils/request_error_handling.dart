import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void handleError(BuildContext context, Response res) {
  if (res.statusCode == HttpStatus.unauthorized) {
    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.error),
        content: Text(AppLocalizations.of(context)!.incorrect_credentials),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(innerContext);
            },
            child: Text(
              AppLocalizations.of(context)!.ok,
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
    return;
  }
  showDialog(
    context: context,
    builder: (innerContext) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.error),
      content: Text(jsonDecode(res.body)["errors"][0]["message"]),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(innerContext);
          },
          child: Text(
            AppLocalizations.of(context)!.ok,
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    ),
  );
  return;
}
