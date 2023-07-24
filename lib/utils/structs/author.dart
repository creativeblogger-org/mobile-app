class Author {
  final String username;
  final int permission;

  const Author({required this.username, required this.permission});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(username: json["username"], permission: json["permission"]);
  }
}
