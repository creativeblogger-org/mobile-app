import 'dart:io';

import 'package:async/async.dart';
import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/register/password_screen.dart';
import 'package:creative_blogger_app/utils/custom_request.dart';
import 'package:creative_blogger_app/utils/login.dart';
import 'package:creative_blogger_app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseEmailScreen extends StatefulWidget {
  const ChooseEmailScreen(
      {super.key, required this.username, required this.birthdate});
  static const routeName = '/register/email';

  final String username;
  final String birthdate;

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

  Future<void> _usernameExists(String email) async {
    var res = await customGetRequest("$API_URL/verif/email/$email");
    if (res == null) {
      setState(() => _emailError =
          AppLocalizations.of(navigatorKey.currentContext!)!
              .no_Internet_connection);
      return;
    }

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
  }

  CancelableOperation? _myCancelableFuture;

  void checkUsername(String username) async {
    if (_isLoading) {
      await _myCancelableFuture?.cancel();
    }

    setState(() {
      _isLoading = true;
      _emailAlreadyExistsText =
          AppLocalizations.of(navigatorKey.currentContext!)!.checking;
      _emailAlreadyExistsColor = Colors.grey;
    });

    _myCancelableFuture =
        CancelableOperation.fromFuture(_usernameExists(username));

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
              onChanged: (email) {
                setState(() => _emailError = isEmailValid(email));

                if (_emailError == null) {
                  checkUsername(email);
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
              onPressed:
                  _emailError == null && !_isLoading && _email.text.isNotEmpty
                      ? () => Navigator.pushNamed(
                          context, ChoosePasswordScreen.routeName,
                          arguments: PasswordScreenArguments(
                              widget.username, widget.birthdate, _email.text))
                      : null,
              child: Text(AppLocalizations.of(context)!.continue_text),
            )
          ],
        ),
      ),
    );
  }
}
