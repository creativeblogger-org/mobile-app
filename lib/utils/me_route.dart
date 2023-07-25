import 'dart:convert';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/user.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:http/http.dart' as http;

Future<User?> getMe() async {
  var res = await http.get(Uri.parse("$API_URL/@me"), headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${await getToken()}"
  });
  if (res.statusCode == 200) {
    return User.fromJson(jsonDecode(res.body));
  }
  handleError(res);
  return null;
}
