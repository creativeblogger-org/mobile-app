import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

const storage = FlutterSecureStorage();

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    storage.read(key: "token").then((token) {
      if (token == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else if (token.trim().isEmpty) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        http.get(Uri.parse("$API_URL/@me"),
            headers: {"Authorization": "Bearer $token"}).then((res) {
          if (res.statusCode == HttpStatus.ok) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const HomeScreen(title: "Creative Blogger")));
          } else if (res.statusCode == HttpStatus.unauthorized) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          }
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const HomeScreen(title: "Creative Blogger")));
        });
      }
    });

    return Scaffold(
        body: Center(
            child: Column(children: [
      // CircularProgressIndicator(color: Theme.of(context).primaryColor),
      
      Text(AppLocalizations.of(context)!.loading,
          style: Theme.of(context).textTheme.headlineSmall),
      const SpinKitCubeGrid(
        color: Colors.blue, size: 50, duration: Duration(milliseconds: 500)),
    ])));
  }
}
