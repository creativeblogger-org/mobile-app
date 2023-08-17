import 'package:creative_blogger_app/screens/user.dart';
import 'package:creative_blogger_app/utils/structs/author.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.author, required this.alignment});

  final Author author;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, UserScreen.routeName,
          arguments: author.username),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: author.pp == null ? null : Colors.transparent,
            backgroundImage:
                author.pp == null ? null : NetworkImage(author.pp!),
            child: author.pp == null ? const Icon(Icons.person) : null,
          ),
          const SizedBox(width: 5),
          Text(
            "@${author.username}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
