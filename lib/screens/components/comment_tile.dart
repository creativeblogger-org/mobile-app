import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/utils/comment.dart';
import 'package:creative_blogger_app/utils/structs/comment.dart';
import 'package:creative_blogger_app/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommentTile extends StatefulWidget {
  const CommentTile({super.key, required this.comment, required this.onReload});

  final Comment comment;
  final Function() onReload;

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool _isDeletePostLoading = false;
  final TextEditingController _commentContentEditingController =
      TextEditingController();
  bool _isEditing = false;
  bool _isUpdatingCommentLoading = false;

  @override
  void initState() {
    super.initState();
    _commentContentEditingController.text = widget.comment.content;
  }

  Future<bool> _deleteComment(int commentId) async {
    setState(() => _isDeletePostLoading = true);
    var fine = await deleteComment(commentId);
    setState(() => _isDeletePostLoading = false);
    return fine;
  }

  Future<bool> _updateComment(int id, String content) async {
    setState(() => _isUpdatingCommentLoading = true);
    var fine = await updateComment(id, content);
    if (fine) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).clearSnackBars();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(navigatorKey.currentContext!)!
              .comment_updated_successfully),
          backgroundColor: Colors.green,
        ),
      );
    }
    setState(() {
      _isUpdatingCommentLoading = false;
      _isEditing = false;
    });

    widget.onReload();
    return fine;
  }

  @override
  Widget build(BuildContext context) {
    var hasPP = widget.comment.author.pp == null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: hasPP ? null : Colors.transparent,
              child: hasPP
                  ? const Icon(Icons.person)
                  : Image.network(
                      widget.comment.author.pp!,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person);
                      },
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "@${widget.comment.author.username}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        getHumanDate(widget.comment.createdAt),
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  _isEditing
                      ? Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentContentEditingController,
                                maxLines: null,
                                enabled: _isEditing,
                              ),
                            ),
                            _isUpdatingCommentLoading
                                ? SpinKitRing(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 20,
                                    lineWidth: 2,
                                  )
                                : IconButton(
                                    onPressed: () => _updateComment(
                                      widget.comment.id,
                                      _commentContentEditingController.text,
                                    ),
                                    icon: Icon(
                                      Icons.send,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                          ],
                        )
                      : RichText(
                          text: TextSpan(
                            text: widget.comment.content,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            children: [
                              if (widget.comment.createdAt !=
                                  widget.comment.updatedAt) ...{
                                TextSpan(
                                  text:
                                      " (${AppLocalizations.of(context)!.edited})",
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey),
                                )
                              }
                            ],
                          ),
                        ),
                ],
              ),
            ),
            if (widget.comment.hasPermission) ...{
              IconButton(
                onPressed: () => setState(() => _isEditing = !_isEditing),
                icon: Icon(_isEditing ? Icons.close : Icons.edit,
                    color: Theme.of(context).colorScheme.primary),
              ),
              IconButton(
                onPressed: _isDeletePostLoading
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (innerContext) => AlertDialog(
                            title: Text(
                                AppLocalizations.of(context)!.are_you_sure),
                            content: Text(AppLocalizations.of(context)!
                                .this_comment_will_be_definitely_deleted),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(innerContext),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary),
                                child:
                                    Text(AppLocalizations.of(context)!.cancel),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(innerContext);
                                  _deleteComment(widget.comment.id).then(
                                    (fine) {
                                      if (fine) {
                                        widget.onReload();
                                      }
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child:
                                    Text(AppLocalizations.of(context)!.im_sure),
                              )
                            ],
                          ),
                        );
                      },
                icon: _isDeletePostLoading
                    ? const SpinKitRing(
                        color: Colors.red,
                        size: 20,
                        lineWidth: 2,
                      )
                    : const Icon(Icons.delete, color: Colors.red),
              )
            }
          ],
        ),
      ),
    );
  }
}
