class User {
  final int id;
  final String username;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int permission;
  final String? pp;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.permission,
    required this.pp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      permission: json["permission"],
      pp: json["pp"],
    );
  }
}
