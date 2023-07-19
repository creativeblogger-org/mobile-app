import 'package:creative_blogger_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

var validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

bool is_username_valid(String username) {
  if (validCharacters.hasMatch(username) &&
      RegExp(r'^[a-zA-Z]+$').hasMatch(username[0])) {
    return true;
  }
  return false;
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  final _username = TextEditingController();
  String? _username_error;

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
                  errorText: _username_error,
                ),
                controller: _username,
                onChanged: (_) {
                  setState(() {
                    if (_username.text.length < 3) {
                      _username_error = "Erreur 1";
                    }
                    if (is_username_valid(_username.text)) {
                      _username_error = "Erreur 2";
                    }
                    _username_error = null;
                  });
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
                        borderRadius: BorderRadius.circular(12))),
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
                  onPressed: () {
                    http.get(Uri.parse("$API_URL/login")).then((res) {});
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
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
