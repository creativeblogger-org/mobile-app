import 'package:creative_blogger_app/screens/post.dart';
import 'package:creative_blogger_app/screens/user.dart';
import 'package:creative_blogger_app/utils/structs/preview_post.dart';
import 'package:flutter/material.dart';

class PreviewPostTile extends StatefulWidget {
  const PreviewPostTile({super.key, required this.post});

  final PreviewPost post;

  @override
  State<PreviewPostTile> createState() => _PreviewPostTileState();
}

class _PreviewPostTileState extends State<PreviewPostTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      elevation: 4.0,
      shadowColor: Theme.of(context).colorScheme.primary,
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
          PostScreen.routeName,
          arguments: widget.post.slug,
        ),
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
            const Divider(),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, UserScreen.routeName,
                  arguments: widget.post.author.username),
              child: Text(
                "@${widget.post.author.username}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.post.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        tileColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
      ),
    );
  }
}
