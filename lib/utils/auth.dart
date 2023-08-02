import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/home/home.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/show_no_internet_connection.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'dart:io';

BuildContext? dcontext;

void dismissDialog() {
  if (dcontext != null) {
    Navigator.pop(dcontext!);
  }
}

Future<void> authRequest(
  String url,
  String body,
) async {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      dcontext = context;
      return const Dialog.fullscreen(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
        child: SpinKitSpinningLines(
          color: Colors.blue,
          size: 100,
          duration: Duration(milliseconds: 1500),
        ),
      );
    },
    barrierDismissible: false,
  );
  var res = await customPostRequest(url: url, body: body);
  if (res == null) {
    dismissDialog();
    return;
  }
  if (res.statusCode == HttpStatus.ok) {
    setToken(jsonDecode(res.body)["token"]).then((_) {
      dismissDialog();
      Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
          HomeScreen.routeName, (route) => false,
          arguments: 0);
      return;
    });
    return;
  }
  dismissDialog();
  await handleError(res);
}
