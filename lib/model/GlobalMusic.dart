import 'package:audioplayers/audioplayers.dart';

import 'Music.dart';


class GlobalMusic{


  static AudioPlayer globalAudioPlayer = AudioPlayer();

  static PlayerState globalPlayerState = PlayerState.stopped;

  static Music music=Music(
      "1",
      'Shape of You', // 歌曲名称
      'Ed Sheeran', // 歌手
      233, // 时长，单位秒
      'https://picsum.photos/id/100/200/200', // 图片
      "audio/test.mp3", // 文件
      true,
      {});

  static Source globalSource=AssetSource('audio/test.mp3');

  static Duration globalPosition = Duration.zero;
  // 创建一个音频总时长变量
  static Duration globalDuration = Duration.zero;

}