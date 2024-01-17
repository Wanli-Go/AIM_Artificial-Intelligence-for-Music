import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  // 定义一些模拟数据
  final String _avatar = 'https://picsum.photos/id/1/200/200'; // 头像
  final String _nickname = '小明'; // 昵称
  final List<Map<String, dynamic>> _items = [
    // 列表项
    {'icon': Icons.access_time_filled, 'title': '最近播放', 'route': '/songList'},
    {'icon': Icons.favorite ,'title': '我的收藏', 'route': '/favoriteMusic'},
    {'icon': Icons.receipt_outlined ,'title': '生成记录', 'route': '/favoriteMusic'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        // 使用ListView组件显示内容
        children: [
          Container(
            // 头部容器
            height: 200,
            color: Colors.red,
            child: Padding(
              // 填充
              padding: const EdgeInsets.all(20),
              child: Row(
                // 水平布局
                children: [
                  CircleAvatar(
                    // 圆形头像
                    radius: 40,
                    backgroundImage: NetworkImage(_avatar),
                  ),
                  const SizedBox(width: 20), // 间隔
                  Column(
                    // 垂直布局
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // 昵称
                        _nickname,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            // 底部容器
            color: Colors.grey[200],
            child: Column(
              // 垂直布局
              children: _items.map((item) {
                // 遍历列表项
                return InkWell(
                  // 列表项
                  onTap: () {
                    // 点击事件
                    Navigator.pushNamed(context, item['route']); // 跳转到对应的页面
                  },
                  child: Container(
                    // 容器
                    height: 60,
                    color: Colors.white,
                    child: Padding(
                      // 填充
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        // 水平布局
                        children: [
                          Icon(
                            // 图标
                            item['icon'],
                            color: Colors.red,
                          ),
                          const SizedBox(width: 20), // 间隔
                          Text(
                            // 标题
                            item['title'],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(), // 占位
                          const Icon(
                            // 右箭头
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
