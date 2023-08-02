import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/components/custom_error_while_loading.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:creative_blogger_app/utils/login.dart';
import 'package:creative_blogger_app/utils/me_route.dart';
import 'package:creative_blogger_app/utils/profile.dart';
import 'package:creative_blogger_app/utils/structs/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  bool _isUpdateAccountLoading = false;
  bool _isDeleteAccountLoading = false;

  Future<void> _confirmDeleteAccount() async {
    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.are_you_sure),
        content: Text(AppLocalizations.of(context)!
            .this_is_irreversible_all_your_posts_comments_and_shorts_will_be_deleted_forever),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(innerContext);
              },
              child: Text(AppLocalizations.of(context)!.cancel)),
          ElevatedButton(
            onPressed: !_isDeleteAccountLoading
                ? () {
                    deleteAccount().then((fine) {
                      setState(() => _isDeleteAccountLoading = false);
                      if (fine) {
                        Navigator.pop(innerContext);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginScreen.routeName,
                          (route) => false,
                        );
                      }
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: _isDeleteAccountLoading
                ? const CircularProgressIndicator(color: Colors.red)
                : Text(AppLocalizations.of(context)!.im_sure),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getMe();
  }

  void _getMe() {
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _isLoading = true);
          _getMe();
        },
        child: _isLoading
            ? const Center(
                child: SpinKitSpinningLines(
                  color: Colors.blue,
                  size: 100,
                  duration: Duration(milliseconds: 1500),
                ),
              )
            : me == null
                ? CustomErrorWhileLoadingComponent(
                    message: AppLocalizations.of(context)!
                        .an_error_occured_while_loading_profile,
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Form(
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: me!.pp == null
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              radius: 50,
                              child: Expanded(
                                child: me!.pp == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                      )
                                    : Image.network(me!.pp!, errorBuilder:
                                        (context, error, stackTrace) {
                                        return const Icon(Icons.person);
                                      }),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _usernameEditingController,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.username,
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
                                labelText: AppLocalizations.of(context)!
                                    .change_password,
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
                                      _passwordError == null &&
                                      !_isUpdateAccountLoading
                                  ? () {
                                      setState(
                                          () => _isUpdateAccountLoading = true);
                                      updateProfile(
                                              _usernameEditingController.text,
                                              _emailEditingController.text,
                                              _passwordEditingController.text)
                                          .then(
                                        (value) => setState(() =>
                                            _isUpdateAccountLoading = false),
                                      );
                                    }
                                  : null,
                              child: _isUpdateAccountLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 3),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!
                                          .update_account,
                                    ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: !_isDeleteAccountLoading &&
                                        !_isLoading &&
                                        !_isUpdateAccountLoading
                                    ? deleteAccount
                                    : null,
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
      ),
    );
  }
}
