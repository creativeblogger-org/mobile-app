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
