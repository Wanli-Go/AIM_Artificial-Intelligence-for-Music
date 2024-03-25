import 'package:flutter/material.dart';
import 'package:music_therapy/main/model/GlobalMusic.dart';
import 'package:music_therapy/main/model/Music.dart'; // Make sure to import your Music model
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/model/user_data.dart';
import 'package:music_therapy/main/service/MusicService.dart';

class RecommendPage extends StatefulWidget {
  bool reloaded;
  final List<Music> musicList = [];
  RecommendPage({Key? key, this.reloaded = true}) : super(key: key);

  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  final MusicService _service = MusicService();
  int _selectedIndex = 0;
  bool isLoading = true;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  void _requestMusicList() async {
    if (widget.musicList.isEmpty || widget.reloaded) {
      await _service.getRecommendedMusicList(UserData.userId).then((value) {
        setState(() {
          widget.musicList.addAll(value);
          isLoading = false;
        });
      });
    }
    setState(() {
      isLoading = false;
      widget.reloaded = false;
    });
    await Future.delayed(Duration.zero);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        double itemHeight = 150;
        _pageController.animateTo(itemHeight * 2,
            duration: Duration(milliseconds: 1000), curve: Curves.easeOutCubic);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (isLoading) _requestMusicList();
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
    return isLoading
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("请求推荐音乐中...")
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left part
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(
                          8), // Add some padding inside the container
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
                          widget.musicList[_selectedIndex].name,
                          style: const TextStyle(
                              fontSize: 19,
                              color: Colors.black87,
                              shadows: [
                                Shadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                ),
                              ],
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20), // Add some spacing
                        // Display tags for the selected song
                        if (widget.musicList[_selectedIndex].tags !=
                            null) // Check if tags are not null
                          ...widget.musicList[_selectedIndex].tags!.entries
                              .map((entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${entry.key} :",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              " ${entry.value}%",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  shadows: [
                                                    Shadow(
                                                        blurRadius: 3,
                                                        color: Color.fromARGB(
                                                            255, 255, 192, 173),
                                                        offset: Offset(0, 1))
                                                  ],
                                                  color: mainTheme),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 10,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: LinearProgressIndicator(
                                              minHeight: 8,
                                              value: entry.value / 100,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Color.fromARGB(
                                                          255, 255, 216, 110)),
                                              backgroundColor:
                                                  Color(0xffD6D6D6),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                      ],
                    ),
                    const SizedBox(
                        height: 40,
                        child: Text(
                          "上下滑动 →",
                          style: TextStyle(color: Colors.grey),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),

              // Right part
              SizedBox(
                width: 150,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.45 - 70,
                      bottom: MediaQuery.of(context).size.height * 0.4 - 70),
                  scrollDirection: Axis.vertical,
                  itemCount: widget.musicList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex =
                                index; // Update the selected index on tap
                            GlobalMusic.music = widget.musicList[index];
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.musicList[index].image,
                            width: 130,
                            height: 130,
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
