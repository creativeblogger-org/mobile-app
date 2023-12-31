import 'package:creative_blogger_app/screens/create_post_screen.dart';
import 'package:creative_blogger_app/utils/posts.dart';
import 'package:creative_blogger_app/utils/structs/author.dart';
import 'package:creative_blogger_app/utils/structs/comment.dart';

class Post {
  final int id;
  final String title;
  final String imageUrl;
  final String description;
  final String content;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Author author;
  final Category? category;
  final bool hasPermission;
  final List<Comment> comments;
  final int requiredAge;
  final int likes;
  final bool isVerified;
  final int views;

  const Post({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.content,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.category,
    required this.hasPermission,
    required this.comments,
    required this.requiredAge,
    required this.likes,
    required this.isVerified,
    required this.views,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String stringCategory = json["tags"] as String;
    Category? category = getCategory(stringCategory);

    return Post(
      id: json["id"],
      title: json["title"],
      imageUrl: json["image"],
      description: json["description"],
      content: json["content"],
      slug: json["slug"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      author: Author.fromJson(json["author"]),
      category: category,
      hasPermission: json["has_permission"],
      comments: (json["comments"] as List)
          .map((jsonComment) => Comment.fromJson(jsonComment))
          .toList(),
      requiredAge: json["required_age"],
      likes: json["likes"] ?? 0,
      isVerified: json["is_verified"] == 0 ? false : true,
      views: json["views"],
    );
  }
}
