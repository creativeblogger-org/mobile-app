enum Permission {
  member,
  redactor,
  moderator,
  administrator,
}

class PublicUser {
  final int id;
  final String username;
  final DateTime createdAt;
  final Permission permission;
  final String? pp;
  final String? bio;
  final String? buymeacoffee;

  PublicUser({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.permission,
    required this.pp,
    required this.bio,
    required this.buymeacoffee,
  });

  factory PublicUser.fromJson(Map<String, dynamic> json) {
    return PublicUser(
      id: json["id"],
      username: json["username"],
      createdAt: DateTime.parse(json["created_at"]),
      permission: getPermission(json["permission"]),
      pp: json["pp"],
      bio: json["biography"],
      buymeacoffee: json["buymeacoffee"],
    );
  }
}

Permission getPermission(int permission) {
  switch (permission) {
    case 1:
      return Permission.redactor;
    case 2:
      return Permission.moderator;
    case 3:
      return Permission.administrator;
    default:
      return Permission.member;
  }
}
