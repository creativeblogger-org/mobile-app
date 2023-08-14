import 'dart:io';

import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/register/terms.dart';
import 'package:creative_blogger_app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class BirthdateScreen extends StatefulWidget {
  const BirthdateScreen({super.key, required this.username});

  final String username;

  static const routeName = "/register/birthdate";

  @override
  State<BirthdateScreen> createState() => _BirthdateScreenState();
}

class _BirthdateScreenState extends State<BirthdateScreen> {
  DateTime? _date;
  bool _isDialogOpen = false;

  void _showDatePicker() {
    setState(() => _isDialogOpen = true);
    showDatePicker(
      context: context,
      initialDate: _date == null ? DateTime.now() : _date!,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then(
      (date) => setState(
        () {
          if (date != null) {
            _date = date;
          }
          _isDialogOpen = false;
        },
      ),
    );
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
              AppLocalizations.of(context)!.birthdate,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isDialogOpen ? null : _showDatePicker,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                _date == null
                    ? AppLocalizations.of(context)!.tap_to_select_your_birthdate
                    : DateFormat.yMMMd(Platform.localeName).format(_date!),
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _date != null
                  ? () => Navigator.pushNamed(
                        context,
                        TermsScreen.routeName,
                        arguments: TermsAndEmailScreenArguments(
                            widget.username, _date!),
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
