import 'dart:io';

import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/register/terms.dart';
import 'package:creative_blogger_app/utils/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class ChooseUsernameScreen extends StatefulWidget {
  const ChooseUsernameScreen({super.key});

  @override
  State<ChooseUsernameScreen> createState() => _ChooseUsernameScreenState();
}

class _ChooseUsernameScreenState extends State<ChooseUsernameScreen> {
  final _username = TextEditingController();
  String? _usernameError;
  String _username_already_exists_text = "";
  var _username_already_exists_color = Colors.green;
  bool _isLoading = false;

  @override
  void dispose() {
    _username.dispose();
    super.dispose();
  }

  Future<void> _username_exists(BuildContext context, String username) async {
    var res = await http
        .get(Uri.parse("$API_URL/users/$username"))
        .onError((error, stackTrace) {
      return http.Response("", 218);
    });
    if (res.statusCode == HttpStatus.notFound) {
      setState(() {
        _username_already_exists_text = AppLocalizations.of(context)!.available;
        _username_already_exists_color = Colors.green;
      });
      return;
    }
    if (res.statusCode == HttpStatus.ok) {
      setState(() {
        _usernameError = AppLocalizations.of(context)!.not_available;
      });
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res.statusCode == 218
            ? AppLocalizations.of(context)!.internet_error
            : AppLocalizations.of(context)!.error),
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
      _username_already_exists_text = AppLocalizations.of(context)!.checking;
      _username_already_exists_color = Colors.grey;
    });

    _myCancelableFuture =
        CancelableOperation.fromFuture(_username_exists(context, username));

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
              AppLocalizations.of(context)!.welcome,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.username,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: _usernameError,
                errorMaxLines: 5,
              ),
              controller: _username,
              onChanged: (_) {
                setState(() =>
                    _usernameError = isUsernameValid(context, _username.text));

                if (_usernameError == null) {
                  checkUsername(context, _username.text);
                }
              },
            ),
            Visibility(
              visible: _usernameError == null,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    _username_already_exists_text,
                    style: TextStyle(
                      color: _username_already_exists_color,
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _usernameError == null &&
                      !_isLoading &&
                      _username.text.isNotEmpty
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TermsScreen(username: _username.text),
                        ),
                      )
                  : null,
              child: Text(AppLocalizations.of(context)!.continue_text),
            )
          ],
        ),
      ),
    );
  }
}
