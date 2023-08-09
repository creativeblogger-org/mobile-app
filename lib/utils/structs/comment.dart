import 'package:creative_blogger_app/utils/structs/author.dart';

class Comment {
  final int id;
  final Author author;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasPermission;

  const Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.hasPermission,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      author: Author.fromJson(json["author"]),
      content: json["content"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      hasPermission: json["has_permission"],
    );
  }
}
