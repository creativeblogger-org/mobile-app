import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/short.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//changer par limit = 20
Future<List<Short>?> getShorts({int limit = 20, int page = 0}) async {
  try {
    var res = await customGetRequest("$API_URL/shorts?limit=$limit&page=$page");
    if (res.statusCode == HttpStatus.ok) {
      return (jsonDecode(res.body) as List)
          .map((jsonShorts) => Short.fromJson(jsonShorts))
          .toList();
    }
    handleError(res);

    return null;
  } on SocketException catch (_) {
    return null;
  }
}

Future<bool> removeShort(int id) async {
  var res = await customDeleteRequest("$API_URL/shorts/$id");
  if (res.statusCode == HttpStatus.noContent) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(navigatorKey.currentContext!)!
            .short_deleted_successfully),
      ),
    );
    return true;
  }
  handleError(res);
  return false;
}
