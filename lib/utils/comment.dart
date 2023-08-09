import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/comment.dart';
import 'package:creative_blogger_app/utils/success_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> postComment(String postSlug, String content) async {
  var res = await customPostRequest(
    url: "$API_URL/posts/$postSlug/comment",
    body: jsonEncode(
      {"content": content},
    ),
  );
  if (res == null) {
    return false;
  }
  if (res.statusCode == HttpStatus.noContent) {
    return true;
  }
  await handleError(res);
  return false;
}

Future<void> updateComment(int id, String content) async {
  var res = await customPutRequest(
    url: "$API_URL/comments/$id",
    body: jsonEncode(
      {"content": content},
    ),
  );
  if (res == null) {
    return;
  }
  if (res.statusCode == HttpStatus.noContent) {
    showSuccessSnackbar(AppLocalizations.of(navigatorKey.currentContext!)!
        .comment_updated_successfully);
    return;
  }
  await handleError(res);
}

Future<bool> deleteComment(int commentId) async {
  var res = await customDeleteRequest("$API_URL/comments/$commentId");
  if (res == null) {
    return false;
  }
  if (res.statusCode == HttpStatus.noContent) {
    return true;
  }
  await handleError(res);
  return false;
}

Future<(List<Comment>?, int)> getComments(int postId, {int page = 1}) async {
  var res = await customGetRequest("$API_URL/comments/$postId?page=$page");
  if (res == null) {
    return (null, 0);
  }

  if (res.statusCode == HttpStatus.ok) {
    //TODO remove ["data"] when the API will allow it
    return (
      (jsonDecode(res.body)["data"] as List)
          .map((jsonComment) => Comment.fromJson(jsonComment))
          .toList(),
      int.parse(res.headers["nbcomments"] ?? "0")
    );
  }
  await handleError(res);

  return (null, 0);
}
