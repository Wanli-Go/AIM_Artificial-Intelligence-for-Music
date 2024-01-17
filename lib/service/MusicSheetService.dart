import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/MusicSheet.dart';

class RecommendMusicSheetsService {
  final String ip = 'http://192.168.1.3:8080/';

  // 定义一个函数，接收当前页和每页大小作为参数，返回一个Future<List<MusicSheet>>
  Future<List<MusicSheet>> getMusicSheet(int currentPage, int pageSize) async {
    // 定义一个url，替换你的后端地址和端口
    String url = '${ip}getMusicSheet';
    // 定义一个map，存储请求的参数
    Map<String, int> map = {
      'currentPage': currentPage,
      'pageSize': pageSize,
    };
    // 使用http包的post方法，发送一个post请求，将map转换为json格式的字符串作为请求体
    http.Response response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(map));
    // 检查响应的状态码，如果是200，表示请求成功
    if (response.statusCode == 200) {
      // 解析响应的数据，根据你的后端返回的格式进行处理
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data);
      // 调用extractMusicSheetList函数，传入json对象，得到一个List<MusicSheet>
      List<MusicSheet> list = extractMusicSheetList(data);
      print(list);
      // 返回这个List<MusicSheet>
      return list;
    } else {
      // 如果状态码不是200，表示请求失败，打印或抛出异常
      print('Request failed with status: ${response.statusCode}.');
      // 返回一个空的List<MusicSheet>
      return [];
    }
  }

  List<MusicSheet> extractMusicSheetList(dynamic json) {
    // 使用['data']获取json对象中的data数组
    var data = json['data'] as List;
    // 使用map函数，将data数组中的每个元素，使用MusicSheet.fromJson方法，转换为一个MusicSheet对象
    // 使用toList函数，将结果转换为一个List<MusicSheet>
    return data.map((e) => MusicSheet.fromJson(e)).toList();
  }
}
