
import 'package:flutter/material.dart';
import 'package:music_therapy/view/FavoriteMusicListPage.dart';

import '../view/SongListPage.dart';
class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('清心'),
            accountEmail: Text('qingxin3142@163.com'),
            currentAccountPicture: CircleAvatar(
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