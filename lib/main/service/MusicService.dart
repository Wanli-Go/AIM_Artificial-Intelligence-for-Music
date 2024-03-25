import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:music_therapy/main/service/base_url.dart';

import '../model/Music.dart';

class MusicService {
  static const String ip = baseUrl;

  Music extractMusic(dynamic json) {
    var data = Music.fromJson(json['data']);
    return data;
  }

  List<Music> extractMusicList(dynamic json) {
    print("1\n");
    var data = json['data'] as List;
    print("2\n");
    return data.map((e) => Music.fromJson(e)).toList();
  }

  // 最近常听
  Future<List<Music>> getRecent(String userId) async {
    String url = '${ip}/getFrequentMusic';
    // 定义一个map，存储请求的参数
    Map<String, Object> map = {
      'userId': userId,
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
        // 调用extractMusicSheetList函数，传入json对象，得到一个List<MusicSheet>
        List<Music> list = extractMusicList(data);
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
      throw Exception();
    }
  }

  // 定义一个函数，接收当前页和每页大小作为参数，返回一个Future<List<MusicSheet>>
  Future<List<Music>> getLiked(
      String userId, int currentPage, int pageSize) async {
    String url = '${ip}/getLike';
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
        // 调用extractMusicSheetList函数，传入json对象，得到一个List<MusicSheet>
        List<Music> list = extractMusicList(data);
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

  // 生成
  Future<Music> getGenerated(String userId, String description) async {
    // TODO: implement userInfo. Current implementation only include description to answer.
    String url = '${ip}/generateMusic';
    // 定义一个map，存储请求的参数
    Map<String, Object> map = {'description': "一首欢快的舞曲"};
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
        // 调用extractMusicSheetList函数，传入json对象，得到一个List<MusicSheet>
        Music music = extractMusic(data);
        // 返回这个List<MusicSheet>
        return music;
      } else {
        // 如果状态码不是200，表示请求失败，打印或抛出异常
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
        return Music.example;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Request failed: Unable to reach desired server IP.');
      }
      await Future.delayed(const Duration(seconds: 1));
      return Music.example;
    }
  }

  // 定义一个函数，接收当前页和每页大小作为参数，返回一个Future<List<MusicSheet>>
  Future<bool> likeMusic(String userId, String musicId) async {
    // 定义一个url，替换你的后端地址和端口
    String url = '${ip}/likeMusic';
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
      return true;
    } else {
      // 如果状态码不是200，表示请求失败，打印或抛出异常
      print('Request failed with status: ${response.statusCode}.');
      // 返回一个空的List<MusicSheet>
      return false;
    }
  }

  // TODO: Dislike Music

  Future<bool> addRecent(String userId, String musicId) async {
    // 定义一个url，替换你的后端地址和端口
    String url = '${ip}/addRecent';
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
      return true;
    } else {
      // 如果状态码不是200，表示请求失败，打印或抛出异常
      print('Request failed with status: ${response.statusCode}.');
      // 返回一个空的List<MusicSheet>
      return false;
    }
  }

  Future<Music> getMusicDetail(String musicId) async {
    // 定义一个url，替换你的后端地址和端口
    String url = '${ip}/getMusicDetail';
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
    Music music = extractMusic(data);
    return music;
  }

  Future<List<Music>> getRecommendedMusicList(String userId) async {
    String url = '${ip}/recommend';
    // 定义一个map，存储请求的参数
    Map<String, Object> map = {
      'userId': userId,
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
        // 调用extractMusicSheetList函数，传入json对象，得到一个List<MusicSheet>
        List<Music> list = extractMusicList(data);
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

  Future<List<Music>> getGeneratedRecord(String userId) async {
    String url = '${ip}/getGenerateHistory';
    // 定义一个map，存储请求的参数
    Map<String, Object> map = {
      'userId': userId,
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
        // 调用extractMusicSheetList函数，传入json对象，得到一个List<MusicSheet>
        List<Music> list = extractMusicList(data);
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
  Future<List<Music>> getHistory(
      String userId, int currentPage, int pageSize) async {
    String url = '${ip}/getRecent';
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
        // 调用extractMusicSheetList函数，传入json对象，得到一个List<MusicSheet>
        List<Music> list = extractMusicList(data);
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

}
