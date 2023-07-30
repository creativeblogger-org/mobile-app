import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/register/email_screen.dart';
import 'package:creative_blogger_app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key, required this.username});
  static const routeName = '/register/terms';

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
          decoration: customDecoration(),
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
                  Navigator.pushReplacementNamed(
                    context,
                    ChooseEmailScreen.routeName,
                    arguments: widget.username,
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
