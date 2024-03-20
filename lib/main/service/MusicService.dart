import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/Music.dart';

class RecentlyPlayedMusicService {
  final String ip = 'http://wasabi/';

  // 定义一个函数，接收当前页和每页大小作为参数，返回一个Future<List<MusicSheet>>
  Future<List<Music>> getMusicListBySheet(
      String userId, String musicSheetId) async {
    // 定义一个url，替换你的后端地址和端口
    String url = '${ip}getMusicListBySheet';
    // 定义一个map，存储请求的参数
    Map<String, String> map = {
      'userId': userId,
      'musicSheetId': musicSheetId,
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
      List<Music> list = extractMusicList(data);
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

  // 定义一个函数，接收当前页和每页大小作为参数，返回一个Future<List<MusicSheet>>
  Future<List<Music>> getLike(
      String userId, int currentPage, int pageSize) async {
    // 定义一个url，替换你的后端地址和端口
    String url = '${ip}getLike';
    // 定义一个map，存储请求的参数
    Map<String, Object> map = {
      'userId': userId,
      'currentPage': currentPage,
      'pageSize': pageSize
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
      List<Music> list = extractMusicList(data);
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

  // 定义一个函数，接收当前页和每页大小作为参数，返回一个Future<List<MusicSheet>>
  Future<List<Music>> getRecent(String userId, int currentPage, int pageSize) async {
    String url = '${ip}getRecent';
    // 定义一个map，存储请求的参数
    Map<String, Object> map = {
      'userId': userId,
      'currentPage': currentPage,
      'pageSize': pageSize
    };
    // 使用http包的post方法，发送一个post请求，将map转换为json格式的字符串作为请求体
    try {
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
        List<Music> list = extractMusicList(data);
        print(list);
        // 返回这个List<MusicSheet>
        return list;
      } else {
        // 如果状态码不是200，表示请求失败，打印或抛出异常
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        // 返回一个空的List<MusicSheet>
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Request failed: Unable to reach desired server IP.');
      }
      await Future.delayed(const Duration(seconds: 1));
      return Music.fakeMusicList;
    }
  }

    // 定义一个函数，接收当前页和每页大小作为参数，返回一个Future<List<MusicSheet>>
  Future<List<Music>> getLiked(String userId, int currentPage, int pageSize) async {
    String url = '${ip}getLiked';
    // 定义一个map，存储请求的参数
    Map<String, Object> map = {
      'userId': userId,
      'currentPage': currentPage,
      'pageSize': pageSize
    };
    // 使用http包的post方法，发送一个post请求，将map转换为json格式的字符串作为请求体
    try {
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
        List<Music> list = extractMusicList(data);
        print(list);
        // 返回这个List<MusicSheet>
        return list;
      } else {
        // 如果状态码不是200，表示请求失败，打印或抛出异常
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        // 返回一个空的List<MusicSheet>
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Request failed: Unable to reach desired server IP.');
      }
      await Future.delayed(const Duration(seconds: 1));
      return Music.fakeMusicList;
    }
  }

  // 定义一个函数，接收当前页和每页大小作为参数，返回一个Future<List<MusicSheet>>
  Future<void> likeMusic(String userId, String musicId) async {
    // 定义一个url，替换你的后端地址和端口
    String url = '${ip}likeMusic';
    // 定义一个map，存储请求的参数
    Map<String, String> map = {
      'userId': userId,
      'musicId': musicId,
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
      return;
    } else {
      // 如果状态码不是200，表示请求失败，打印或抛出异常
      print('Request failed with status: ${response.statusCode}.');
      // 返回一个空的List<MusicSheet>
      return;
    }
  }

  // 定义一个函数，接收当前页和每页大小作为参数，返回一个Future<List<MusicSheet>>
  Future<void> dislikeMusic(String userId, String musicId) async {
    // 定义一个url，替换你的后端地址和端口
    String url = '${ip}dislikeMusic';
    // 定义一个map，存储请求的参数
    Map<String, String> map = {
      'userId': userId,
      'musicId': musicId,
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
      return;
    } else {
      // 如果状态码不是200，表示请求失败，打印或抛出异常
      print('Request failed with status: ${response.statusCode}.');
      // 返回一个空的List<MusicSheet>
      return;
    }
  }

  // 定义一个函数，接收当前页和每页大小作为参数，返回一个Future<List<MusicSheet>>
  Future<void> addRecent(String userId, String musicId) async {
    // 定义一个url，替换你的后端地址和端口
    String url = '${ip}addRecent';
    // 定义一个map，存储请求的参数
    Map<String, String> map = {
      'userId': userId,
      'musicId': musicId,
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
      return;
    } else {
      // 如果状态码不是200，表示请求失败，打印或抛出异常
      print('Request failed with status: ${response.statusCode}.');
      // 返回一个空的List<MusicSheet>
      return;
    }
  }

  Future<Music> getMusicDetail(String musicId) async {
    // 定义一个url，替换你的后端地址和端口
    String url = '${ip}getMusicDetail';
    // 定义一个map，存储请求的参数
    Map<String, String> map = {
      'musicId': musicId,
    };
    // 使用http包的post方法，发送一个post请求，将map转换为json格式的字符串作为请求体
    http.Response response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(map));
    // 检查响应的状态码，如果是200，表示请求成功
    // 解析响应的数据，根据你的后端返回的格式进行处理
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);
    Music music = extractMusic(data);
    print(music);
    return music;
  }

  Music extractMusic(dynamic json) {
    // 使用['data']获取json对象中的data数组
    var data = Music.fromJson(json['data']);
    // 使用map函数，将data数组中的每个元素，使用MusicSheet.fromJson方法，转换为一个MusicSheet对象
    // 使用toList函数，将结果转换为一个List<MusicSheet>
    return data;
  }

  List<Music> extractMusicList(dynamic json) {
    // 使用['data']获取json对象中的data数组
    var data = json['data'] as List;
    // 使用map函数，将data数组中的每个元素，使用MusicSheet.fromJson方法，转换为一个MusicSheet对象
    // 使用toList函数，将结果转换为一个List<MusicSheet>
    return data.map((e) => Music.fromJson(e)).toList();
  }
}
