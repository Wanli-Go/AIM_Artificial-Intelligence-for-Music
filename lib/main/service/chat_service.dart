import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:music_therapy/main/model/message.dart';
import 'package:music_therapy/main/service/base_url.dart';

class ChatService {
  static const String ip = baseUrl;
  // HTTP request method to send a message to the large model
  static Future<Message> sendMessage(
      String userId, String content, bool isFirstMessage) async {
    String requestContent = "";
    if (isFirstMessage) {
      requestContent += "*";
    }
    requestContent += content;

    try {
      final response = await http.post(
        Uri.parse('$ip/chat'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': userId,
          'content': requestContent,
        }),
      );

      if (response.statusCode == 200) {
        print("123345");
        final message = Message.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        return message;
      } else {
        throw Exception(
            "Response returned status code: ${response.statusCode}");
      }
    } on Exception {
      throw Exception();
    }
  }
}
