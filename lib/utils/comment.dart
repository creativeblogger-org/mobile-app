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
  if (res.statusCode == HttpStatus.noContent) {
    return true;
  }
  handleError(res);
  return false;
}
