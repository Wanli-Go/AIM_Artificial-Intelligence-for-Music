import 'package:flutter/material.dart';
import 'package:music_therapy/theme.dart';
import 'package:music_therapy/view/HomePage.dart';
import 'package:music_therapy/view/PersonalPage.dart';
import 'package:music_therapy/view/RecommendSongListPage.dart';

import '../component/SideBar.dart';
import 'GeneratePage.dart';

  /*

  ScaffoldPage contains the scaffold that is used throughout the App.

  The Scaffold contains the following widgets:
  - A Bottom Navigation Bar that holds navigation to widgets in the List pageList.
  - A search botton at the "actions" attribute.
  - A Drawer that holds the SideBar widget.
  - A Column widget at the "body" attribute, which contains an Expanded Widget that 
    holds the current page in pageList.

  */
  
class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({super.key});

  @override
  _ScaffoldPageState createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  final List<Widget> pageList = [
    const HomePage(),
    const RecommendSongListPage(),
    const GeneratePage(),
    const PersonalPage()
  ];
  late int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('和韵心音'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement Search Logic
            },
          ),
        ],
      ),
      body: Column(
        children: [Expanded(child: pageList[currentIndex])],
      ),
      drawer: const SideBar(),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: mainTheme,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        selectedLabelStyle: TextStyle(color: mainTheme),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: '推荐',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: '生成',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
