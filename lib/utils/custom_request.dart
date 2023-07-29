import 'package:creative_blogger_app/utils/token.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<Response> customGetRequest(String url) async {
  var headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${await getToken()}"
  };
  return http.get(Uri.parse(url), headers: headers);
}
