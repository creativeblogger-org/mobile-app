import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/home.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:creative_blogger_app/screens/main_screen_with_bottom_app_bar.dart';
import 'package:creative_blogger_app/utils/token.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  static const routeName = '/';

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getToken().then((token) {
      if (token.isEmpty) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        return;
      }
      http.get(Uri.parse("$API_URL/@me"),
          headers: {"Authorization": "Bearer $token"}).then((res) {
        if (res.statusCode == HttpStatus.ok) {
          Navigator.pushReplacementNamed(
              context, MainScreenWithBottomAppBar.routeName);
        } else if (res.statusCode == HttpStatus.unauthorized) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
        Navigator.pushReplacementNamed(
            context, MainScreenWithBottomAppBar.routeName);
      });
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
