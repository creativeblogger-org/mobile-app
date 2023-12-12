import 'dart:io';

import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/utils/post.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

var urlRegex = RegExp(
    r"^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$");

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key, this.post, required this.onReload});

  final Post? post;
  final Function onReload;

  static const routeName = "/create/post";

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

enum Category {
  fakeOrReal("fakeorreal"),
  tech("tech"),
  culture("culture"),
  news("news"),
  sport("sport"),
  cinema("cinema"),
  litterature("litterature");

  const Category(this.value);
  final String value;
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  Category? _category;
  bool _isCreatePostLoading = false;

  final TextEditingController _postTitle = TextEditingController();
  String? _postTitleError;
  final TextEditingController _postDescription = TextEditingController();
  String? _postDescriptionError;
  final TextEditingController _postContent = TextEditingController();
  String? _postContentError;
  bool _ageRestricted = false;
  final TextEditingController _minimumAge = TextEditingController();
  String? _minimumAgeError;
  MultipartFile? _postImageFile;
  ImageProvider? _postImage;

  @override
  void initState() {
    _category = widget.post?.category;
    _postTitle.text = widget.post?.title ?? "";
    _postDescription.text = widget.post?.description ?? "";
    _postContent.text = widget.post?.content ?? "";
    _minimumAge.text = widget.post?.requiredAge.toString() ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _postTitle.dispose();
    _postDescription.dispose();
    _postContent.dispose();
    _minimumAge.dispose();
    super.dispose();
  }

  void _publishPost(
    String title,
    MultipartFile imageFile,
    String description,
    String tags,
    String content,
    int requiredAge,
  ) {
    setState(() => _isCreatePostLoading = true);
    createPost(title, imageFile, description, tags, content, requiredAge).then(
      (fine) {
        setState(() => _isCreatePostLoading = false);
        if (fine) {
          Navigator.pop(context);
          widget.onReload();
        }
      },
    );
  }

  void _updatePost(
    int id,
    String title,
    String description,
    String tags,
    String content,
  ) {
    setState(() => _isCreatePostLoading = true);
    updatePost(id, widget.post!.slug, title, description, tags, content).then(
      (fine) {
        setState(() => _isCreatePostLoading = false);
        if (fine) {
          Navigator.pop(context);
          widget.onReload();
        }
      },
    );
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ["png", "jpg", "jpeg"], type: FileType.custom);

    if (result != null) {
      File file = File(result.files.single.path!);
      List<int> bytes = file.readAsBytesSync();
      var imageFile = MultipartFile.fromBytes(
        'image',
        bytes,
        filename: result.files.single.name,
        contentType: MediaType('image', result.files.single.extension!),
      );
      setState(() {
        _postImageFile = imageFile;
        _postImage = FileImage(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: customDecoration(),
        ),
        title: Text(widget.post == null
            ? AppLocalizations.of(context)!.publish_post
            : AppLocalizations.of(context)!.update_post),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.title,
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: _postTitleError,
                ),
                controller: _postTitle,
                onChanged: (value) {
                  int length = value.trim().length;
                  setState(
                    () => _postTitleError = length < 3
                        ? AppLocalizations.of(context)!.title_too_short
                        : length > 30
                            ? AppLocalizations.of(context)!.title_too_long
                            : null,
                  );
                },
              ),
              if (widget.post == null) ...[
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.image,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize),
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  backgroundColor: _postImage == null
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  backgroundImage: _postImage,
                  radius: 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.2),
                    child: IconButton(
                      onPressed: _isCreatePostLoading ? null : _selectFile,
                      icon: Icon(
                        Icons.upload,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      iconSize: 50,
                    ),
                  ),
                )
              ],
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: _postDescriptionError,
                ),
                controller: _postDescription,
                onChanged: (value) {
                  int length = value.trim().length;
                  setState(
                    () => _postDescriptionError = length < 10
                        ? AppLocalizations.of(context)!.description_too_short
                        : length > 100
                            ? AppLocalizations.of(context)!.description_too_long
                            : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.category,
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall!.fontSize),
              ),
              for (var category in Category.values) ...{
                RadioListTile(
                  title: Text(
                    category == Category.fakeOrReal
                        ? AppLocalizations.of(context)!.investigation
                        : category == Category.tech
                            ? AppLocalizations.of(context)!.tech
                            : category == Category.culture
                                ? AppLocalizations.of(context)!.culture
                                : category == Category.news
                                    ? AppLocalizations.of(context)!.news
                                    : category == Category.sport
                                        ? AppLocalizations.of(context)!.sport
                                        : category == Category.cinema
                                            ? AppLocalizations.of(context)!
                                                .cinema
                                            : AppLocalizations.of(context)!
                                                .literature,
                  ),
                  value: category,
                  groupValue: _category,
                  onChanged: (Category? category) {
                    setState(() => _category = category);
                  },
                ),
              },
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _ageRestricted,
                onChanged: (value) =>
                    setState(() => _ageRestricted = !_ageRestricted),
                title: Text(AppLocalizations.of(context)!.age_restriction),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 16),
              if (_ageRestricted) ...{
                TextField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.minimum_age,
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: _minimumAgeError,
                  ),
                  controller: _minimumAge,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(
                        () => _minimumAgeError = AppLocalizations.of(context)!
                            .the_required_age_must_be_between_9_and_140_years_old,
                      );
                      return;
                    }
                    var requiredAge = int.parse(value);
                    setState(
                      () => _minimumAgeError = requiredAge < 9 ||
                              requiredAge > 140
                          ? AppLocalizations.of(context)!
                              .the_required_age_must_be_between_9_and_140_years_old
                          : null,
                    );
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
              },
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.content,
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: _postContentError,
                ),
                controller: _postContent,
                maxLines: null,
                onChanged: (value) {
                  int length = value.trim().length;
                  setState(
                    () => _postContentError = length < 200
                        ? AppLocalizations.of(context)!.content_too_short
                        : length > 10000
                            ? AppLocalizations.of(context)!.content_too_long
                            : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _postTitleError != null ||
                        _postTitle.text.isEmpty ||
                        (_postImageFile == null && widget.post == null) ||
                        _postDescriptionError != null ||
                        _postDescription.text.isEmpty ||
                        _category == null ||
                        _postContentError != null ||
                        _postContent.text.isEmpty ||
                        (_ageRestricted &&
                            (_minimumAgeError != null ||
                                _minimumAge.text.isEmpty)) ||
                        _isCreatePostLoading
                    ? null
                    : () {
                        widget.post == null
                            ? _publishPost(
                                _postTitle.text,
                                _postImageFile!,
                                _postDescription.text,
                                _category!.value,
                                _postContent.text,
                                int.tryParse(_minimumAge.text) ?? 0,
                              )
                            : _updatePost(
                                widget.post!.id,
                                _postTitle.text,
                                _postDescription.text,
                                _category!.value,
                                _postContent.text,
                              );
                        widget.onReload();
                      },
                child: _isCreatePostLoading
                    ? SpinKitRing(
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                        lineWidth: 2,
                      )
                    : Text(widget.post == null
                        ? AppLocalizations.of(context)!.publish_post
                        : AppLocalizations.of(context)!.update_post),
              )
            ],
          ),
        ),
      ),
    );
  }
}
