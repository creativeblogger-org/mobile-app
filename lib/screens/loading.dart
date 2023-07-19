import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

const storage = FlutterSecureStorage();

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    var connectionStatus = ConnectionStatus.loading;

    return connectionStatus == ConnectionStatus.loading ? Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)!.loading),
        )
    ) : connectionStatus == ConnectionStatus.notConnected ? const LoginScreen()
    : const HomeScreen(title: "Creative Blogger");
  }
}