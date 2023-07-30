import 'package:creative_blogger_app/screens/loading.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:creative_blogger_app/screens/home/home.dart';
import 'package:creative_blogger_app/screens/post.dart';
import 'package:creative_blogger_app/screens/profile.dart';
import 'package:creative_blogger_app/screens/register/email_screen.dart';
import 'package:creative_blogger_app/screens/register/password_screen.dart';
import 'package:creative_blogger_app/screens/register/terms.dart';
import 'package:creative_blogger_app/screens/register/username_screen.dart';
import 'package:creative_blogger_app/screens/user.dart';
import 'package:creative_blogger_app/utils/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connection_notifier/connection_notifier.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

// ignore: constant_identifier_names
const API_URL = "https://api.creativeblogger.org";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ConnectionNotifier(
      alignment: AlignmentDirectional.bottomCenter,
      child: MaterialApp(
        title: 'Creative Blogger',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
          ),
          colorScheme: const ColorScheme.light(primary: Colors.blue),
        ),
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
          ),
          colorScheme: ColorScheme.dark(primary: Colors.blue.shade800),
        ),
        initialRoute: '/',
        navigatorKey: navigatorKey,
        routes: {
          LoadingScreen.routeName: (context) => const LoadingScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          ChooseUsernameScreen.routeName: (context) =>
              const ChooseUsernameScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == TermsScreen.routeName) {
            final arg = settings.arguments as String;

            return MaterialPageRoute(
                builder: (context) => TermsScreen(username: arg));
          }

          if (settings.name == ChooseEmailScreen.routeName) {
            final arg = settings.arguments as String;

            return MaterialPageRoute(
                builder: (context) => ChooseEmailScreen(username: arg));
          }

          if (settings.name == ChoosePasswordScreen.routeName) {
            final args = settings.arguments as PasswordScreenArguments;

            return MaterialPageRoute(
                builder: (context) => ChoosePasswordScreen(args: args));
          }

          if (settings.name == HomeScreen.routeName) {
            final index = settings.arguments as int;

            return MaterialPageRoute(
                builder: (context) => HomeScreen(index: index));
          }

          if (settings.name == PostScreen.routeName) {
            final postSlug = settings.arguments as String;

            return MaterialPageRoute(
                builder: (context) => PostScreen(slug: postSlug));
          }

          if (settings.name == UserScreen.routeName) {
            final userName = settings.arguments as String;

            return MaterialPageRoute(
                builder: (context) => UserScreen(username: userName));
          }

          return null;
        },
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
      ),
    );
  }
}
