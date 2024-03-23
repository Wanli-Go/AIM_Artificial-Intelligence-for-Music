import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:music_therapy/main/component/Disc.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/model/dialog_provider.dart';
import 'package:music_therapy/main/model/global_controller.dart';
import 'package:music_therapy/main/view/DialogPage.dart';
import 'package:music_therapy/main/view/HomePage.dart';
import 'package:music_therapy/main/view/MusicPlayPage.dart';
import 'package:music_therapy/main/view/PersonalPage.dart';
import 'package:music_therapy/main/view/RecommendPage.dart';
import 'package:provider/provider.dart';
import 'GeneratePage.dart';

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
    RecommendPage(
      key: UniqueKey(),
    ),
    GeneratePage(key: UniqueKey()),
    const PersonalPage()
  ];

  int currentIndex = 0;
  bool pendingRefresh = false;

  void _refresh(int targetPage) async {
    await Future.delayed(Duration.zero);
    setState(() {
      pendingRefresh = true;
    });
    currentIndex = targetPage;
    if (mounted && targetPage != 0) {
      _motionTabBarController!.index = 0;
      await Future.delayed(Duration(milliseconds: 800));
      _motionTabBarController!.index = targetPage;
    }
    setState(() {
      pendingRefresh = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DialogProvider>(builder: (context, dialogProvider, child) {
      // Rebuild Logic
      if (dialogProvider.submitted != 0) {
        int refreshedPage = dialogProvider.submitted;
        _pageList.removeAt(1);
        _pageList.removeAt(1);
        _pageList.insert(
          1,
          GeneratePage(key: UniqueKey()),
        );
        _pageList.insert(
          1,
          RecommendPage(
            key: UniqueKey(),
          ),
        );
        _refresh(refreshedPage);
        dialogProvider.reset();
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: appBarTheme,
          title: Row(
            children: [
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MusicPlayPage()));
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
        body: pendingRefresh ? 
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20,),
              Text(
                '正在处理结果...',
                style: TextStyle(color: mainTheme),
              ),
            ],
          ),
        )
        : TabBarView(
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
              currentIndex = value;
              _motionTabBarController!.index = value;
            });
          },
        ),
        floatingActionButton: (currentIndex == 1 || currentIndex == 2)
            ? FloatingActionButton(
                backgroundColor: Colors.grey[50],
                foregroundColor: Colors.black87,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.comment_bank_rounded,
                      size: 30,
                    ),
                    Text(
                      "疗愈助手",
                      style: TextStyle(fontSize: 9.5),
                    ),
                    SizedBox()
                  ],
                ),
                onPressed: () => {
                      showDialog(
                        context: context,
                        builder: _dialogBuilder,
                      )
                    })
            : null,
      );
    });
  }

  Widget _dialogBuilder(BuildContext context) {
    return AlertDialog(
        title: const Text(
          '与疗愈助手对话\n获取你想要的音乐。🎵',
          style: TextStyle(fontSize: 15, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        content: const DialogPage(),
        shadowColor: mainTheme,
        surfaceTintColor: Colors.white,
        insetPadding: const EdgeInsets.only(bottom: 15),
        contentPadding: const EdgeInsets.all(10),
        actions: null);
  }
}
