import 'package:creative_blogger_app/screens/components/user_tile.dart';
import 'package:creative_blogger_app/utils/post.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:creative_blogger_app/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          post.title,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: "Pangolin",
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        Text(
          getHumanDate(post.createdAt),
          style: const TextStyle(color: Colors.grey),
        ),
        if (post.createdAt != post.updatedAt) ...{
          Text(
            AppLocalizations.of(context)!.edited_the(
              getHumanDate(post.updatedAt),
            ),
            style: const TextStyle(color: Colors.grey),
          ),
        },
        UserTile(
          author: post.author,
          alignment: MainAxisAlignment.center,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.thumb_up_outlined,
            color: Colors.blue,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(post.likes.toString())
        ]),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MarkdownBody(
            data: post.content,
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
              children: [
                IconButton(
                  onPressed: () async {
                    var success = await likePost(post.id);
                    if (success) {
                      //Change has liked to true
                    }
                  },
                  icon: const Icon(
                    Icons.thumb_up_outlined,
                    color: Colors.blue,
                  ),
                ),
                Text(post.likes.toString()),
              ],
            ),
            IconButton(
              onPressed: () async {
                var success = await dislikePost(post.id);
                if (success) {
                  //Change has_disliked to true
                }
              },
              icon: const Icon(
                Icons.thumb_down_outlined,
                color: Colors.red,
              ),
            )
          ],
        ),
        const Divider(),
      ],
    );
  }
}
