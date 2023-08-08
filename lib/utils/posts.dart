import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/preview_post.dart';

Future<(List<PreviewPost>?, int)> getPreviewPosts(
    {int limit = 20,
    int page = 0,
    String query = "",
    String authorId = ""}) async {
  var res = await customGetRequest(
      "$API_URL/posts?limit=$limit&page=$page&q=$query&user=$authorId");
  if (res == null) {
    return (null, 0);
  }

  if (res.statusCode == HttpStatus.ok) {
    return (
      (jsonDecode(res.body) as List)
          .map((jsonPost) => PreviewPost.fromJson(jsonPost))
          .toList(),
      int.parse(res.headers["nbposts"] ?? "0")
    );
  }
  await handleError(res);

  return ([] as List<PreviewPost>, 0);
}
