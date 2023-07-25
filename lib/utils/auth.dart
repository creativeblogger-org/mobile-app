import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'dart:io';
import 'package:creative_blogger_app/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

BuildContext? dcontext;

void dismissDialog() {
  if (dcontext != null) {
    Navigator.pop(dcontext!);
  }
}

void authRequest(
  Function(bool connecting) setConnecting,
  Uri url,
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
  http.post(
    url,
    body: body,
    headers: {"Content-Type": "application/json"},
  ).onError((error, stackTrace) {
    dismissDialog();
    ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
            AppLocalizations.of(navigatorKey.currentContext!)!.internet_error),
      ),
    );
    setConnecting(false);
    return http.Response("", 218);
  }).then((res) {
    if (res.statusCode == 218) {
      return;
    }
    if (res.statusCode == HttpStatus.ok) {
      setToken(jsonDecode(res.body)["token"]).then((_) {
        dismissDialog();
        Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (Route<dynamic> route) => false);
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
