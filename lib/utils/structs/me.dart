class Me {
  final int id;
  final String username;
  final String email;
  final DateTime birthdate;
  final DateTime createdAt;
  // final DateTime updatedAt;
  final int permission;
  final String? pp;

  Me({
    required this.id,
    required this.username,
    required this.email,
    required this.birthdate,
    required this.createdAt,
    // required this.updatedAt,
    required this.permission,
    required this.pp,
  });

  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      birthdate: DateTime.parse(json["birthdate"]),
      createdAt: DateTime.parse(json["created_at"]),
      // updatedAt: DateTime.parse(json["updated_at"]),
      permission: json["permission"],
      pp: json["pp"],
    );
  }
}
