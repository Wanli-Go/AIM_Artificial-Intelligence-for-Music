import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_therapy/component/Disc.dart';
import 'package:music_therapy/theme.dart';
import 'package:music_therapy/view/MusicPlayPage.dart';

import '../model/GlobalMusic.dart';
import '../model/Music.dart';

/*
BottomMusicBar provides an interactive music control bar at the bottom of the app,
   serving as a quick access point for users to control music playback and view currently playing track details.

Features of BottomMusicBar:
- Takes a Music object from GlobalMusic model as a parameter for displaying song details.
- Utilizes an AudioPlayer from GlobalMusic for playback control.
- Displays song information (name, singer) and album art.
- Includes play/pause functionality, reacting to the player's state.
- Tapping on the bar navigates to the MusicPlayPage with the current song.

State Management:
- Listens to and updates UI based on the audio player's state, current position, and track duration.
- PlayerState, position, and duration are managed globally and reflect the current playback status.


*/

class BottomMusicBar extends StatefulWidget {
  // 定义一个Music对象作为参数
  // 定义一个构造函数，接收music参数
  BottomMusicBar({super.key});

  @override
  _BottomMusicBarState createState() => _BottomMusicBarState();
}

class _BottomMusicBarState extends State<BottomMusicBar> {
  Music music = GlobalMusic.music;
  AudioPlayer audioPlayer = GlobalMusic.globalAudioPlayer;
  // 创建一个音频播放状态变量
  PlayerState playerState = GlobalMusic.globalPlayerState;
  // 创建一个音频播放进度变量
  Duration position = GlobalMusic.globalPosition;
  // 创建一个音频总时长变量
  Duration duration = GlobalMusic.globalDuration;

  @override
  void initState() {
    super.initState();
    // 监听音频播放器的状态变化
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          music = GlobalMusic.music;

          playerState = state;
        });
      }
    });
    // 监听音频播放器的进度变化
    audioPlayer.onPositionChanged.listen((pos) {
      if (mounted) {
        setState(() {
          position = pos;
        });
      }
    });
    // 监听音频播放器的时长变化
    audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) {
        setState(() {
          duration = dur;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 返回一个高度为100的Container
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                MusicPlayPage(music: GlobalMusic.music), // 将数据传递给下一个页面
          ));
        },
        child: Container(
          decoration: const BoxDecoration(
            // Define the linear gradient
            gradient: LinearGradient(
              // Colors of the gradient: white at the top, light grey at the bottom
              colors: [Colors.white, Color.fromARGB(255, 251, 236, 231)],
              // Start of the gradient
              begin: Alignment.topCenter,
              // End of the gradient
              end: Alignment.bottomCenter,
            ),
          ),
          child: SizedBox(
            height: 110,
            // 使用Row布局，水平排列子组件
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Divider(thickness: 1.8, height: 0, color: Colors.grey.shade300),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    // 设置子组件之间的间距
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // 定义子组件列表
                    children: [
                      const Disc(
                        scaleFactor: 1.00,
                      ),

                      // 显示歌曲名称和歌手，使用Column布局，垂直排列子组件
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // 设置子组件居中对齐
                        // 定义子组件列表
                        children: [
                          // 显示歌曲名称，使用Text组件，传入music的name属性
                          Text(
                            music.name,
                            // 设置文字样式，字体大小为16，加粗
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  Shadow(
                                    color: mainTheme.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                                color: mainTheme),
                          ),

                          // 显示歌手，使用Text组件，传入music的singer属性
                          Text(
                            music.singer,
                            // 设置文字样式，字体大小为14，颜色为灰色
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      // 显示播放按钮，使用IconButton组件，传入一个图标和一个点击事件
                      IconButton(
                        icon: Icon(playerState == PlayerState.playing
                            ? Icons.pause
                            : Icons.play_arrow),
                        iconSize: 40,
                        onPressed: play,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.17,
                        ),
                        Expanded(
                          child: Slider(
                            value: position.inSeconds.toDouble(),
                            max: duration.inSeconds.toDouble(),
                            min: 0,
                            onChanged: (value) {
                              setState(() {
                                audioPlayer
                                    .seek(Duration(seconds: value.toInt()));
                              });
                            },
                            activeColor: mainTheme,
                            inactiveColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // 定义一个播放音频的方法
  Future<void> play() async {
    // 如果音频已经在播放，就暂停
    if (playerState == PlayerState.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(GlobalMusic.globalSource);
    }
  }
}
