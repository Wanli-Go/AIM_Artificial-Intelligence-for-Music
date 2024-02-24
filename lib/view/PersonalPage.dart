import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:music_therapy/theme.dart'; // Add this line for Neumorphic design

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final String _avatar = 'https://picsum.photos/id/114/200/200'; // Avatar URL
  final String _nickname = '清心'; // Nickname

  // List of items for a more dynamic and modern-looking UI
  final List<Map<String, dynamic>> _items = [
    {'icon': Icons.access_time_filled, 'title': '最近播放', 'route': '/songList'},
    {'icon': Icons.favorite, 'title': '我的收藏', 'route': '/favoriteMusic'},
    {
      'icon': Icons.receipt_outlined,
      'title': '生成记录',
      'route': '/favoriteMusic'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(), // Header section with avatar and nickname
            Expanded(child: _buildMenuList()), // Menu list section
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Neumorphic(
      style: NeumorphicStyle(
          depth: 10, // Adjust the depth of the Neumorphic effect
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(12)), // Rounded corners
          intensity: 0.5, // Intensity of shadow
          lightSource: LightSource.topRight, // Light source for shadow
          color: Colors.deepOrange),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.circle(),
              depth: 2,
              intensity: 0.3,
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(_avatar),
            ),
          ),
          const SizedBox(
            width: 20,
            height: 100,
          ),
          Expanded(
            child: Text(
              _nickname,
              style: TextStyle(
                color: NeumorphicTheme.defaultTextColor(context),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return NeumorphicButton(
          style: NeumorphicStyle(
              depth: 2, // Inward shadow for a "pressed" effect
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
              color: Colors.blueGrey.shade100.withOpacity(0.5)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onPressed: () {
            Navigator.pushNamed(context, item['route']);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(item['icon'], color: mainTheme),
                const SizedBox(width: 20),
                Text(
                  item['title'],
                  style: const TextStyle(fontSize: 18),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
