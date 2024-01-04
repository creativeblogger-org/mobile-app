import 'package:creative_blogger_app/screens/components/user_tile.dart';
import 'package:creative_blogger_app/screens/create_post_screen.dart';
import 'package:creative_blogger_app/screens/post.dart';
import 'package:creative_blogger_app/utils/posts.dart';
import 'package:creative_blogger_app/utils/structs/preview_post.dart';
import 'package:creative_blogger_app/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreviewPostTile extends StatefulWidget {
  const PreviewPostTile(
      {super.key, required this.post, required this.showAuthor});

  final PreviewPost post;
  final bool showAuthor;

  @override
  State<PreviewPostTile> createState() => _PreviewPostTileState();
}

class _PreviewPostTileState extends State<PreviewPostTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(
        context,
        PostScreen.routeName,
        arguments: widget.post.slug,
      ),
      contentPadding: const EdgeInsets.all(5),
      leading: CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(widget.post.image),
      ),
      title: Text(
        widget.post.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getHumanDate(widget.post.createdAt),
            style: const TextStyle(color: Colors.grey),
          ),
          if (widget.post.createdAt != widget.post.updatedAt) ...{
            Text(
              AppLocalizations.of(context)!
                  .edited_the(getHumanDate(widget.post.updatedAt)),
              style: const TextStyle(color: Colors.grey),
            ),
          },
          if (widget.showAuthor) ...{
            UserTile(
              author: widget.post.author,
              alignment: MainAxisAlignment.start,
            ),
            const SizedBox(height: 5),
          },
          Text(
            widget.post.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.post.category != null) ...{
            const SizedBox(height: 5),
            Card(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(getCategoryName(widget.post.category!, context)),
              ),
            ),
          },
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(widget.post.likes.toString())
            ],
          )
        ],
      ),
    );
  }
}
