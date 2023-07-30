import 'dart:io';

import 'package:async/async.dart';
import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/register/password_screen.dart';
import 'package:creative_blogger_app/utils/login.dart';
import 'package:creative_blogger_app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class ChooseEmailScreen extends StatefulWidget {
  const ChooseEmailScreen({super.key, required this.username});
  static const routeName = '/register/email';

  final String username;

  @override
  State<ChooseEmailScreen> createState() => _ChooseEmailScreenState();
}

class _ChooseEmailScreenState extends State<ChooseEmailScreen> {
  final _email = TextEditingController();
  String? _emailError;
  String _emailAlreadyExistsText = "";
  var _emailAlreadyExistsColor = Colors.green;
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _username_exists(String email) async {
    var res = await http
        .get(Uri.parse("$API_URL/verif/email/$email"))
        .onError((error, stackTrace) {
      return http.Response("", 218);
    });
    if (res.statusCode == HttpStatus.notFound) {
      setState(() {
        _emailAlreadyExistsText =
            AppLocalizations.of(navigatorKey.currentContext!)!.available;
        _emailAlreadyExistsColor = Colors.green;
      });
      return;
    }
    if (res.statusCode == HttpStatus.ok) {
      setState(() {
        _emailError =
            AppLocalizations.of(navigatorKey.currentContext!)!.not_available;
      });
      return;
    }
    ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(res.statusCode == 218
            ? AppLocalizations.of(navigatorKey.currentContext!)!.internet_error
            : AppLocalizations.of(navigatorKey.currentContext!)!.error),
      ),
    );
  }

  CancelableOperation? _myCancelableFuture;

  void checkUsername(BuildContext context, String username) async {
    if (_isLoading) {
      await _myCancelableFuture?.cancel();
    }

    setState(() {
      _isLoading = true;
      _emailAlreadyExistsText = AppLocalizations.of(context)!.checking;
      _emailAlreadyExistsColor = Colors.grey;
    });

    _myCancelableFuture =
        CancelableOperation.fromFuture(_username_exists(username));

    await _myCancelableFuture?.value;

    setState(() => _isLoading = false);

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.create_an_account),
        flexibleSpace: Container(
          decoration: customDecoration(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.welcome,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email_address,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: _emailError,
                errorMaxLines: 5,
              ),
              controller: _email,
              onChanged: (_) {
                setState(() => _emailError = isEmailValid(_email.text));

                if (_emailError == null) {
                  checkUsername(context, _email.text);
                }
              },
            ),
            Visibility(
              visible: _emailError == null,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    _emailAlreadyExistsText,
                    style: TextStyle(
                      color: _emailAlreadyExistsColor,
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _emailError == null &&
                      !_isLoading &&
                      _email.text.isNotEmpty
                  ? () => Navigator.pushNamed(
                      context, ChoosePasswordScreen.routeName,
                      arguments:
                          PasswordScreenArguments(widget.username, _email.text))
                  : null,
              child: Text(AppLocalizations.of(context)!.continue_text),
            )
          ],
        ),
      ),
    );
  }
}
