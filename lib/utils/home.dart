import 'dart:convert';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<PreviewPost>> getPosts(BuildContext context) async {
  var res = await http.get(Uri.parse("$API_URL/posts"), headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${getToken()}"
  });
  if (res.statusCode == 200) {
    return (jsonDecode(res.body) as List)
        .map((jsonPost) => PreviewPost.fromJson(jsonPost))
        .toList();
  }
  handleError(context, res);
  return [];
}
