
import 'package:flutter/material.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/view/FavoriteMusicListPage.dart';

import '../view/SongListPage.dart';
class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.67 * MediaQuery.of(context).size.width,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, mainTheme])
            ),
            accountName: const Text('清心'),
            accountEmail: const Text('qingxin3142@163.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/id/114/200/200'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('最近播放'),
            onTap: () {
              // TODO: 跳转到本地音乐页面
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const SongListPage(), // 将数据传递给下一个页面
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('我的收藏'),
            onTap: () {
              // // TODO: 跳转到我的收藏页面
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const FavoriteMusicListPage(), // 将数据传递给下一个页面
              ));
            },
          ),
        ],
      ),
    );
  }
}