import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/utils/user.dart';
import 'package:creative_blogger_app/utils/structs/public_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.username});

  static const routeName = "/user";

  final String username;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  PublicUser? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getPublicUser(widget.username).then(
      (user) => setState(
        () {
          _user = user;
          _isLoading = false;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.user),
        flexibleSpace: Container(decoration: customDecoration()),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitSpinningLines(
                color: Colors.blue,
                size: 100,
                duration: Duration(milliseconds: 1500),
              ),
            )
          : _user == null
              ? Center(
                  child: Text(AppLocalizations.of(context)!
                      .an_error_occured_while_loading_user),
                )
              : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          _user!.username,
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .fontSize,
                          ),
                        ),
                        getPermission(_user!.permission),
                        Text(
                          AppLocalizations.of(context)!.signed_up_the(
                            getHumanDate(_user!.createdAt),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}

String getHumanDate(DateTime date) {
  String day = date.day.toString().padLeft(2, "0");
  String month = date.month.toString().padLeft(2, "0");
  int year = date.year;
  return "$day/$month/$year";
}
