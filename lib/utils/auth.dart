import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/home/home.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

Future<void> authRequest(
  String url,
  String body,
) async {
  var res = await customPostRequest(url: url, body: body);
  if (res == null) {
    return;
  }
  if (res.statusCode == HttpStatus.ok) {
    setToken(jsonDecode(res.body)["token"]).then((_) {
      Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentContext!,
        HomeScreen.routeName,
        (route) => false,
      );
    });
    return;
  }
  await handleError(res);
}
