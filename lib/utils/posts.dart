import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/create_post_screen.dart';
import 'package:creative_blogger_app/screens/home/home.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/preview_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<(List<PreviewPost>?, int)> getPreviewPosts(
    {int limit = 20,
    int page = 0,
    String query = "",
    String authorId = "",
    String tag = ""}) async {
  var res = await customGetRequest(
      "$API_URL/posts?limit=$limit&page=$page&q=$query&user=$authorId&tag=$tag");
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

Category? getCategory(String stringCategory) {
  switch (stringCategory) {
    case "fakeorreal":
      return Category.fakeOrReal;
    case "tech":
      return Category.tech;
    case "culture":
      return Category.culture;
    case "news":
      return Category.news;
    case "sport":
      return Category.sport;
    case "cinema":
      return Category.cinema;
    case "litterature":
      return Category.litterature;
    case "musique":
      return Category.musique;
    default:
      return null;
  }
}

String getCategoryName(Category category, BuildContext context) {
  switch (category) {
    case Category.fakeOrReal:
      return AppLocalizations.of(context)!.investigation;
    case Category.tech:
      return AppLocalizations.of(context)!.tech;
    case Category.culture:
      return AppLocalizations.of(context)!.culture;
    case Category.news:
      return AppLocalizations.of(context)!.news;
    case Category.sport:
      return AppLocalizations.of(context)!.sport;
    case Category.cinema:
      return AppLocalizations.of(context)!.cinema;
    case Category.litterature:
      return AppLocalizations.of(context)!.literature;
    case Category.musique:
      return AppLocalizations.of(context)!.music;
  }
}

String getCategoryWithAllName(CategoryWithAll category, BuildContext context) {
  
switch (category) {
    case CategoryWithAll.all:
      return AppLocalizations.of(context)!.all;
    case CategoryWithAll.fakeOrReal:
      return AppLocalizations.of(context)!.investigation;
    case CategoryWithAll.tech:
      return AppLocalizations.of(context)!.tech;
    case CategoryWithAll.culture:
      return AppLocalizations.of(context)!.culture;
    case CategoryWithAll.news:
      return AppLocalizations.of(context)!.news;
    case CategoryWithAll.sport:
      return AppLocalizations.of(context)!.sport;
    case CategoryWithAll.cinema:
      return AppLocalizations.of(context)!.cinema;
    case CategoryWithAll.litterature:
      return AppLocalizations.of(context)!.literature;
    case CategoryWithAll.musique:
      return AppLocalizations.of(context)!.music;
  }
}
