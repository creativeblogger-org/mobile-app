import 'package:creative_blogger_app/screens/create_post_screen.dart';
import 'package:creative_blogger_app/utils/structs/author.dart';

class PreviewPost {
  final int id;
  final String title;
  final String description;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Author author;
  final Category category;
  final String image;
  final bool hasPermission;
  final int likes;
  final bool isVerified;

  const PreviewPost({
    required this.id,
    required this.title,
    required this.description,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.category,
    required this.image,
    required this.hasPermission,
    required this.likes,
    required this.isVerified,
  });

  factory PreviewPost.fromJson(Map<String, dynamic> json) {
    String stringCategory = json["tags"] as String;
    Category? category;
    switch (stringCategory) {
      case "fakeorreal":
        category = Category.fakeOrReal;
        break;
      case "tech":
        category = Category.tech;
        break;
      case "culture":
        category = Category.culture;
        break;
      default:
        category = Category.news;
        break;
    }

    return PreviewPost(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      slug: json["slug"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      author: Author.fromJson(json["author"]),
      category: category,
      image: json["image"],
      hasPermission: json["has_permission"],
      likes: json["likes"] ?? 0,
      isVerified: json["is_verified"] == 0 ? false : true,
    );
  }
}
