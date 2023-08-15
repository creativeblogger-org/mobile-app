import 'package:creative_blogger_app/utils/structs/author.dart';

class PreviewPost {
  final int id;
  final String title;
  final String description;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Author author;
  final String tags;
  final String image;
  final bool hasPermission;
  final bool isLast;

  const PreviewPost({
    required this.id,
    required this.title,
    required this.description,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.tags,
    required this.image,
    required this.hasPermission,
    required this.isLast,
  });

  factory PreviewPost.fromJson(Map<String, dynamic> json) {
    return PreviewPost(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      slug: json["slug"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      author: Author.fromJson(json["author"]),
      tags: json["tags"],
      image: json["image"],
      hasPermission: json["has_permission"],
      isLast: json["is_last"] == 0 ? false : true,
    );
  }
}
