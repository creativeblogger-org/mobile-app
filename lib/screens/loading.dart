import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

const storage = FlutterSecureStorage();

enum ConnectionStatus {
  loading,
  connected,
  notConnected,
  noInternetConnection
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    storage.read(key: "token").then((token) => {
      if (token == null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()))
      } else if (token.trim().isEmpty) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()))
      } else {
        http.get(Uri.parse("https://api.creativeblogger.org/@me"), headers: {"Authorization": "Bearer $token"}).then((res) => {
          if (res.statusCode == HttpStatus.ok) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage(title: "Creative Blogger")))
          } else if (res.statusCode == HttpStatus.unauthorized) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()))
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage(title: "Creative Blogger")))
          }
        })
      }
    });

    return SafeArea(
      child: Center(
        child: Text(AppLocalizations.of(context)!.loading),
      )
    );
  }
}