import 'dart:io';

import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/components/custom_error_while_loading.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:creative_blogger_app/utils/login.dart';
import 'package:creative_blogger_app/utils/me_route.dart';
import 'package:creative_blogger_app/utils/profile.dart';
import 'package:creative_blogger_app/utils/structs/user.dart';
import 'package:creative_blogger_app/utils/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

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
  bool _isEditing = false;
  bool _isPPUpdating = false;

  Future<void> _confirmDeleteAccount() async {
    await showDialog(
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
                ? const SpinKitRing(
                    color: Colors.red,
                    size: 20,
                    lineWidth: 2,
                  )
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
    setState(() => _isLoading = true);
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
              _isEditing = false;
            },
          );
        }
      },
    );
  }

  void _updateProfile(String username, String email, String password) {
    setState(() => _isUpdateAccountLoading = true);
    updateProfile(_usernameEditingController.text, _emailEditingController.text,
            _passwordEditingController.text)
        .then(
      (value) {
        setState(() => _isUpdateAccountLoading = false);
        _getMe();
      },
    );
  }

  Future<bool> _updateProfilePicture(MultipartFile image) async {
    setState(() => _isPPUpdating = true);
    var fine = await updateProfilePicture(image);
    setState(() => _isPPUpdating = false);
    _getMe();
    return fine;
  }

  Future<void> _selectFile() async {
    setState(() => _isPPUpdating = false);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ["png", "jpg", "jpeg"], type: FileType.custom);

    if (result != null) {
      File file = File(result.files.single.path!);
      ImageProvider image = ResizeImage(FileImage(file),
          width: 500, height: 500, policy: ResizeImagePolicy.fit);
      List<int> bytes = file.readAsBytesSync();
      var imageFile = MultipartFile.fromBytes(
        'image',
        bytes,
        filename: result.files.single.name,
        contentType: MediaType('image', result.files.single.extension!),
      );

      showDialog(
        context: context,
        builder: (innerContext) => AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.are_you_sure,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!
                      .do_you_really_want_to_update_your_profile_picture,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: image,
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(innerContext),
                child: Text(AppLocalizations.of(context)!.cancel)),
            ElevatedButton(
                onPressed: _isPPUpdating
                    ? null
                    : () {
                        _updateProfilePicture(imageFile).then((fine) {
                          if (fine) {
                            Navigator.pop(innerContext);
                          }
                        });
                      },
                child: Text(AppLocalizations.of(context)!.yes))
          ],
        ),
      ).then((_) => setState(() => _isPPUpdating = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        flexibleSpace: Container(
          decoration: customDecoration(),
        ),
        actions: [
          IconButton(
              onPressed: () => setState(() => _isEditing = !_isEditing),
              icon: Icon(_isEditing ? Icons.close : Icons.edit))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
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
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: me!.pp == null
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            backgroundImage: me!.pp != null && _isEditing
                                ? NetworkImage(me!.pp!)
                                : null,
                            radius: 50,
                            child: _isEditing
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.2),
                                    child: IconButton(
                                      onPressed: _selectFile,
                                      icon: Icon(
                                        Icons.upload,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                      iconSize: 50,
                                    ),
                                  )
                                : me!.pp == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                      )
                                    : Image.network(me!.pp!, errorBuilder:
                                        (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.person,
                                          size: 50,
                                        );
                                      }),
                          ),
                          const SizedBox(height: 16),
                          _isEditing
                              ? TextField(
                                  controller: _usernameEditingController,
                                  decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.username,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorText: _usernameError,
                                    errorMaxLines: 5,
                                  ),
                                  onChanged: (username) {
                                    setState(() => _usernameError =
                                        isUsernameValid(username));
                                  },
                                )
                              : Text(
                                  me!.username,
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .fontSize),
                                ),
                          const SizedBox(height: 16),
                          _isEditing
                              ? TextField(
                                  controller: _emailEditingController,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!
                                        .email_address,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorText: _emailError,
                                    errorMaxLines: 5,
                                  ),
                                  onChanged: (email) {
                                    setState(() =>
                                        _emailError = isEmailValid(email));
                                  },
                                )
                              : Text(me!.email),
                          const SizedBox(height: 16),
                          if (_isEditing) ...{
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
                              onChanged: (password) {
                                setState(() => _passwordError =
                                    password.isEmpty || password.length >= 8
                                        ? null
                                        : AppLocalizations.of(context)!
                                            .password_too_short);
                              },
                            ),
                            const SizedBox(height: 16),
                          } else ...{
                            Text(
                              AppLocalizations.of(context)!.account_created_the(
                                getHumanDate(me!.createdAt),
                              ),
                            ),
                            const SizedBox(height: 16),
                          },
                          _isEditing
                              ? CustomButton(
                                  onPressed: _usernameError == null &&
                                          _emailError == null &&
                                          _usernameEditingController
                                              .text.isNotEmpty &&
                                          _emailEditingController
                                              .text.isNotEmpty &&
                                          _passwordError == null &&
                                          !_isUpdateAccountLoading
                                      ? () => _updateProfile(
                                            _usernameEditingController.text,
                                            _emailEditingController.text,
                                            _passwordEditingController.text,
                                          )
                                      : null,
                                  child: _isUpdateAccountLoading
                                      ? SpinKitRing(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 20,
                                          lineWidth: 2,
                                        )
                                      : Text(
                                          AppLocalizations.of(context)!
                                              .update_account,
                                        ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: !_isDeleteAccountLoading &&
                                            !_isLoading &&
                                            !_isUpdateAccountLoading
                                        ? _confirmDeleteAccount
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
    );
  }
}
