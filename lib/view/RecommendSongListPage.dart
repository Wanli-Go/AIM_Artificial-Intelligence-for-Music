import 'package:flutter/material.dart';
import 'package:music_therapy/model/Music.dart'; // Make sure to import your Music model
import 'package:music_therapy/theme.dart';

class RecommendSongListPage extends StatefulWidget {
  const RecommendSongListPage({Key? key}) : super(key: key);

  @override
  _RecommendSongListPageState createState() => _RecommendSongListPageState();
}

class _RecommendSongListPageState extends State<RecommendSongListPage> {
  // Use the provided fakeMusicList
  final List<Music> fakeMusicList = Music.fakeMusicList;

  int _selectedIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      // 获取当前的滚动位置
      double position = _pageController.position.pixels;
      // 获取每个图片的高度，假设为 200 像素
      double itemHeight = 150;
      // 计算当前选中的图片的索引，根据滚动位置和图片高度进行四舍五入
      int index = (position / itemHeight).round();
      // 如果索引与 _selectedIndex 不同，说明图片已经切换，调用 _updateSelection 方法，传入当前的索引
      if (index != _selectedIndex) {
        _updateSelection(index);
      }
    });
  }

  void _updateSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding:
                    const EdgeInsets.all(8), // Add some padding inside the container
                decoration: BoxDecoration(
                  color: Colors
                      .white, // Set the fill color of the container (optional)
                  border: Border.all(
                    color:
                        mainTheme, // Use your main theme color for the border
                    width: 2, // Set the border width
                  ),
                  borderRadius: BorderRadius.circular(
                      12), // Set the border radius for rounded corners
                ),
                child: Text(
                  "为你的\n推荐音乐",
                  style: TextStyle(
                      fontSize: 30,
                      color: mainTheme,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment
                    .end, // Align the text and progress bars to the start
                children: [
                  Text(
                    fakeMusicList[_selectedIndex].name,
                    style: const TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(255, 129, 70, 52),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20), // Add some spacing
                  // Display tags for the selected song
                  if (fakeMusicList[_selectedIndex].tags !=
                      null) // Check if tags are not null
                    ...fakeMusicList[_selectedIndex]
                        .tags!
                        .entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${entry.key} : ${entry.value}%",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  LinearProgressIndicator(
                                    value: entry.value /
                                        100, // Assuming the tag values are out of 100
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.amber[300],
                                    minHeight: 8,
                                  ),
                                ],
                              ),
                            )),
                ],
              ),
              const SizedBox(
                height: 40,
                child: Text("↑ ↓ 上下滑动", style: TextStyle(color: Colors.grey),)),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: 150,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5 - 150,
                bottom: MediaQuery.of(context).size.height * 0.5 - 150),
            scrollDirection: Axis.vertical,
            itemCount: fakeMusicList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex =
                          index; // Update the selected index on tap
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      fakeMusicList[index].image,
                      width: 150,
                      height: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            controller: _pageController,
          ),
        ),
      ],
    );
  }
}
