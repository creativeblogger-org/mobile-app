import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/login.dart';
import 'package:creative_blogger_app/utils/me_route.dart';
import 'package:creative_blogger_app/utils/structs/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileSreen extends StatefulWidget {
  const ProfileSreen({super.key});

  static const routeName = "/profile";

  @override
  State<ProfileSreen> createState() => _ProfileSreenState();
}

class _ProfileSreenState extends State<ProfileSreen> {
  User? me;
  bool isLoading = true;
  TextEditingController usernameEditingController = TextEditingController();
  String? _usernameError;
  TextEditingController emailEditingController = TextEditingController();
  String? _emailError;

  @override
  void initState() {
    super.initState();
    getMe().then(
      (value) {
        usernameEditingController.text = value!.username;
        emailEditingController.text = value.email;
        setState(
          () {
            me = value;
            isLoading = false;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        flexibleSpace: Container(
          decoration: customDecoration(),
        ),
      ),
      body: isLoading
          ? const Center(
              child: SpinKitSpinningLines(
                color: Colors.blue,
                size: 100,
                duration: Duration(milliseconds: 1500),
              ),
            )
          : me == null
              ? Text(AppLocalizations.of(navigatorKey.currentContext!)!
                  .an_error_occured_while_loading_profile)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: me!.pp == null
                              ? const Icon(Icons.person)
                              : Image.network(me!.pp!),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: usernameEditingController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.username,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorText: _usernameError,
                            errorMaxLines: 5,
                          ),
                          onChanged: (_) {
                            (_) {
                              setState(() => _usernameError = isUsernameValid(
                                  usernameEditingController.text));
                            };
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: emailEditingController,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.email_address,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorText: _emailError,
                            errorMaxLines: 5,
                          ),
                          onChanged: (_) {
                            (_) {
                              setState(() => _emailError =
                                  isEmailValid(emailEditingController.text));
                            };
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                            "Compté créé le ${me!.createdAt.day.toString().padLeft(2, "0")}/${me!.createdAt.month.toString().padLeft(2, "0")}/${me!.createdAt.year}"),
                        const SizedBox(height: 16),
                        CustomButton(
                          onPressed:
                              _usernameError == null && _emailError == null
                                  ? () {}
                                  : null,
                          child: Text(""),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
