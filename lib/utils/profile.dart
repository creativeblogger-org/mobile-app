import 'dart:convert';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/success_snackbar.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> updateProfile(
    String username, String email, String password) async {
  var body = {'username': username, 'email': email};

  if (password.isNotEmpty) {
    body['password'] = password;
  }

  var res = await customPutRequest(url: "$API_URL/@me", body: jsonEncode(body));
  if (res == null) {
    return;
  }
  if (res.statusCode == 204) {
    showSuccessSnackbar(AppLocalizations.of(navigatorKey.currentContext!)!
        .account_updated_successfully);
    return;
  }

  await handleError(res);
}

Future<bool> deleteAccount() async {
  var res = await customDeleteRequest(
    "$API_URL/@me",
  );
  if (res == null) {
    return false;
  }
  if (res.statusCode == 204) {
    await deleteToken();
    return true;
  }
  await handleError(res);
  return false;
}
