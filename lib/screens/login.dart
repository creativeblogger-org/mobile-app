import 'dart:convert';

import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/register/username_screen.dart';
import 'package:creative_blogger_app/utils/auth.dart';
import 'package:creative_blogger_app/utils/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  final _usernameOrEmail = TextEditingController();
  String? _usernameOrEmailError;
  final _password = TextEditingController();
  String? _passwordError;
  bool connecting = false;

  @override
  void dispose() {
    _usernameOrEmail.dispose();
    _password.dispose();
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
              Text(
                AppLocalizations.of(context)!.welcome_back,
                style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineMedium!.fontSize,
                ),
              ),
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
                            ? isEmailValid(_usernameOrEmail.text)
                            : isUsernameValid(_usernameOrEmail.text),
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
                onChanged: (_) => setState(
                  () => _password.text.length < 8
                      ? _passwordError =
                          AppLocalizations.of(context)!.password_too_short
                      : _passwordError = null,
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _usernameOrEmailError == null &&
                        _passwordError == null &&
                        _usernameOrEmail.text.isNotEmpty &&
                        _password.text.isNotEmpty &&
                        !connecting
                    ? () {
                        setState(() => connecting = true);
                        authRequest(
                          "$API_URL/auth/login",
                          jsonEncode(
                            {
                              "username": _usernameOrEmail.text,
                              "password": _password.text
                            },
                          ),
                        ).then((_) => setState(() => connecting = false));
                      }
                    : null,
                child: Text(AppLocalizations.of(context)!.login),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  ChooseUsernameScreen.routeName,
                ),
                child: Text(AppLocalizations.of(context)!.need_an_account),
              )
            ],
          ),
        ),
      ),
    );
  }
}
