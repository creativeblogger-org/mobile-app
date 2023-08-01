import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/user.dart';

Future<User?> getMe() async {
  try {
    var res = await customGetRequest("$API_URL/@me");
    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(res.body));
    }
    handleError(res);
    return null;
  } on SocketException catch (_) {
    return null;
  }
}
