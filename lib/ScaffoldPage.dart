import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:music_therapy/theme.dart';
import 'package:music_therapy/view/HomePage.dart';
import 'package:music_therapy/view/PersonalPage.dart';
import 'package:music_therapy/view/RecommendSongListPage.dart';


import 'component/SideBar.dart';
import 'view/GeneratePage.dart';

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

class _ScaffoldPageState extends State<ScaffoldPage> with TickerProviderStateMixin{
  
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();
    
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  final List<Widget> _pageList = [
    HomePage(),
    const RecommendSongListPage(),
    const GeneratePage(),
    const PersonalPage()
  ];
  late int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 245, 243),
        title: Text('音乐疗愈助手 AIM', style: TextStyle(color: Colors.grey.shade800),),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              // TODO: Implement Search Logic
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.deepOrange.shade700),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        controller: _motionTabBarController,
        children: _pageList
      ),

      drawer: const SideBar(),

      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController, // Add this controller if you need to change your tab programmatically
        initialSelectedTab: "首页",
        useSafeArea: true, // default: true, apply safe area wrapper
        labels: const ["首页", "推荐", "生成", "设置"],
        icons: const [Icons.home_filled, Icons.queue_music_rounded, Icons.generating_tokens, Icons.miscellaneous_services_rounded],
        // optional badges, length must be same with labels
        badges: const [null, null, null, null],
          // Default Motion Badge Widget
          /* const MotionBadgeWidget(
            text: '10+',
            textColor: Colors.white, // optional, default to Colors.white
            color: Colors.red, // optional, default to Colors.red
            size: 18, // optional, default to 18
          ),
          // custom badge Widget
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(2),
            child: const Text(
              '48',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          // allow null
          null,
          // Default Motion Badge Widget with indicator only
          const MotionBadgeWidget(
            isIndicator: true,
            color: Colors.red, // optional, default to Colors.red
            size: 5, // optional, default to 5,
            show: true, // true / false
          ),
        ],*/
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: unselectedItemColor,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: mainTheme,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
      
      /*
      BottomNavigationBar(
        unselectedItemColor: Colors.grey.shade400,
        selectedItemColor: mainTheme,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        selectedLabelStyle: TextStyle(color: mainTheme),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music_rounded),
            label: '推荐',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.generating_tokens),
            label: '生成',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services_rounded),
            label: '设置',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      */
    );
  }
}
