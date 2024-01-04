import 'package:creative_blogger_app/utils/structs/public_user.dart';

class Author {
  final String username;
  final Permission permission;
  final String? pp;
  final String? buyMeACoffee;

  const Author({
    required this.username,
    required this.permission,
    required this.pp,
    required this.buyMeACoffee,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      username: json["username"],
      permission: getPermission(json["permission"]),
      pp: json["pp"],
      buyMeACoffee: json["buymeacoffee"],
    );
  }
}
