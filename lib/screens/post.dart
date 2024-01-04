import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/components/comment_tile.dart';
import 'package:creative_blogger_app/screens/components/custom_error_while_loading.dart';
import 'package:creative_blogger_app/screens/components/post_tile.dart';
import 'package:creative_blogger_app/screens/create_post_screen.dart';
import 'package:creative_blogger_app/screens/home/home.dart';
import 'package:creative_blogger_app/utils/comment.dart';
import 'package:creative_blogger_app/utils/post.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key, required this.slug});

  static const routeName = "/post";

  final String slug;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Post? _post;
  bool _isPostLoading = true;
  bool _isPostCommentLoading = false;
  final TextEditingController _postCommentTextController =
      TextEditingController();
  bool _activePostCommentButton = false;
  bool _isDeleteDialogVisible = false;
  bool _isDeletePostLoading = false;
  bool _isShowMoreLoading = false;
  bool _areCommentsLoading = false;
  bool _hasLiked = false;
  int? _commentCount;

  @override
  void initState() {
    super.initState();
    _getPost();
  }

  @override
  void dispose() {
    super.dispose();
    _postCommentTextController.dispose();
  }

  void _getPost() {
    setState(() => _isPostLoading = true);
    getPost(widget.slug).then((result) {
      if (mounted) {
        setState(() {
          _post = result.$1;
          _commentCount = result.$2;
          _hasLiked = result.$3;
          _isPostLoading = false;
        });
      }
    });
  }

  void _deletePost() {
    setState(() => _isDeleteDialogVisible = true);
    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.are_you_sure),
        content: Text(
            AppLocalizations.of(context)!.this_post_will_be_definitely_deleted),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(innerContext),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: _isDeletePostLoading
                ? null
                : () {
                    setState(() => _isDeletePostLoading = true);
                    Navigator.pop(innerContext);
                    deletePost(_post!.slug).then(
                      (fine) {
                        if (fine) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, HomeScreen.routeName, (route) => false);
                        }
                      },
                    );
                  },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: _isDeletePostLoading
                ? const SpinKitRing(
                    color: Colors.red,
                    size: 20,
                    lineWidth: 2,
                  )
                : Text(AppLocalizations.of(context)!.im_sure),
          )
        ],
      ),
    ).then(
      (_) => setState(
        () {
          _isDeleteDialogVisible = false;
          _isDeletePostLoading = false;
        },
      ),
    );
  }

  void _getComments() {
    setState(() => _areCommentsLoading = true);
    getComments(_post!.id).then((comments) {
      if (comments.$1 == null) {
        return;
      }
      setState(() {
        _post!.comments.clear();
        _post!.comments.addAll(comments.$1!);
        _commentCount = comments.$2;
        _areCommentsLoading = false;
      });
    });
  }

  void _postComment(String slug, String content) {
    setState(() => _isPostCommentLoading = true);
    postComment(slug, content).then((fine) {
      setState(() => _isPostCommentLoading = false);
      if (fine) {
        _postCommentTextController.text = "";
        setState(() => _activePostCommentButton = false);
        _getComments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showShowMoreButton =
        _post != null && _commentCount! > _post!.comments.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.post),
        flexibleSpace: Container(
          decoration: customDecoration(),
        ),
        actions: [
          if (_post != null && _post!.hasPermission) ...{
            IconButton(
              onPressed: !_isDeleteDialogVisible &&
                      !_isPostCommentLoading &&
                      !_isPostLoading
                  ? () => Navigator.pushNamed(
                        context,
                        CreatePostScreen.routeName,
                        arguments: (_post, () => _getPost()),
                      )
                  : null,
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: !_isDeleteDialogVisible &&
                      !_isPostCommentLoading &&
                      !_isPostLoading
                  ? _deletePost
                  : null,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          },
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _getPost(),
        child: _isPostLoading
            ? LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  height: constraints.maxHeight,
                  child: Center(
                    child: SpinKitSpinningLines(
                      color: Theme.of(context).colorScheme.primary,
                      size: 100,
                      duration: const Duration(milliseconds: 1500),
                    ),
                  ),
                ),
              )
            : _post == null
                ? CustomErrorWhileLoadingComponent(
                    message: AppLocalizations.of(context)!
                        .an_error_occured_while_loading_post,
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(4.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        PostTile(
                          post: _post!,
                          hasLiked: _hasLiked,
                          setHasLiked: (value) => setState(
                            () => _hasLiked = value,
                          ),
                        ),
                        if (_post?.author.buyMeACoffee != null) ...{
                          ElevatedButton(
                              onPressed: () async {
                                await launchUrlString(
                                    _post!.author.buyMeACoffee!);
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .enjoyed_the_reading_support_the_author)),
                        },
                        if (_commentCount != null) ...{
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!
                                .comments(_commentCount!),
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .fontSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Pangolin",
                            ),
                          ),
                        },
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: _postCommentTextController,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .add_a_comment,
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.1),
                                  ),
                                  onChanged: (value) => setState(() =>
                                      _activePostCommentButton =
                                          value.length >= 5),
                                ),
                              ),
                              IconButton(
                                onPressed: _activePostCommentButton &&
                                        !_isPostCommentLoading
                                    ? () => _postComment(_post!.slug,
                                        _postCommentTextController.text)
                                    : null,
                                icon: _isPostCommentLoading
                                    ? SpinKitRing(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20,
                                        lineWidth: 2,
                                      )
                                    : Icon(
                                        Icons.send,
                                        color: _activePostCommentButton
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.grey,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        _areCommentsLoading
                            ? Center(
                                child: SpinKitSpinningLines(
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 100,
                                  duration: const Duration(milliseconds: 1500),
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: showShowMoreButton
                                    ? _post!.comments.length + 1
                                    : _post!.comments.length,
                                itemBuilder: (context, index) {
                                  if (index < _post!.comments.length) {
                                    return CommentTile(
                                      comment: _post!.comments[index],
                                      onReload: _getComments,
                                    );
                                  }
                                  return CustomButton(
                                    onPressed: _isShowMoreLoading
                                        ? null
                                        : () {
                                            setState(() =>
                                                _isShowMoreLoading = true);
                                            getComments(_post!.id,
                                                    page: _post!.comments
                                                                .length ~/
                                                            20 +
                                                        1)
                                                .then(
                                              (comments) {
                                                if (comments.$1 == null) {
                                                  setState(() =>
                                                      _isShowMoreLoading =
                                                          false);
                                                  return;
                                                }
                                                _post!.comments
                                                    .addAll(comments.$1!);
                                                setState(() =>
                                                    _isShowMoreLoading = false);
                                              },
                                            );
                                          },
                                    child: _isShowMoreLoading
                                        ? SpinKitRing(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            size: 20,
                                            lineWidth: 2,
                                          )
                                        : Text(AppLocalizations.of(context)!
                                            .show_more),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
