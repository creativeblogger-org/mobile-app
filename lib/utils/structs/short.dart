import 'package:creative_blogger_app/utils/structs/author.dart';

class Short {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Author author;
  final bool hasPermission;

  const Short(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.updatedAt,
      required this.author,
      required this.hasPermission});

  factory Short.fromJson(Map<String, dynamic> json) {
    return Short(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      author: Author.fromJson(json["author"]),
      hasPermission: json["has_permission"],
    );
  }
}
