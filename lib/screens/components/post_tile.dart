import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PostTile extends StatefulWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          widget.post.title,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: "Pangolin",
          ),
        ),
        const Divider(),
        MarkdownBody(
          data: widget.post.content,
          onTapLink: (text, url, title) {
            launchUrl(
              Uri.parse(url!),
              mode: LaunchMode.externalApplication,
            );
          },
        )
      ],
    );
  }
}
