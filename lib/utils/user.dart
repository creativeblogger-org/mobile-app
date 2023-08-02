import 'dart:convert';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/public_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<PublicUser?> getPublicUser(String username) async {
  var res = await customGetRequest("$API_URL/users/$username");

  if (res == null) {
    return null;
  }

  if (res.statusCode == 200) {
    return PublicUser.fromJson(jsonDecode(res.body));
  }
  await handleError(res);
  return null;
}

Widget getPermission(int permission) {
  switch (permission) {
    case 0:
      return Text(
        AppLocalizations.of(navigatorKey.currentContext!)!.member,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    case 1:
      return Text(
        AppLocalizations.of(navigatorKey.currentContext!)!.writer,
        style: TextStyle(
          color: Theme.of(navigatorKey.currentContext!).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    case 2:
      return Text(
        AppLocalizations.of(navigatorKey.currentContext!)!.moderator,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    case 3:
      return Text(
        AppLocalizations.of(navigatorKey.currentContext!)!.administrator,
        style: TextStyle(
          color: Colors.red.shade900,
          fontWeight: FontWeight.bold,
        ),
      );
    default:
      return Text(AppLocalizations.of(navigatorKey.currentContext!)!.error);
  }
}
