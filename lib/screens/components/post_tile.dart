import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
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
        const Divider(),
      ],
    );
  }
}