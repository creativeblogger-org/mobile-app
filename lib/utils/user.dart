import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/public_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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

Color getPermissionColor(Permission permission) {
  switch (permission) {
    case Permission.member:
      return Colors.white;
    case Permission.redactor:
      return Theme.of(navigatorKey.currentContext!).colorScheme.primary;
    case Permission.moderator:
      return Colors.red;
    case Permission.administrator:
      return Colors.red.shade900;
  }
}

Widget getPermissionWidget(Permission permission) {
  switch (permission) {
    case Permission.member:
      return Text(
        AppLocalizations.of(navigatorKey.currentContext!)!.member,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    case Permission.redactor:
      return Text(
        AppLocalizations.of(navigatorKey.currentContext!)!.writer,
        style: TextStyle(
          color: Theme.of(navigatorKey.currentContext!).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    case Permission.moderator:
      return Text(
        AppLocalizations.of(navigatorKey.currentContext!)!.moderator,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    case Permission.administrator:
      return Text(
        AppLocalizations.of(navigatorKey.currentContext!)!.administrator,
        style: TextStyle(
          color: Colors.red.shade900,
          fontWeight: FontWeight.bold,
        ),
      );
  }
}

Widget colorUsernameWithPermission(String username, Permission permission) {
  return Text(
    username,
    style: TextStyle(
      color: getPermissionColor(permission),
      fontWeight: FontWeight.bold,
    ),
  );
}

String getHumanDate(DateTime date) {
  var localDate = date.toLocal();
  var stringDate = DateFormat.yMd(Platform.localeName).format(localDate);
  String at = AppLocalizations.of(navigatorKey.currentContext!)!.at;
  var time = DateFormat("hh:mm").format(localDate);
  return "$stringDate $at $time";
}
