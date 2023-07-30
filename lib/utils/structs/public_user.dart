class PublicUser {
  final int id;
  final String username;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int permission;
  final String? pp;

  PublicUser({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    required this.permission,
    required this.pp,
  });

  factory PublicUser.fromJson(Map<String, dynamic> json) {
    return PublicUser(
      id: json["id"],
      username: json["username"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      permission: json["permission"],
      pp: json["pp"],
    );
  }
}
