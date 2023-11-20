class User {
  final int id;
  final String username;
  final DateTime createdAt;
  final int permission;
  final String? pp;

  User({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.permission,
    required this.pp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      createdAt: DateTime.parse(json["created_at"]),
      permission: json["permission"],
      pp: json["pp"],
    );
  }
}
