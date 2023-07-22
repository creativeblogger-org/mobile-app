import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/screens/register/password_screen.dart';
import 'package:creative_blogger_app/utils/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseEmailScreen extends StatefulWidget {
  const ChooseEmailScreen({super.key, required this.username});

  final String username;

  @override
  State<ChooseEmailScreen> createState() => _ChooseEmailScreenState();
}

class _ChooseEmailScreenState extends State<ChooseEmailScreen> {
  final _email = TextEditingController();
  String? _emailError;

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
                setState(
                    () => _emailError = isEmailValid(context, _email.text));
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _emailError == null && _email.text.isNotEmpty
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChoosePasswordScreen(
                            username: widget.username,
                            email: _email.text,
                          ),
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
