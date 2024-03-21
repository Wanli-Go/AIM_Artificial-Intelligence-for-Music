// 引入flutter相关的库
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/component/Disc.dart';
import 'package:music_therapy/main/model/controller_provider.dart';
import 'package:palette_generator/palette_generator.dart';

import '../model/GlobalMusic.dart';
import '../model/Music.dart';

// 定义一个歌曲详情界面的组件
class MusicPlayPage extends StatefulWidget {
  // 接收一个Music对象作为参数

  const MusicPlayPage({super.key});

  @override
  _MusicPlayPageState createState() => _MusicPlayPageState();
}

class _MusicPlayPageState extends State<MusicPlayPage> {
  Music music = GlobalMusic.music;
  AudioPlayer audioPlayer = GlobalMusic.globalAudioPlayer;
  // 创建一个音频播放状态变量
  PlayerState playerState = GlobalMusic.globalPlayerState;
  // 创建一个音频播放进度变量
  Duration position = GlobalMusic.globalPosition;
  // 创建一个音频总时长变量
  Duration duration = GlobalMusic.globalDuration;

  PaletteGenerator? paletteGenerator;

  Future<void> _updatePaletteGenerator() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(music.image),
      maximumColorCount: 2,
    );
    setState(() {});
  }

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
      // FIXME: alternate to duration changed
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
        _updatePaletteGenerator();
      }
    });

    _updatePaletteGenerator();
  }

  // 定义一个播放音频的方法
  Future<void> play() async {
    // 如果音频已经在播放，就暂停
    if (playerState == PlayerState.playing) {
      await audioPlayer.pause();
      stopsAnimation();
    } else {
      await audioPlayer.play(GlobalMusic.globalSource);
      startAnimation();
    }
  }

  // 定义一个格式化时间的方法
  String formatDuration(Duration d) {
    // 将秒数转换为分:秒的形式
    return d.toString().split('.').first.padLeft(8, "0");
  }

  // 重写 dispose 方法
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          '歌曲详情',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: (paletteGenerator != null)
            ? paletteGenerator!.dominantColor?.color ?? appBarTheme
            : appBarTheme,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0, -0.93),
            end: Alignment.bottomCenter,
            colors: (paletteGenerator != null)
                ? [
                    paletteGenerator!.dominantColor?.color ?? appBarTheme,
                    paletteGenerator!.lightVibrantColor?.color ??
                        mainTheme.withOpacity(0.3)
                  ]
                : [appBarTheme, mainTheme.withOpacity(0.3)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 显示歌曲图片
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white
                          .withOpacity(0.5), // Adjust opacity as needed
                      blurRadius: 15.0,
                      spreadRadius: 8.0,
                      offset: Offset(0, 1), // Offset for shadow direction
                    ),
                  ],
                ),
                child: Hero(
                  tag: "player",
                  child: Disc(
                    scaleFactor: 3,
                    controller: globalController!,
                  ),
                ),
              ),
            ),
            // 显示歌曲名称和歌手
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '${music.name} - ${music.singer}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // 显示歌曲时长
            Text(
              '时长：${formatDuration(Duration(seconds: music.duration))}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 24),
            // 显示歌曲播放进度条
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SliderTheme(
                data: const SliderThemeData(
                  trackHeight: 4,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white54,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white30,
                ),
                child: Slider(
                  value: position.inSeconds.toDouble(),
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    // 拖动进度条时，跳转到相应的位置
                    audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),
            // 显示歌曲播放进度和总时长
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(position),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    formatDuration(duration),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // 显示歌曲播放按钮
            FloatingActionButton(
              onPressed: play,
              backgroundColor: Colors.white,
              child: Icon(
                playerState == PlayerState.playing
                    ? Icons.pause
                    : Icons.play_arrow,
                color: mainTheme,
                size: 32,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
