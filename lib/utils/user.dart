import 'dart:convert';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/public_user.dart';

Future<PublicUser?> getPublicUser(String username) async {
  var res = await customGetRequest("$API_URL/users/$username");
  if (res.statusCode == 200) {
    return PublicUser.fromJson(jsonDecode(res.body));
  }
  handleError(res);
  return null;
}

String getPermission(int permission) {
  switch (permission) {
    case 0:
      return "Membre";
    case 1:
      return "Rédacteur";
    case 2:
      return "Modérateur";
    case 3:
      return "Administrateur";
    default:
      return "Erreur";
  }
}
