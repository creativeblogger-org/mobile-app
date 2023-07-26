import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:http/http.dart' as http;

Future<Post?> getPosts(String slug) async {
  var res = await http.get(Uri.parse("$API_URL/posts/$slug"), headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${await getToken()}"
  });
  if (res.statusCode == HttpStatus.ok) {
    return Post.fromJson(jsonDecode(res.body));
  }
  handleError(res);

  return null;
}
