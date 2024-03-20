import 'package:flutter/material.dart';
import 'package:music_therapy/main/model/MusicSheet.dart';
import 'package:music_therapy/main/service/MusicService.dart';
import 'package:music_therapy/main/view/MusicDetailPage.dart';
import 'package:music_therapy/main/view/MusicPlayPage.dart';

import '../model/Music.dart';
// 定义一个最近播放页面的组件
class MusicSheetPage extends StatefulWidget {
  const MusicSheetPage({super.key,required this.musicSheet});
  final MusicSheet musicSheet;
  @override
  _MusicSheetPageState createState() => _MusicSheetPageState();
}

// 定义一个最近播放页面的状态类，继承自 State<RecentPlayPage>
class _MusicSheetPageState extends State<MusicSheetPage> {
  // 定义一个列表，用于存储最近播放的歌曲信息
  List<Music> _musicSheet = [];
  final RecentlyPlayedMusicService musicService=RecentlyPlayedMusicService();
  // 定义一个方法，用于从本地存储中获取最近播放的歌曲信息
  void _getRecentSongs() async {
    musicService.getMusicListBySheet("1",widget.musicSheet.musicSheetId).then((value) {
      setState(() {
        _musicSheet.addAll(value);
      });
    });
  }

  // 定义一个方法，用于清空最近播放的歌曲信息
  void _clearRecentSongs() async {
    _musicSheet=[];
  }

  // 定义一个方法，用于在页面初始化时调用
  @override
  void initState() {
    super.initState();
    // 调用获取最近播放的歌曲信息的方法
    _getRecentSongs();
  }

  // 定义一个方法，用于构建页面的界面
  @override
  Widget build(BuildContext context) {
    // 返回一个 Scaffold 组件，用于创建页面的基本结构
    return Scaffold(
      // 设置页面的标题栏
      appBar: AppBar(
        // 设置标题栏的标题
        title: Text(widget.musicSheet.musicSheetName),
        // 设置标题栏的右侧按钮
        actions: [
          // 如果列表不为空，则显示一个清空按钮
          if (_musicSheet.isNotEmpty)
            IconButton(
              // 设置按钮的图标
              icon: const Icon(Icons.delete),
              // 设置按钮的提示文本
              tooltip: '清空最近播放',
              // 设置按钮的点击事件
              onPressed: _clearRecentSongs,
            ),
        ],
      ),
      // 设置页面的主体内容
      body: _musicSheet.isEmpty
      // 如果列表为空，则显示一个居中的文本
          ? const Center(
        child: Text('暂无最近播放的歌曲'),
      )
      // 如果列表不为空，则显示一个列表视图
          : ListView.builder(
        // 设置列表的长度
        itemCount: _musicSheet.length,
        // 设置列表的构建器
        itemBuilder: (context, index) {
          // 获取当前索引的歌曲对象
          Music music = _musicSheet[index];
          // 返回一个列表项组件
          return buildListTile(music, context);
        },
      ),
    );
  }

  ListTile buildListTile(Music music, BuildContext context) {
    return ListTile(
          // 设置列表项的左侧图标，显示歌曲的封面
          leading: Image.network(music.image),
          // 设置列表项的标题，显示歌曲的名称
          title: Text(music.name),
          // 设置列表项的副标题，显示歌曲的歌手和专辑
          subtitle: Text(music.singer),
          // 设置列表项的右侧图标，显示一个更多选项的按钮
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                // 设置按钮的图标，根据 isLike 属性的值显示不同的颜色
                icon: Icon(
                  Icons.favorite,
                  color: music.isLike ? Colors.red : Colors.grey,
                ),
                // 设置按钮的点击事件
                onPressed: () {
                  // 调用改变 isLike 属性的方法
                  _toggleLike(music);
                },
              ),
              IconButton(
                // 设置按钮的图标
                icon: const Icon(Icons.more_vert),
                // 设置按钮的提示文本
                tooltip: '更多选项',
                // 设置按钮的点击事件
                onPressed: () {
                  // 显示一个底部弹出菜单
                  showModalBottomSheet(
                    // 设置菜单的上下文
                    context: context,
                    // 设置菜单的构建器
                    builder: (context) {
                      // 返回一个列组件，用于显示菜单的选项
                      return Column(
                        // 设置列的主轴对齐方式为最小
                        mainAxisSize: MainAxisSize.min,
                        // 设置列的子组件
                        children: [
                          // 创建一个菜单项组件，用于显示删除该歌曲的选项
                          ListTile(
                            leading: const Icon(Icons.details),
                            // 设置菜单项的标题
                            title: const Text('歌曲详情'),
                            // 设置菜单项的点击事件
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => MusicDetailPage(music: music), // 将数据传递给下一个页面
                              ));
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MusicPlayPage()
          )
          );
        },
        );
  }

  // 定义一个方法，用于改变歌曲的 isLike 属性
  void _toggleLike(Music music) async {
      music.isLike = !music.isLike;
      if(music.isLike){
        musicService.likeMusic("1", music.musicId);
      }else{
        musicService.dislikeMusic("1", music.musicId);
      }
      setState(() {});
    }


}
