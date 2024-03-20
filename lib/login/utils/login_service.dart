import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginService {
  static const String ip = 'http://wasabi/';
  // FIXME: This is debug code without error handling.

  static Future<String> login(String user, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$ip/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user': user,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return '1';
      } else {
        return 'Error: Status Code ${response.statusCode}';
      }
    } on Exception catch (e) {
      return "1";
      // FIXME: This is debug code without error handling.
    }
  }

    static Future<String> register(String username, String user, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$ip/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'user': user,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return '1';
      } else {
        return 'Error: Status Code ${response.statusCode}';
      }
    } on Exception catch (e) {
      return "1";
      // FIXME: This is debug code without error handling.
    }
  }
}