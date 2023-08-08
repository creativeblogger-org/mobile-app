import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/utils/post.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  news("news");

  const Category(this.value);
  final String value;
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  Category? _category;
  bool _isCreatePostLoading = false;

  final TextEditingController _postTitle = TextEditingController();
  String? _postTitleError;
  final TextEditingController _postImageURL = TextEditingController();
  String? _postImageURLError;
  final TextEditingController _postDescription = TextEditingController();
  String? _postDescriptionError;
  final TextEditingController _postContent = TextEditingController();
  String? _postContentError;

  @override
  void initState() {
    _category = widget.post?.category;
    _postTitle.text = widget.post?.title ?? "";
    _postImageURL.text = widget.post?.imageUrl ?? "";
    _postDescription.text = widget.post?.description ?? "";
    _postContent.text = widget.post?.content ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _postTitle.dispose();
    super.dispose();
  }

  void _publishPost(
    String title,
    String imageUrl,
    String description,
    String tags,
    String content,
  ) {
    setState(() => _isCreatePostLoading = true);
    createPost(title, imageUrl, description, tags, content).then(
      (fine) {
        setState(() => _isCreatePostLoading = false);
        Navigator.pop(context);
      },
    );
  }

  void _updatePost(
    int id,
    String title,
    String imageUrl,
    String description,
    String tags,
    String content,
  ) {
    setState(() => _isCreatePostLoading = true);
    updatePost(
            id, widget.post!.slug, title, imageUrl, description, tags, content)
        .then(
      (fine) {
        setState(() => _isCreatePostLoading = false);
        Navigator.pop(context);
      },
    );
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
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.image_url,
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorText: _postImageURLError,
                ),
                controller: _postImageURL,
                onChanged: (value) => setState(() => _postImageURLError =
                    urlRegex.hasMatch(value.trim())
                        ? null
                        : AppLocalizations.of(context)!.invalid_url),
              ),
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
              for (var i in Category.values) ...{
                RadioListTile(
                  title: Text(
                    i == Category.fakeOrReal
                        ? AppLocalizations.of(context)!.investigation
                        : i == Category.tech
                            ? AppLocalizations.of(context)!.tech
                            : i == Category.culture
                                ? AppLocalizations.of(context)!.culture
                                : AppLocalizations.of(context)!.news,
                  ),
                  value: i,
                  groupValue: _category,
                  onChanged: (Category? category) {
                    setState(() => _category = category);
                  },
                ),
              },
              const SizedBox(height: 16),
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
                            ? AppLocalizations.of(context)!.description_too_long
                            : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _postTitleError != null ||
                        _postTitle.text.isEmpty ||
                        _postImageURLError != null ||
                        _postImageURL.text.isEmpty ||
                        _postDescriptionError != null ||
                        _postDescription.text.isEmpty ||
                        _category == null ||
                        _postContentError != null ||
                        _postContent.text.isEmpty ||
                        _isCreatePostLoading
                    ? null
                    : () {
                        widget.post == null
                            ? _publishPost(
                                _postTitle.text,
                                _postImageURL.text,
                                _postDescription.text,
                                _category!.value,
                                _postContent.text,
                              )
                            : _updatePost(
                                widget.post!.id,
                                _postTitle.text,
                                _postImageURL.text,
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
