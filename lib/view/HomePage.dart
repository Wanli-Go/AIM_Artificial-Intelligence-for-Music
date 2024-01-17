import 'package:flutter/material.dart';
import 'package:music_therapy/component/BottomMusicBar.dart';
import 'package:music_therapy/service/MusicService.dart';
import 'package:music_therapy/service/MusicSheetService.dart';
import 'package:music_therapy/view/MusicSheetPage.dart';

import '../model/GlobalMusic.dart';
import '../model/Music.dart';
import '../model/MusicSheet.dart';

/*
  HomePage displays the main interface for the app, focusing on music discovery and recent plays.
  It provides users with easy access to new and frequently played music, enhancing the overall music discovery experience in the app.

  Features of HomePage:

  - A vertically scrollable interface using a SingleChildScrollView.

  - Two main sections:
    1. Recommended Playlists: 
      Horizontally scrollable list of music playlists. Uses ListView.builder for dynamic playlist rendering.
    2. Recently Played Music: 
      Vertical list of recently played tracks. Same technique as above.

  - Each section fetches data from respective services: 
      RecommendMusicSheetsService for playlists and RecentlyPlayedMusicService for recent tracks.

  - Utilizes state management to update UI based on fetched data.

  - For music control, a BottomMusicBar widget is shown at the bottom. It plays the global music from the GlobalMusic model
      (It's in parallel with the Bottom Navigation bar from the Scaffold Page.)
  */


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<MusicSheet> _recommendedMusicSheetsList = [];
  final List<Music> _recentlyPlayedMusicList = [];
  final RecommendMusicSheetsService recommendService = RecommendMusicSheetsService();
  final RecentlyPlayedMusicService recentlyPlayedMusicService = RecentlyPlayedMusicService();

  // Added variables to track loading state
  bool _isLoadingRecommendedMusicSheets =  true;
  bool _isLoadingRecentlyPlayedMusic = true;

  @override
  void initState() {
    super.initState();

    // Fetch recently played music
    recentlyPlayedMusicService.getRecent("1", 0, 10).then((value) {
      if (mounted) {
        setState(() {
          _recentlyPlayedMusicList.addAll(value);
          GlobalMusic.music = _recentlyPlayedMusicList.first;
          _isLoadingRecentlyPlayedMusic = false; // Update loading state
        });
      }
    });

    // Fetch recommended music sheets
    recommendService.getMusicSheet(0, 10).then((value) {
      if (mounted) {
        setState(() {
          _recommendedMusicSheetsList.addAll(value);
          _isLoadingRecommendedMusicSheets = false; // Update loading state
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Recommended Music Sheets Section
                _isLoadingRecommendedMusicSheets 
                ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                : _buildRecommendedMusicSheetsSection(),

                SizedBox(height: (_isLoadingRecentlyPlayedMusic && _isLoadingRecommendedMusicSheets) ? MediaQuery.of(context).size.height * 0.4 : 1),

                // Recently Played Music Section
                _isLoadingRecentlyPlayedMusic 
                ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                : _buildRecentlyPlayedMusicSection(),
              ],
            ),
          ),
        ),
        BottomMusicBar(music: GlobalMusic.music)
      ],
    );
  }

    /* 添加推荐歌单
    This Flutter widget is a Container containing a Column with two main children:
        1. A Text widget for displaying the title '推荐歌单'.
        2. An Expanded widget wrapping a ListView.builder for a horizontally scrolling list.
          The ListView.builder generates items using a GestureDetector containing a Container. Each item in the list consists of:
          - A ClipRRect with an Image.network for displaying images.
          - A Text widget for showing the name of the music sheet.
          On tapped, it navigates to a MusicSheet Page with the specified music sheet.
    */
  Widget _buildRecommendedMusicSheetsSection() {
    return Flexible(
      // 添加灵活组件
      child: Container(
        height: 200.0,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '推荐歌单',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // 横向列表
                itemCount: _recommendedMusicSheetsList
                    .length, // 列表项的数量，使用_recommendedMusicList的长度
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MusicSheetPage(
                            musicSheet: _recommendedMusicSheetsList[index]),
                        // 将数据传递给下一个页面，使用_recommendedMusicList中的元素
                      ));
                    },
                    child: Container(
                      width: 110.0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              // 使用网络图片作为示例，使用_musicSheetList中的元素的图片
                              _recommendedMusicSheetsList[index].image ??
                                  'https://picsum.photos/id/${index + 20}/110/110',
                              fit: BoxFit.cover, // 按照原始比例显示
                            ),
                          ),
                          // const SizedBox(height: 0.0), // 图片和文字之间的空隙
                          Text(
                            // 使用_musicSheetList中的元素的名称
                            _recommendedMusicSheetsList[index].musicSheetName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


    /* 常听音乐组件
    This widget is a Container with a dynamic height set to half of the screen's height. It contains a Column with two children:

    1. A Text widget labeled '常听音乐' ('Frequently Played Music'), styled with a bold, 18.0 font size.
    2. An Expanded widget wrapping a ListView.builder for a vertical list.
      The ListView.builder creates a list of items based on _recentlyPlayedMusicList's length. Each item is a ListTile with:
      - A leading ClipRRect containing an Image.network for images.
      - A title Text displaying the music name, with a font size scaled to the screen's height.
      - A subtitle Text showing the singer's name, also with a dynamic font size.
      - A trailing icon (Icon(Icons.more_vert)).
      - TODO: An onTap event placeholder for future functionality.
    */
  Widget _buildRecentlyPlayedMusicSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5, // 根据屏幕高度自动调整
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '常听音乐',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical, // 纵向列表
              itemCount: _recentlyPlayedMusicList.length, // 列表项的数量
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      _recentlyPlayedMusicList[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    _recentlyPlayedMusicList[index].name,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          0.02, // 根据屏幕高度自动调整
                    ),
                  ),
                  subtitle: Text(
                    _recentlyPlayedMusicList[index].singer,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                    ),
                  ),
                  trailing: const Icon(Icons.more_vert),
                  onTap: () {
                    // TODO: Display Music Detail / Play Music
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
