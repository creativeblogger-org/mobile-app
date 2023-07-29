import 'dart:convert';

import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/login.dart';
import 'package:creative_blogger_app/utils/me_route.dart';
import 'package:creative_blogger_app/utils/request_error_handling.dart';
import 'package:creative_blogger_app/utils/structs/user.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? me;
  bool _isLoading = true;
  final TextEditingController _usernameEditingController =
      TextEditingController();
  String? _usernameError;
  final TextEditingController _emailEditingController = TextEditingController();
  String? _emailError;
  final TextEditingController _passwordEditingController =
      TextEditingController();
  String? _passwordError;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    getMe().then(
      (value) {
        if (value == null) {
          setState(() => _isLoading = false);
          return;
        }
        _usernameEditingController.text = value.username;
        _emailEditingController.text = value.email;
        if (mounted) {
          setState(
            () {
              me = value;
              _isLoading = false;
            },
          );
        }
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
      body: _isLoading
          ? const Center(
              child: SpinKitSpinningLines(
                color: Colors.blue,
                size: 100,
                duration: Duration(milliseconds: 1500),
              ),
            )
          : me == null
              ? Center(
                  child: Text(AppLocalizations.of(navigatorKey.currentContext!)!
                      .an_error_occured_while_loading_profile),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Form(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 50,
                            child: me!.pp == null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                : Image.network(me!.pp!),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _usernameEditingController,
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
                              setState(() => _usernameError = isUsernameValid(
                                  _usernameEditingController.text));
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _emailEditingController,
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
                              setState(() => _emailError =
                                  isEmailValid(_emailEditingController.text));
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            obscureText: !_passwordVisible,
                            controller: _passwordEditingController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () => setState(() =>
                                      _passwordVisible = !_passwordVisible),
                                  icon: const Icon(Icons.remove_red_eye)),
                              suffixIconColor:
                                  _passwordVisible ? Colors.red : Colors.grey,
                              labelText:
                                  AppLocalizations.of(context)!.change_password,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              errorText: _passwordError,
                              errorMaxLines: 5,
                            ),
                            onChanged: (_) {
                              setState(() => _passwordError =
                                  _passwordEditingController.text.isEmpty ||
                                          _passwordEditingController
                                                  .text.length >
                                              8
                                      ? null
                                      : AppLocalizations.of(context)!
                                          .password_too_short);
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                              "Compté créé le ${me!.createdAt.day.toString().padLeft(2, "0")}/${me!.createdAt.month.toString().padLeft(2, "0")}/${me!.createdAt.year}"),
                          const SizedBox(height: 16),
                          CustomButton(
                            onPressed: _usernameError == null &&
                                    _emailError == null &&
                                    _usernameEditingController
                                        .text.isNotEmpty &&
                                    _emailEditingController.text.isNotEmpty &&
                                    _passwordError == null
                                ? () async {
                                    var body = {
                                      'username':
                                          _usernameEditingController.text,
                                      'email': _emailEditingController.text
                                    };

                                    if (_passwordEditingController
                                        .text.isNotEmpty) {
                                      body['password'] =
                                          _passwordEditingController.text;
                                    }

                                    var res = await http.put(
                                        Uri.parse("$API_URL/@me"),
                                        body: jsonEncode(body),
                                        headers: {
                                          "Content-Type": "application/json",
                                          "Authorization":
                                              "Bearer ${await getToken()}"
                                        });
                                    if (res.statusCode == 204) {
                                      ScaffoldMessenger.of(
                                              navigatorKey.currentContext!)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(
                                              navigatorKey.currentContext!)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AppLocalizations.of(navigatorKey
                                                    .currentContext!)!
                                                .account_updated_successfully,
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      return;
                                    }

                                    handleError(res);
                                  }
                                : null,
                            child: Text(
                                AppLocalizations.of(context)!.update_account),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (innerContext) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!
                                        .are_you_sure),
                                    content: Text(AppLocalizations.of(context)!
                                        .this_is_irreversible_all_your_posts_comments_and_shorts_will_be_deleted_forever),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(innerContext);
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .cancel)),
                                      ElevatedButton(
                                        onPressed: () async {
                                          var res = await http.delete(
                                            Uri.parse("$API_URL/@me"),
                                            headers: {
                                              "Content-Type":
                                                  "application/json",
                                              "Authorization":
                                                  "Bearer ${await getToken()}"
                                            },
                                          );
                                          if (res.statusCode == 204) {
                                            await deleteToken();
                                            Navigator.pop(innerContext);
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              "/login",
                                              (route) => false,
                                            );
                                            return;
                                          }
                                          handleError(res);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .im_sure),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text(AppLocalizations.of(context)!
                                  .delete_my_account),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
