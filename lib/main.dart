import 'package:creative_blogger_app/screens/create_post_screen.dart';
import 'package:creative_blogger_app/screens/loading.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:creative_blogger_app/screens/home/home.dart';
import 'package:creative_blogger_app/screens/post.dart';
import 'package:creative_blogger_app/screens/profile.dart';
import 'package:creative_blogger_app/screens/register/birthdate_screen.dart';
import 'package:creative_blogger_app/screens/register/email_screen.dart';
import 'package:creative_blogger_app/screens/register/password_screen.dart';
import 'package:creative_blogger_app/screens/register/terms.dart';
import 'package:creative_blogger_app/screens/register/username_screen.dart';
import 'package:creative_blogger_app/screens/user.dart';
import 'package:creative_blogger_app/utils/routes.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

// ignore: constant_identifier_names
const API_URL = "https://api.creativeblogger.org";
// ignore: constant_identifier_names
const FRONT_URL = "https://creativeblogger.org";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creative Blogger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade800,
          ),
        ),
        appBarTheme: const AppBarTheme(
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white)),
        colorScheme: ColorScheme.light(primary: Colors.blue.shade800),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade800,
          ),
        ),
        colorScheme: const ColorScheme.dark(primary: Colors.blue),
      ),
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: {
        LoadingScreen.routeName: (context) => const LoadingScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        ChooseUsernameScreen.routeName: (context) =>
            const ChooseUsernameScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case BirthdateScreen.routeName:
            final arg = settings.arguments as String;

            return MaterialPageRoute(
                builder: (context) => BirthdateScreen(username: arg));

          case TermsScreen.routeName:
            final args = settings.arguments as TermsAndEmailScreenArguments;

            return MaterialPageRoute(
              builder: (context) => TermsScreen(
                username: args.username,
                birthdate: args.birthdate,
              ),
            );
          case ChooseEmailScreen.routeName:
            final args = settings.arguments as TermsAndEmailScreenArguments;

            return MaterialPageRoute(
              builder: (context) => ChooseEmailScreen(
                  username: args.username, birthdate: args.birthdate),
            );
          case ChoosePasswordScreen.routeName:
            final args = settings.arguments as PasswordScreenArguments;

            return MaterialPageRoute(
              builder: (context) => ChoosePasswordScreen(
                username: args.username,
                birthdate: args.birthdate,
                email: args.email,
              ),
            );
          case PostScreen.routeName:
            final postSlug = settings.arguments as String;

            return MaterialPageRoute(
                builder: (context) => PostScreen(slug: postSlug));

          case UserScreen.routeName:
            final userName = settings.arguments as String;

            return MaterialPageRoute(
                builder: (context) => UserScreen(username: userName));
          case CreatePostScreen.routeName:
            final (post, onReload) = settings.arguments as (Post?, Function);

            return MaterialPageRoute(
              builder: (context) => CreatePostScreen(
                post: post,
                onReload: onReload,
              ),
            );
          default:
            return null;
        }
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
    );
  }
}
