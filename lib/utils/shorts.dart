import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/short.dart';

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
