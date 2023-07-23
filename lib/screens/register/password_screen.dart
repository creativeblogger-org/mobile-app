import 'dart:convert';

import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/auth.dart';
import 'package:creative_blogger_app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChoosePasswordScreen extends StatefulWidget {
  const ChoosePasswordScreen({super.key});
  static const routeName = '/register/password';

  @override
  State<ChoosePasswordScreen> createState() => _ChoosePasswordScreenState();
}

class _ChoosePasswordScreenState extends State<ChoosePasswordScreen> {
  final _password = TextEditingController();
  String? _passwordError;
  bool passwordVisible = false;
  bool connecting = false;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PasswordScreenArguments;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(21, 184, 166, 1),
                Color.fromRGBO(99, 102, 241, 1)
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.create_a_password,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
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
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _passwordError == null &&
                      _password.text.isNotEmpty &&
                      !connecting
                  ? () => authRequest(
                      context,
                      (isConnecting) =>
                          setState(() => connecting = isConnecting),
                      Uri.parse("$API_URL/auth/register"),
                      jsonEncode({
                        "username": args.username,
                        "email": args.email,
                        "password": _password.text
                      }))
                  : null,
              child: Text(AppLocalizations.of(context)!.create_an_account),
            )
          ],
        ),
      ),
    );
  }
}
