import 'package:creative_blogger_app/main.dart';
import 'package:creative_blogger_app/screens/components/user_tile.dart';
import 'package:creative_blogger_app/utils/post.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:creative_blogger_app/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostTile extends StatefulWidget {
  const PostTile(
      {super.key,
      required this.post,
      required this.hasLiked,
      required this.setHasLiked});

  final Post post;
  final bool hasLiked;
  final Function(bool) setHasLiked;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  var _addLike = 0;
  var _isLikeLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.post.title,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: "Pangolin",
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        Text(
          getHumanDate(widget.post.createdAt),
          style: const TextStyle(color: Colors.grey),
        ),
        if (widget.post.createdAt != widget.post.updatedAt) ...{
          Text(
            AppLocalizations.of(context)!.edited_the(
              getHumanDate(widget.post.updatedAt),
            ),
            style: const TextStyle(color: Colors.grey),
          ),
        },
        UserTile(
          author: widget.post.author,
          alignment: MainAxisAlignment.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.hasLiked ? Icons.favorite : Icons.favorite_border,
              color: widget.hasLiked ? Colors.red : Colors.grey,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(widget.post.likes.toString())
          ],
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MarkdownBody(
            data: widget.post.content,
            onTapLink: (text, url, title) {
              launchUrl(
                Uri.parse(url!),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _isLikeLoading
                      ? null
                      : widget.hasLiked
                          ? () async {
                              setState(() => _isLikeLoading = true);
                              var success = await unlikePost(widget.post.id);
                              if (success) {
                                widget.setHasLiked(false);
                                setState(
                                  () {
                                    if (_addLike == 0) {
                                      _addLike = -1;
                                    } else if (_addLike == 1) {
                                      _addLike = 0;
                                    }
                                  },
                                );
                              }
                              setState(() => _isLikeLoading = false);
                            }
                          : () async {
                              setState(() => _isLikeLoading = true);
                              var success = await likePost(widget.post.id);
                              if (success) {
                                widget.setHasLiked(true);
                                setState(
                                  () {
                                    if (_addLike == -1) {
                                      _addLike = 0;
                                    } else if (_addLike == 0) {
                                      _addLike = 1;
                                    }
                                  },
                                );
                              }
                              setState(() => _isLikeLoading = false);
                            },
                  icon: Icon(
                    widget.hasLiked || _isLikeLoading
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: !widget.hasLiked || _isLikeLoading
                        ? Colors.grey
                        : Colors.red,
                  ),
                ),
                Text((widget.post.likes + _addLike).toString()),
              ],
            ),
            IconButton(
              onPressed: () async {
                await Share.shareUri(
                    Uri.parse("$FRONT_URL/posts/${widget.post.slug}"));
              },
              icon: Icon(
                Icons.share,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            )
          ],
        ),
        const Divider(),
      ],
    );
  }
}
