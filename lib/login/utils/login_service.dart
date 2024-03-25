import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_therapy/main/model/User.dart';
import 'package:music_therapy/main/model/user_data.dart';
import 'package:music_therapy/main/service/base_url.dart';

class LoginService {
  static const String ip = baseUrl;

  static Future<String> login(String user, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$ip/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userAccount': user,
          'userPassword': password,
        }),
      );

      if (response.statusCode == 200) {
        // print("22222222222222222login${response.statusCode}");
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        User user = User.fromJson(jsonData);
        UserData.username = user.userName;
        UserData.userPhone = user.userAccount;
        UserData.userIdentity = user.userIdentity;
        UserData.userId = user.userId;
        return '1';
      } else {
        print("11111111111111111login${response.statusCode}");
        return 'Error: Status Code ${response.statusCode}';
      }
    } on Exception {
      throw Exception();
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
    } on Exception{
      throw Exception;
    }
  }
}
