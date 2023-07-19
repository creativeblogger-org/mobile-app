import 'dart:io';

import 'package:creative_blogger_app/screens/loading.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

enum ConnectionStatus {
  loading,
  connected,
  notConnected,
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<ConnectionStatus> getConnectionStatus() async {
    String? token = await storage.read(key: "token");
    if (token == null) {
      return ConnectionStatus.notConnected;
    } else if (token.trim().isEmpty) {
      return ConnectionStatus.notConnected;
    } else {
      var res = await http.get(Uri.parse("https://api.creativeblogger.org/@me"), headers: {"Authorization": "Bearer $token"});
      if (res.statusCode == HttpStatus.ok) {
        return ConnectionStatus.connected;
      } else if (res.statusCode == HttpStatus.unauthorized) {
        return ConnectionStatus.notConnected;
      }
      return  ConnectionStatus.connected;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Creative Blogger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      supportedLocales: const [
        Locale("en"),
        Locale("fr"),
        Locale("it"),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: FutureBuilder(future: getConnectionStatus(),
      builder: (BuildContext context, AsyncSnapshot<ConnectionStatus> snapshot) {
        return !snapshot.hasData ? const LoadingScreen() : snapshot.data == ConnectionStatus.notConnected ? const LoginScreen() : const HomeScreen(title: "Creative Blogger");
        }
      )
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
