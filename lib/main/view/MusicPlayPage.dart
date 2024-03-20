// 引入flutter相关的库
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_therapy/main/component/Disc.dart';
import 'package:music_therapy/main/model/controller_provider.dart';

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

  // 定义一个构建界面的方法
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('歌曲详情'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 显示歌曲图片
            Hero(
              tag: "player",
              child: Disc(
                scaleFactor: 3,
                controller: globalController!
              ),
            ),
            // 显示歌曲名称和歌手
            Text(
              '${music.name} - ${music.singer}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // 显示歌曲时长
            Text(
              '时长：${formatDuration(Duration(seconds: music.duration))}',
              style: const TextStyle(fontSize: 16),
            ),
            // 显示歌曲播放时间
            // 显示歌曲播放进度条
            Slider(
              value: position.inSeconds.toDouble(),
              min: 0,
              max: duration.inSeconds.toDouble(),
              onChanged: (value) {
                // 拖动进度条时，跳转到相应的位置
                audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
            // 显示歌曲播放进度和总时长
            Text(
              '${formatDuration(position)} / ${formatDuration(duration)}',
              style: const TextStyle(fontSize: 16),
            ),
            // 显示歌曲播放按钮
            IconButton(
              icon: Icon(playerState == PlayerState.playing
                  ? Icons.pause
                  : Icons.play_arrow),
              iconSize: 64,
              onPressed: play,
            ),
          ],
        ),
      ),
    );
  }
}
