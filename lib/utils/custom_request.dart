import 'dart:async';

import 'package:creative_blogger_app/utils/token.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<Map<String, String>> getJSONHeaders(
    {String contentType = "application/json"}) async {
  var headers = {"Content-Type": contentType};

  var token = await getToken();
  if (token.isNotEmpty) {
    headers.addAll({"Authorization": "Bearer $token"});
  }

  return headers;
}

Future<Response> customGetRequest(String url) async {
  return http.get(Uri.parse(url), headers: await getJSONHeaders());
}

Future<Response> customPostRequest({required String url, Object? body}) async {
  return http.post(Uri.parse(url), headers: await getJSONHeaders(), body: body);
}

Future<Response> customPutRequest({required String url, Object? body}) async {
  return http.put(Uri.parse(url), headers: await getJSONHeaders(), body: body);
}

Future<Response> customDeleteRequest(String url) async {
  return http.delete(Uri.parse(url), headers: await getJSONHeaders());
}
