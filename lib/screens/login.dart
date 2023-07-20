import 'dart:convert';
import 'dart:io';

import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/home.dart';
import 'package:creative_blogger_app/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

var usernameValidCharacters = RegExp(r'^[a-zA-Z][\w]{2,}$');
var emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

String? isUsernameValid(String username, BuildContext context) {
  if (usernameValidCharacters.hasMatch(username)) {
    return null;
  }
  return AppLocalizations.of(context)!.invalid_username;
}

String? isEmailValid(String email, BuildContext context) {
  if (emailRegex.hasMatch(email)) {
    return null;
  }
  return AppLocalizations.of(context)!.invalid_email_address;
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  final _usernameOrEmail = TextEditingController();
  String? _usernameOrEmailError;
  final _password = TextEditingController();
  String? _passwordError;

  @override
  void dispose() {
    _usernameOrEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.welcome_back,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize)),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.username_or_email,
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: _usernameOrEmailError,
                  errorMaxLines: 5,
                ),
                controller: _usernameOrEmail,
                onChanged: (_) {
                  setState(
                    () => _usernameOrEmailError =
                        _usernameOrEmail.text.contains("@")
                            ? isEmailValid(_usernameOrEmail.text, context)
                            : isUsernameValid(_usernameOrEmail.text, context),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => passwordVisible = !passwordVisible),
                      icon: const Icon(Icons.remove_red_eye)),
                  suffixIconColor: passwordVisible ? Colors.red : Colors.grey,
                  labelText: AppLocalizations.of(context)!.password,
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: _passwordError,
                  errorMaxLines: 5,
                ),
                controller: _password,
                onChanged: (_) => setState(() => _password.text.length < 8
                    ? _passwordError =
                        AppLocalizations.of(context)!.password_too_short
                    : _passwordError = null),
              ),
              const SizedBox(height: 10),
              Container(
                height: 40,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(21, 184, 166, 1),
                      Color.fromRGBO(99, 102, 241, 1)
                    ])),
                child: ElevatedButton(
                  onPressed: _usernameOrEmailError == null &&
                          _passwordError == null &&
                          _usernameOrEmail.text.isNotEmpty &&
                          _password.text.isNotEmpty
                      ? () {
                          http.post(Uri.parse("$API_URL/auth/login"),
                              body: jsonEncode({
                                "username": _usernameOrEmail.text,
                                "password": _password.text
                              }),
                              headers: {
                                "Content-Type": "application/json"
                              }).then((res) {
                            if (res.statusCode == HttpStatus.unauthorized) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context)!.error),
                                    content: Text(AppLocalizations.of(context)!
                                        .incorrect_credentials),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!.ok),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            }
                            if (res.statusCode == HttpStatus.ok) {
                              String token = jsonDecode(res.body)["token"];
                              storage
                                  .write(key: "token", value: token)
                                  .then((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              });
                            }
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      disabledBackgroundColor: Colors.grey),
                  child: Ink(
                    child: Text(AppLocalizations.of(context)!.login),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
