import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/components/comment_tile.dart';
import 'package:creative_blogger_app/screens/components/custom_error_while_loading.dart';
import 'package:creative_blogger_app/screens/components/post_tile.dart';
import 'package:creative_blogger_app/screens/home/home.dart';
import 'package:creative_blogger_app/utils/comment.dart';
import 'package:creative_blogger_app/utils/post.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool _isDeletePostLoading = false;

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
    getPost(widget.slug).then((post) {
      if (mounted) {
        setState(() {
          _post = post;
          _isPostLoading = false;
        });
      }
    });
  }

  void _deletePost() {
    setState(() => _isDeletePostLoading = true);
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
                    Navigator.pop(innerContext);
                    deletePost(_post!.slug).then(
                      (fine) {
                        if (fine) {
                          Navigator.pop(context);
                          setState(() => _isDeletePostLoading = true);
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
    );
  }

  void _postComment(String slug, String content) {
    setState(() => _isPostCommentLoading = true);
    postComment(slug, content).then((fine) {
      //TODO reload only comments when the API will allow it
      setState(() => _isPostCommentLoading = false);
      if (fine) {
        _postCommentTextController.text = "";
        _getPost();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.post),
        flexibleSpace: Container(
          decoration: customDecoration(),
        ),
        actions: [
          if (_post != null && _post!.hasPermission) ...{
            IconButton(
              onPressed: !_isDeletePostLoading &&
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
                  child: const Center(
                    child: SpinKitSpinningLines(
                      color: Colors.blue,
                      size: 100,
                      duration: Duration(milliseconds: 1500),
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
                    child: Column(
                      children: [
                        PostTile(post: _post!),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!
                              //TODO change by an header
                              .comments(_post!.comments.length),
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .fontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Pangolin",
                          ),
                        ),
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
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _post!.comments.length,
                          itemBuilder: (context, index) {
                            //TODO add show more button when implemented in API-side

                            // if (index < _post!.comments.length) {
                            return CommentTile(
                              comment: _post!.comments[index],
                              onReload: _getPost,
                            );
                            // }
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
