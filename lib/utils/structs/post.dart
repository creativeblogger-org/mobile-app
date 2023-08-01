import 'package:creative_blogger_app/utils/structs/author.dart';
import 'package:creative_blogger_app/utils/structs/comment.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Author author;
  final String tags;
  final bool hasPermission;
  final List<Comment> comments;

  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.tags,
    required this.hasPermission,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      slug: json["slug"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      author: Author.fromJson(json["author"]),
      tags: json["tags"],
      hasPermission: json["has_permission"],
      comments: (json["comments"] as List)
          .map((jsonComment) => Comment.fromJson(jsonComment))
          .toList(),
    );
  }
}
