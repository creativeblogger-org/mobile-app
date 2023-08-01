import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/components/comment_tile.dart';
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

  @override
  void initState() {
    super.initState();
    _getPost();
  }

  void _getPost() {
    getPost(widget.slug).then((post) {
      if (mounted) {
        setState(() {
          _post = post;
          _isPostLoading = false;
        });
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
          if (_post != null) ...{
            if (_post!.hasPermission) ...{
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (innerContext) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.are_you_sure),
                      content: Text(AppLocalizations.of(context)!
                          .this_post_will_be_definitely_deleted),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(innerContext),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(innerContext);
                            removePost(_post!.slug).then(
                              (fine) {
                                if (fine) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    HomeScreen.routeName,
                                    (route) => false,
                                    arguments: 0,
                                  );
                                }
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: Text(AppLocalizations.of(context)!.im_sure),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            },
          },
        ],
      ),
      body: _isPostLoading
          ? const Center(
              child: SpinKitSpinningLines(
                color: Colors.blue,
                size: 100,
                duration: Duration(milliseconds: 1500),
              ),
            )
          : _post == null
              ? Text(AppLocalizations.of(context)!
                  .an_error_occured_while_loading_post)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      PostTile(post: _post!),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.comments,
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: TextField(
                                controller: _postCommentTextController,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .add_a_comment,
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onChanged: (value) => setState(() =>
                                    _activePostCommentButton =
                                        value.length > 5),
                              ),
                            ),
                            IconButton(
                              onPressed: _activePostCommentButton &&
                                      !_isPostCommentLoading
                                  ? () {
                                      setState(
                                          () => _isPostCommentLoading = true);
                                      postComment(_post!.slug,
                                              _postCommentTextController.text)
                                          .then((fine) {
                                        //TODO reload only comments when the API will allow it
                                        setState(() {
                                          _isPostCommentLoading = false;
                                          if (fine) {
                                            _isPostLoading = true;
                                          }
                                        });
                                        if (fine) {
                                          _getPost();
                                        }
                                      });
                                    }
                                  : null,
                              icon: Icon(
                                Icons.send,
                                color: _activePostCommentButton
                                    ? Theme.of(context).colorScheme.primary
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
                          return CommentTile(comment: _post!.comments[index]);
                          // }
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
