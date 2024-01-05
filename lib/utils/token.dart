import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true));

Future<String> getToken() async {
  String? token = await storage.read(key: "token");
  if (token == null) {
    return "";
  }
  if (token.trim().isEmpty) {
    return "";
  }
  return token;
}

Future<void> setToken(String token) async {
  await storage.write(key: "token", value: token);
}

Future<void> deleteToken() async {
  await storage.delete(key: "token");
}
