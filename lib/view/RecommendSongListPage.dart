import 'package:flutter/material.dart';
import 'package:music_therapy/model/GlobalMusic.dart';

import 'MusicPlayPage.dart';

/*
RecommendSongListPage displays a list of recommended songs with image and text.
This page provides an interactive way for users to explore and select from a list of recommended songs.

Features of RecommendSongListPage:
- A horizontally split view, with text on the left and a vertical scrollable image list on the right.
- The image list is dynamically generated from a list of maps containing song details.
- Each song item in the list is represented by an image and a title.
- Tapping on a song image navigates to the MusicPlayPage with the selected song's details.
- Tracks the currently selected song index and updates the display accordingly.

State Management:
- Uses a PageController to manage the scroll position of the song list.
- The selected song's index is updated based on the scroll position.

NOTE: This page assumes that each picture is 200 pixels
*/

// 定义一个有状态的组件，用于实现页面需求
class RecommendSongListPage extends StatefulWidget {
  // 构造函数，接收一个图片和文字的列表作为参数
  const RecommendSongListPage({Key? key}) : super(key: key);

  // 定义一个 final 类型的变量，用于存储图片和文字的列表

  // 创建组件的状态对象
  @override
  _RecommendSongListPageState createState() => _RecommendSongListPageState();
}

// 定义组件的状态类，继承自 State<MyPage>
class _RecommendSongListPageState extends State<RecommendSongListPage> {
  List<Map<String, String>> testitems = [
    // 第一个元素，包含一个图片的地址和一个文字
    {'image': 'https://picsum.photos/id/51/200/200', 'text': '歌曲1'},
    // 第二个元素，包含一个图片的地址和一个文字
    {'image': 'https://picsum.photos/id/52/200/200', 'text': '歌曲2'},
    // 第三个元素，包含一个图片的地址和一个文字
    {'image': 'https://picsum.photos/id/53/200/200', 'text': '歌曲3'},
    // 第四个元素，包含一个图片的地址和一个文字
    {'image': 'https://picsum.photos/id/54/200/200', 'text': '歌曲4'},
    {'image': 'https://picsum.photos/i/55/200/200', 'text': '新加坡的天际线在黄昏时分'},
    // 第二个元素，包含一个图片的地址和一个文字
    {'image': 'https://picsum.photos/id/56/200/200', 'text': '新加坡的国家象征——鱼尾狮'},
    // 第三个元素，包含一个图片的地址和一个文字
    {'image': 'https://picsum.photos/id/57/200/200', 'text': '新加坡植物园的棕榈谷'},
    // 第四个元素，包含一个图片的地址和一个文字
    {'image': 'https://picsum.photos/id/58/200/200', 'text': '新加坡的唐人街'},
    {'image': 'https://picsum.photos/id/59/200/200', 'text': '新加坡的天际线在黄昏时分'},
  ];

  // 定义一个 int 类型的变量，用于记录当前选中的图片的索引
  int _selectedIndex = 0;

  // 定义一个 PageController 类型的变量，用于控制 ListView 的滚动
  final PageController _pageController = PageController();

  // 定义一个方法，用于根据索引更新选中的图片和文字
  void _updateSelection(int index) {
    // 调用 setState 方法，通知 Flutter 框架，该组件的状态已经改变，需要重新构建界面
    setState(() {
      // 更新 _selectedIndex 的值为 index
      _selectedIndex = index;
    });
  }

  // 重写 initState 方法，用于在组件初始化时执行一些操作
  @override
  void initState() {
    // 调用父类的 initState 方法
    super.initState();
    // 给 _pageController 添加一个滚动监听器，用于检测 ListView 的滚动事件
    _pageController.addListener(() {
      // 获取当前的滚动位置
      double position = _pageController.position.pixels;
      // 获取每个图片的高度，假设为 200 像素
      double itemHeight = 200;
      // 计算当前选中的图片的索引，根据滚动位置和图片高度进行四舍五入
      int index = (position / itemHeight).round();
      // 如果索引与 _selectedIndex 不同，说明图片已经切换，调用 _updateSelection 方法，传入当前的索引
      if (index != _selectedIndex) {
        _updateSelection(index);
      }
    });
  }

  // 重写 dispose 方法，用于在组件销毁时执行一些操作
  @override
  void dispose() {
    // 调用父类的 dispose 方法
    super.dispose();
    // 释放 _pageController 的资源，避免内存泄漏
    _pageController.dispose();
  }

  // 重写 build 方法，返回一个 Widget，用于构建组件的界面
  @override
  Widget build(BuildContext context) {
    // 返回一个 Row 组件，用于水平排列两个子组件
    return Row(
      // 设置主轴对齐方式为居中
      mainAxisAlignment: MainAxisAlignment.center,
      // 设置子组件列表
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 10),
          // 设置子组件，使用 SizedBox 组件，占据一个空的位置
          child: SizedBox(),
        ),

        // 第一个子组件，用于显示左侧的文字
        // 使用 Expanded 组件，使其占据剩余的空间
        Expanded(
          // 使用 Text 组件，显示当前选中的图片对应的文字
          // 使用 widget.items[_selectedIndex]['text'] 获取文字，widget 表示该组件的实例，items 表示传入的图片和文字的列表，_selectedIndex 表示当前选中的图片的索引，text 表示文字的键
          child: Text(
            testitems[_selectedIndex]['text'] ?? '',
            // 设置文字的样式，可以根据需要修改
            style: const TextStyle(
              fontSize: 24,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            // 设置文字的对齐方式为居中
            textAlign: TextAlign.center,
          ),
        ),
        
        // 第二个子组件，用于显示右侧的图片列表
        // 使用 Container 组件，设置其宽度为 200 像素，高度为 MediaQuery.of(context).size.height，表示屏幕的高度
        SizedBox(
          width: 200,
          height: MediaQuery.of(context).size.height,
          // 使用 ListView 组件，创建一个可以滚动的图片列表
          child: ListView.builder(
            // 设置滚动方向为垂直
            scrollDirection: Axis.vertical,
            // 设置列表项的数量为 widget.items.length，表示图片和文字的列表的长度
            itemCount: testitems.length,
            // 设置列表项的构建器，接收一个上下文和一个索引作为参数，返回一个 Widget
            itemBuilder: (context, index) {
              // 返回一个 Padding 组件，用于给图片添加一些外边距
              // 设置 padding 的值为 EdgeInsets.all(10)，表示上下左右都有 10 像素的空隙
              return Padding(
                  padding: const EdgeInsets.all(10),
                  // 设置子组件，使用 Image 组件，加载和显示图片
                  // 使用 widget.items[index]['image'] 获取图片的地址，widget 表示该组件的实例，items 表示传入的图片和文字的列表，index 表示当前的索引，image 表示图片的键
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MusicPlayPage(
                            music: GlobalMusic
                                .music), // 将数据传递给下一个页面，使用_musicSheetList中的元素
                      ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      // 设置子组件，使用 Image 组件，加载和显示图片
                      // 使用 widget.items[index]['image'] 获取图片的地址，widget 表示该组件的实例，items 表示传入的图片和文字的列表，index 表示当前的索引，image 表示图片的键
                      child: Image.network(
                        testitems[index]['image'] ?? '',
                        // 设置图片的宽度为 200 像素，高度为 200 像素
                        width: 200,
                        height: 180,
                        // 设置图片的缩放模式为 cover，表示保持图片的比例，填充满容器
                        fit: BoxFit.cover,
                      ),
                    ),
                  ));
            },
            // 设置控制器为 _pageController，用于控制 ListView 的滚动
            controller: _pageController,
          ),
        ),
        // 添加一个 Padding 组件，用于给图片列表添加一些右边距
        // 设置 padding 的值为 EdgeInsets.only(right: 10)，表示只有右边有 10 像素的空隙
        const Padding(
          padding: EdgeInsets.only(right: 10),
          // 设置子组件，使用 SizedBox 组件，占据一个空的位置
          child: SizedBox(),
        ),
      ],
    );
  }
}
