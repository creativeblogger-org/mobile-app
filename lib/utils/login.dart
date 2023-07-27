import 'package:creative_blogger_app/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var usernameValidCharacters = RegExp(r'^[a-zA-Z][\w]{2,}$');
var emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

String? isUsernameValid(String username) {
  if (usernameValidCharacters.hasMatch(username)) {
    return null;
  }
  return AppLocalizations.of(navigatorKey.currentContext!)!.invalid_username;
}

String? isEmailValid(String email) {
  if (emailRegex.hasMatch(email)) {
    return null;
  }
  return AppLocalizations.of(navigatorKey.currentContext!)!
      .invalid_email_address;
}
