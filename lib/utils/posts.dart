import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/preview_post.dart';

Future<List<PreviewPost>?> getPreviewPosts(
    {int limit = 20, int page = 0}) async {
  var res = await customGetRequest("$API_URL/posts?limit=$limit&page=$page");
  if (res == null) {
    return null;
  }

  if (res.statusCode == HttpStatus.ok) {
    return (jsonDecode(res.body) as List)
        .map((jsonPost) => PreviewPost.fromJson(jsonPost))
        .toList();
  }
  await handleError(res);

  return [];
}

//TODO replace int by String
Future<List<PreviewPost>?> getPreviewPostsByAuthor(
    {required int author, int limit = 20, int page = 0}) async {
  //TODO URL will be changed, this doesn't work for now
  var res = await customGetRequest(
      //TODO replace by /users/$author/posts?limit=$limit&page=$page
      "$API_URL/posts/username/$author?limit=$limit&page=$page");
  if (res == null) {
    return null;
  }

  if (res.statusCode == HttpStatus.ok) {
    return (jsonDecode(res.body) as List)
        .map((jsonPost) => PreviewPost.fromJson(jsonPost))
        .toList();
  }
  await handleError(res);

  return [];
}
