class Author {
  final String username;
  final int permission;
  final String? pp;

  const Author(
      {required this.username, required this.permission, required this.pp});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
        username: json["username"],
        permission: json["permission"],
        pp: json["pp"]);
  }
}
