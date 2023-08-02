import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<Post?> getPost(String slug) async {
  var res = await customGetRequest("$API_URL/posts/$slug");

  if (res == null) {
    return null;
  }

  if (res.statusCode == HttpStatus.ok) {
    return Post.fromJson(jsonDecode(res.body));
  }
  await handleError(res);
  return null;
}

Future<bool> removePost(String slug) async {
  var res = await customDeleteRequest("$API_URL/posts/$slug");
  if (res == null) {
    return false;
  }
  if (res.statusCode == HttpStatus.noContent) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(navigatorKey.currentContext!)!
            .post_deleted_successfully),
      ),
    );
    return true;
  }
  await handleError(res);
  return false;
}
