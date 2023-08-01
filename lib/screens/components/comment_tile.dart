import 'package:creative_blogger_app/utils/structs/comment.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    var hasPP = comment.author.pp == null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: hasPP ? null : Colors.transparent,
              child: hasPP
                  ? const Icon(Icons.person)
                  : Image.network(
                      comment.author.pp!,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@${comment.author.username}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(comment.content),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
