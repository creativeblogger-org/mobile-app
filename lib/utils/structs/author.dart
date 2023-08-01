class Author {
  final int id;
  final String username;
  final int permission;
  final String? pp;

  const Author({
    required this.id,
    required this.username,
    required this.permission,
    required this.pp,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json["id"],
      username: json["username"],
      permission: json["permission"],
      pp: json["pp"],
    );
  }
}
