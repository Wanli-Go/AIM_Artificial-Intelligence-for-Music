import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:music_therapy/main/component/Disc.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/model/controller_provider.dart';
import 'package:music_therapy/main/view/HomePage.dart';
import 'package:music_therapy/main/view/MusicPlayPage.dart';
import 'package:music_therapy/main/view/PersonalPage.dart';
import 'package:music_therapy/main/view/RecommendSongListPage.dart';
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

class _ScaffoldPageState extends State<ScaffoldPage>
    with TickerProviderStateMixin {
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
        automaticallyImplyLeading: false,
        backgroundColor: appBarTheme,
        title: Row(
          children: 
          [
            const Icon(Icons.headset_outlined),
            const SizedBox(
              width: 15,
            ),
            Text(
              '音乐疗愈助手 AIM',
              style: appBarTextStyle,
            ),
          ],
        ),

        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MusicPlayPage()));
            },
            child: Row(
              children: [
                Hero(
                  tag: "player",
                  child: Disc(
                    scaleFactor: 0.8,
                    controller: globalController!,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          )
        ],
        iconTheme: IconThemeData(color: mainTheme),

      ),

      body: TabBarView(
          physics:
              const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
          controller: _motionTabBarController,
          children: _pageList),

      drawer: null,

      bottomNavigationBar: MotionTabBar(
        controller:
            _motionTabBarController, // Add this controller if you need to change your tab programmatically
        initialSelectedTab: "首页",
        useSafeArea: true, // default: true, apply safe area wrapper
        labels: const ["首页", "疗愈·推荐", "疗愈·生成", "设置"],
        icons: const [
          Icons.home_filled,
          Icons.queue_music_rounded,
          Icons.generating_tokens,
          Icons.miscellaneous_services_rounded
        ],
        // optional badges, length must be same with labels
        badges: const [null, null, null, null],
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
    );
  }
}
