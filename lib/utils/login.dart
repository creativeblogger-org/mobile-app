import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var usernameValidCharacters = RegExp(r'^[a-zA-Z][\w]{2,}$');
var emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

String? isUsernameValid(BuildContext context, String username) {
  if (usernameValidCharacters.hasMatch(username)) {
    return null;
  }
  return AppLocalizations.of(context)!.invalid_username;
}

String? isEmailValid(
  BuildContext context,
  String email,
) {
  if (emailRegex.hasMatch(email)) {
    return null;
  }
  return AppLocalizations.of(context)!.invalid_email_address;
}
