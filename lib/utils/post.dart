import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<Post?> getPost(String slug) async {
  var res = await customGetRequest("$API_URL/posts/$slug");
  if (res.statusCode == HttpStatus.ok) {
    return Post.fromJson(jsonDecode(res.body));
  }
  handleError(res);

  return null;
}

Future<bool> removePost(String slug) async {
  var res = await http.delete(Uri.parse("$API_URL/posts/$slug"), headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${await getToken()}"
  });
  if (res.statusCode == HttpStatus.noContent) {
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (innerContext) => AlertDialog(
        title: Text(AppLocalizations.of(navigatorKey.currentContext!)!
            .post_deleted_successfully),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(innerContext),
            child: Text(AppLocalizations.of(navigatorKey.currentContext!)!.ok),
          ),
        ],
      ),
    );
    return true;
  }
  handleError(res);
  return false;
}
