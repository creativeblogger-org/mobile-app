import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/short.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//changer par limit = 20
Future<List<Short>> getShorts({int limit = 20, int page = 0}) async {
  var res = await customGetRequest("$API_URL/shorts?limit=$limit&page=$page");
  if (res.statusCode == HttpStatus.ok) {
    return (jsonDecode(res.body) as List)
        .map((jsonShorts) => Short.fromJson(jsonShorts))
        .toList();
  }
  handleError(res);

  return [];
}

Future<bool> removeShort(int id) async {
  var res = await http.delete(Uri.parse("$API_URL/shorts/$id"), headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${await getToken()}"
  });
  if (res.statusCode == HttpStatus.noContent) {
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (innerContext) => AlertDialog(
        title: Text(AppLocalizations.of(navigatorKey.currentContext!)!
            .short_deleted_successfully),
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
