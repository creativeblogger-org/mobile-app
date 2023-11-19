class Author {
  final DateTime createdAt;
  final int id;
  final String username;
  final int permission;
  final String? pp;
  final String? buyMeACoffee;

  const Author({
    required this.createdAt,
    required this.id,
    required this.username,
    required this.permission,
    required this.pp,
    required this.buyMeACoffee,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      createdAt: DateTime.parse(json["created_at"]),
      id: json["id"],
      username: json["username"],
      permission: json["permission"],
      pp: json["pp"],
      buyMeACoffee: json["buymeacoffee"],
    );
  }
}
