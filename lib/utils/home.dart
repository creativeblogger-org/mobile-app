import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:http/http.dart' as http;

Future<List<PreviewPost>> getPosts() async {
  var res = await http.get(Uri.parse("$API_URL/posts"), headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${await getToken()}"
  });
  print("start");
  if (res.statusCode == HttpStatus.ok) {
    print("Ok");
    return (jsonDecode(res.body) as List)
        .map((jsonPost) => PreviewPost.fromJson(jsonPost))
        .toList();
  }
  print("wtf : ${res.statusCode} ${jsonDecode(res.body)}");
  handleError(res);

  return [];
}
