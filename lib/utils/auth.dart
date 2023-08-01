import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/home/home.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
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

void authRequest(
  Function(bool connecting) setConnecting,
  String url,
  String body,
) {
  setConnecting(true);
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
  customPostRequest(url: url, body: body).then((res) {
    if (res.statusCode == HttpStatus.ok) {
      setToken(jsonDecode(res.body)["token"]).then((_) {
        dismissDialog();
        Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (route) => false,
            arguments: 0);
        setConnecting(false);
        return;
      });
      return;
    }
    dismissDialog();
    setConnecting(false);
    handleError(res);
  });
}
