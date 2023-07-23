import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'dart:io';
import 'package:creative_blogger_app/screens/home.dart';
import 'package:creative_blogger_app/screens/loading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

BuildContext? dcontext;

void dismissDialog() {
  if (dcontext != null) {
    Navigator.pop(dcontext!);
  }
}

void authRequest(
  BuildContext context,
  Function(bool connecting) setConnecting,
  Uri url,
  String body,
) {
  setConnecting(true);
  showDialog(
    context: context,
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
      dismissDialog();
      showDialog(
        context: context,
        builder: (innerContext) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text(AppLocalizations.of(context)!.incorrect_credentials),
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
      return;
    }
    if (res.statusCode == HttpStatus.ok) {
      String token = jsonDecode(res.body)["token"];
      storage.write(key: "token", value: token).then((_) {
        dismissDialog();
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (Route<dynamic> route) => false);
        setConnecting(false);
      });
      return;
    }

    if (res.statusCode == 218) {
      return;
    }

    dismissDialog();
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
