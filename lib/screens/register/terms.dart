import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/screens/register/email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key, required this.username});

  final String username;

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.terms_and_conditions_title),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(AppLocalizations.of(context)!.terms_and_conditions),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChooseEmailScreen(username: widget.username),
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.accept_and_continue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
