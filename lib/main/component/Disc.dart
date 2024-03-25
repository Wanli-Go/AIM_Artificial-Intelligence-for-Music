import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_therapy/main/model/GlobalMusic.dart';
import 'package:music_therapy/main/model/Music.dart';
import 'dart:math' as math;
import 'package:percent_indicator/circular_percent_indicator.dart';

class Disc extends StatefulWidget {
  final double scaleFactor;
  final AnimationController controller;
  const Disc({super.key, required this.scaleFactor, required this.controller});

  @override
  State<Disc> createState() => _DiscState();
}

class _DiscState extends State<Disc> with SingleTickerProviderStateMixin {
  Music music = GlobalMusic.music;
  AudioPlayer audioPlayer = GlobalMusic.globalAudioPlayer;
  // 创建一个音频播放状态变量
  PlayerState playerState = GlobalMusic.globalPlayerState;
  // 创建一个音频播放进度变量
  Duration position = GlobalMusic.globalPosition;
  // 创建一个音频总时长变量
  Duration duration = GlobalMusic.globalDuration;

  Source source = GlobalMusic.globalSource;

  @override
  void initState() {
    super.initState();
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

  double getAngle() {
    var value = widget.controller.value;
    return value * 2 * math.pi;
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 50.0 * widget.scaleFactor,
      percent: position.inMilliseconds / duration.inMilliseconds,
      progressColor: const Color.fromARGB(159, 255, 89, 0),
      center: Transform.rotate(
        angle: getAngle(),
        child: CircleAvatar(
          radius: 22 * widget.scaleFactor,
          // 使用网络图片，传入music的image属性
          backgroundImage: (music.image == ""
                        ? AssetImage("assets/image/logo.png")
                        : NetworkImage(music.image)) as ImageProvider,
        ),
      ),
    );
  }
}
