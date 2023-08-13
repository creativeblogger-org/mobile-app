import 'dart:async';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/show_no_internet_connection.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<Map<String, String>> getJSONHeaders(
    {String contentType = "application/json"}) async {
  var headers = {"Content-Type": contentType};

  var token = await getToken();
  if (token.isNotEmpty) {
    headers.addAll({HttpHeaders.authorizationHeader: "Bearer $token"});
  }

  return headers;
}

Future<Response?> customGetRequest(String url) async {
  try {
    return await http.get(Uri.parse(url), headers: await getJSONHeaders());
  } catch (e) {
    showNoInternetConnection();
    return null;
  }
}

Future<Response?> customPostRequest({required String url, Object? body}) async {
  try {
    return await http.post(Uri.parse(url),
        headers: await getJSONHeaders(), body: body);
  } catch (e) {
    showNoInternetConnection();
    return null;
  }
}

Future<Response?> customPutRequest({required String url, Object? body}) async {
  try {
    return await http.put(Uri.parse(url),
        headers: await getJSONHeaders(), body: body);
  } catch (e) {
    showNoInternetConnection();
    return null;
  }
}

Future<Response?> customDeleteRequest(String url) async {
  try {
    return await http.delete(Uri.parse(url), headers: await getJSONHeaders());
  } catch (e) {
    showNoInternetConnection();
    return null;
  }
}

Future<Response?> customUpdateProfilePictureRequest(MultipartFile image) async {
  try {
    var req = http.MultipartRequest("POST", Uri.parse("$API_URL/@me/upload"));
    req.headers.addAll(await getJSONHeaders());
    req.files.add(image);
    var res = await req.send();
    return await http.Response.fromStream(res);
  } catch (e) {
    showNoInternetConnection();
    return null;
  }
}
