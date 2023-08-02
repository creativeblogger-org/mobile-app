import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';

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
