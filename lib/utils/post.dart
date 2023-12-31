import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:creative_blogger_app/utils/success_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

Future<(Post?, int, bool)> getPost(String slug) async {
  var res = await customGetRequest("$API_URL/posts/$slug");

  if (res == null) {
    return (null, 0, false);
  }

  if (res.statusCode == HttpStatus.ok) {
    var decoded = jsonDecode(res.body);
    return (
      Post.fromJson(decoded),
      int.parse(res.headers["nbcomments"] ?? "0"),
      bool.parse(res.headers["has_liked"] ?? "false")
    );
  }
  await handleError(res);
  return (null, 0, false);
}

Future<bool> deletePost(String slug) async {
  var res = await customDeleteRequest("$API_URL/posts/$slug");
  if (res == null) {
    return false;
  }
  if (res.statusCode == HttpStatus.noContent) {
    showSuccessSnackbar(AppLocalizations.of(navigatorKey.currentContext!)!
        .post_deleted_successfully);
    return true;
  }
  await handleError(res);
  return false;
}

Future<bool> createPost(
  String title,
  MultipartFile imageFile,
  String description,
  String tags,
  String content,
  int requiredAge,
) async {
  var imageRes = await customUpdateProfilePictureRequest(
      imageFile, "$API_URL/posts/upload");
  if (imageRes == null) {
    return false;
  }
  if (imageRes.statusCode != HttpStatus.ok) {
    return false;
  }
  var imagePath = "$API_URL/public/posts/${jsonDecode(imageRes.body)["path"]}";
  var res = await customPostRequest(
    url: "$API_URL/posts",
    body: jsonEncode(
      {
        "title": title,
        "image": imagePath,
        "description": description,
        "tags": tags,
        "content": content,
        "required_age": requiredAge,
      },
    ),
  );
  if (res == null) {
    return false;
  }
  if (res.statusCode == HttpStatus.noContent) {
    showSuccessSnackbar(AppLocalizations.of(navigatorKey.currentContext!)!
        .post_published_successfully);
    return true;
  }
  await handleError(res);
  return false;
}

Future<bool> updatePost(
  int id,
  String slug,
  String title,
  String description,
  String category,
  String content,
) async {
  var res = await customPutRequest(
    url: "$API_URL/posts/$slug",
    body: jsonEncode(
      {
        "id": id,
        "title": title,
        "description": description,
        "tags": category,
        "content": content,
      },
    ),
  );
  if (res == null) {
    return false;
  }
  if (res.statusCode == HttpStatus.noContent) {
    showSuccessSnackbar(AppLocalizations.of(navigatorKey.currentContext!)!
        .post_updated_successfully);
    return true;
  }
  await handleError(res);
  return false;
}

Future<bool> likePost(int id) async {
  var res = await customPostRequest(url: "$API_URL/posts/like/$id");

  if (res == null) {
    return false;
  }

  if (res.statusCode == HttpStatus.ok) {
    return true;
  }

  await handleError(res);
  return false;
}

Future<bool> unlikePost(int id) async {
  var res = await customDeleteRequest("$API_URL/posts/unlike/$id");

  if (res == null) {
    return false;
  }

  if (res.statusCode == HttpStatus.ok) {
    return true;
  }

  await handleError(res);
  return false;
}
