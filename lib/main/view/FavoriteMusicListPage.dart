import 'package:flutter/material.dart';
import 'package:music_therapy/main/model/GlobalMusic.dart';
import 'package:music_therapy/main/service/MusicService.dart';

import '../model/Music.dart';
// 定义一个最近播放页面的组件，继承自 StatefulWidget
class FavoriteMusicListPage extends StatefulWidget {
  const FavoriteMusicListPage( {super.key});
  

  @override
  _FavoriteMusicListPageState createState() => _FavoriteMusicListPageState();
}

// 定义一个最近播放页面的状态类，继承自 State<RecentPlayPage>
class _FavoriteMusicListPageState extends State<FavoriteMusicListPage> {
  // 定义一个列表，用于存储最近播放的歌曲信息
  List<Music> _recentSongs = [];
  final MusicService musicService=MusicService();
  // 定义一个方法，用于从本地存储中获取最近播放的歌曲信息

  // 定义一个方法，用于清空最近播放的歌曲信息
  void _clearRecentSongs() async {
    setState(() {
    _recentSongs=[];
    });
  }

  // 定义一个方法，用于在页面初始化时调用
  @override
  void initState() {
    super.initState();
    // 调用获取最近播放的歌曲信息的方法
          musicService.getRecent("1", 0, 10).then((value) {
      if (mounted) {
        setState(() {
          _recentSongs.addAll(value);
        });
      }
    });
  }

  // 定义一个方法，用于构建页面的界面
  @override
  Widget build(BuildContext context) {
    // 返回一个 Scaffold 组件，用于创建页面的基本结构
    return Scaffold(
      // 设置页面的标题栏
      appBar: AppBar(
        // 设置标题栏的标题
        title: const Text('我的收藏'),
        // 设置标题栏的右侧按钮
        actions: [
          // 如果列表不为空，则显示一个清空按钮
          if (_recentSongs.isNotEmpty)
            IconButton(
              // 设置按钮的图标
              icon: const Icon(Icons.delete),
              // 设置按钮的提示文本
              tooltip: '清空全部收藏',
              // 设置按钮的点击事件
              onPressed: _clearRecentSongs,
            ),
        ],
      ),
      // 设置页面的主体内容
      body: _recentSongs.isEmpty
      // 如果列表为空，则显示一个居中的文本
          ? const Center(
        child: Text('·正在加载收藏歌曲·'),
      )
      // 如果列表不为空，则显示一个列表视图
          : Container(
      height: MediaQuery.of(context).size.height * 0.9, // 根据屏幕高度自动调整
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '↓ 由新到旧',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical, // 纵向列表
              itemCount: _recentSongs.length, // 列表项的数量
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      _recentSongs[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    _recentSongs[index].name,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          0.02, // 根据屏幕高度自动调整
                    ),
                  ),
                  subtitle: Text(
                    _recentSongs[index].singer,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                    ),
                  ),
                  trailing: const Icon(Icons.more_vert),
                  onTap: () {
                    // Update the global music to the one that was tapped
                    GlobalMusic.music = _recentSongs[index];
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}
