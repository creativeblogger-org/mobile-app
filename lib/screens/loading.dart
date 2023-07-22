import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/home.dart';
import 'package:creative_blogger_app/screens/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  static const routeName = '/';

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

const storage = FlutterSecureStorage();

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    storage.read(key: "token").then((token) {
      if (token == null) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      } else if (token.trim().isEmpty) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      } else {
        http.get(Uri.parse("$API_URL/@me"),
            headers: {"Authorization": "Bearer $token"}).then((res) {
          if (res.statusCode == HttpStatus.ok) {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          } else if (res.statusCode == HttpStatus.unauthorized) {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitSpinningLines(
          color: Colors.blue,
          size: 100,
          duration: Duration(milliseconds: 1500),
        ),
      ),
    );
  }
}
