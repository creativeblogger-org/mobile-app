import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/screens/home.dart';
import 'package:creative_blogger_app/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

void customRequest(
  BuildContext context,
  Function(bool value) setConnecting,
  Uri url,
  Object? body,
  Map<String, String>? headers,
) {
  setConnecting(true);
  showDialog(
    context: context,
    builder: (context) => const Dialog.fullscreen(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
      child: SpinKitSpinningLines(
        color: Colors.blue,
        size: 100,
        duration: Duration(milliseconds: 1500),
      ),
    ),
    barrierDismissible: false,
  );
  http
      .post(
    url,
    body: body,
    headers: headers,
  )
      .onError((error, stackTrace) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.internet_error),
      ),
    );
    setConnecting(false);
    return http.Response("", 218);
  }).then((res) {
    if (res.statusCode == HttpStatus.unauthorized) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.error),
            content: Text(AppLocalizations.of(context)!.incorrect_credentials),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.ok,
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        },
      ).then(
        (_) => setConnecting(false),
      );
      return;
    }
    if (res.statusCode == HttpStatus.ok) {
      String token = jsonDecode(res.body)["token"];
      storage.write(key: "token", value: token).then((_) {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (Route<dynamic> route) => false);
        setConnecting(false);
      });
      return;
    }

    if (res.statusCode == 218) {
      return;
    }

    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.error),
        content: Text(jsonDecode(res.body)["errors"][0]["message"]),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(innerContext);
            },
            child: Text(
              AppLocalizations.of(context)!.ok,
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    ).then(
      (_) => setConnecting(false),
    );
  });
}
