import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_therapy/main/model/User.dart';
import 'package:music_therapy/main/model/user_data.dart';

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
        final jsonData = jsonDecode(response.body);
        User user = User.fromJson(jsonData);
        UserData.username = user.userName;
        UserData.userPhone = user.userAccount;
        UserData.userIdentity = user.userIdentity;
        UserData.userId = user.userId;
        return '1';
      } else {
        return 'Error: Status Code ${response.statusCode}';
      }
    } on Exception {
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
    } on Exception {
      return "1";
      // FIXME: This is debug code without error handling.
    }
  }
}
