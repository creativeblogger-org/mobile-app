import 'dart:async';
import 'dart:io';

import 'package:creative_blogger_app/utils/token.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:retry/retry.dart';

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
  var headers = await getJSONHeaders();
  return await retry(
    // Make a GET request
    () => http
        .get(Uri.parse(url), headers: headers)
        .timeout(const Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );
}

Future<Response> customPostRequest({required String url, Object? body}) async {
  var headers = await getJSONHeaders();
  return await retry(
    // Make a GET request
    () => http
        .post(Uri.parse(url), headers: headers, body: body)
        .timeout(const Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );
}

Future<Response> customPutRequest({required String url, Object? body}) async {
  var headers = await getJSONHeaders();
  return await retry(
    // Make a GET request
    () => http
        .put(Uri.parse(url), headers: headers, body: body)
        .timeout(const Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );
}

Future<Response> customDeleteRequest(String url) async {
  var headers = await getJSONHeaders();
  return await retry(
    // Make a GET request
    () => http
        .delete(Uri.parse(url), headers: headers)
        .timeout(const Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );
}
