import 'package:creative_blogger_app/utils/structs/comment.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: comment.author.pp == null ? null : Colors.transparent,
              child: comment.author.pp == null
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
