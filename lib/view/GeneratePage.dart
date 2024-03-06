// 导入flutter库
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_therapy/model/Music.dart';

import '../model/GlobalMusic.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({Key? key}) : super(key: key);

  @override
  _GeneratePageState createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  // 定义一个全局的表单键，用于验证表单

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
    // 监听音频播放器的状态变化
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
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

// 定义一个方法，用于显示评分对话框
  void _showRatingDialog() {
    // 调用 showDialog 方法，传入一个 AlertDialog 组件
    showDialog(
      context: context,
      barrierDismissible: true, // 设置点击外部是否关闭对话框
      builder: (context) {
        return AlertDialog(
          // 设置对话框的标题
          title: const Text('评价生成结果'),
          // 设置对话框的内容为一个评分的组件，传入一个回调函数
          content: RatingWidget(
            onRatingChanged: (value) {
              Navigator.of(context).pop();
            },
          ),
          // 设置对话框的操作按钮
          actions: [
            // 添加一个文本按钮，用于关闭对话框
            TextButton(
              child: const Text('关闭'),
              onPressed: () {
                // 关闭对话框
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 定义一个播放音频的方法
  Future<void> play() async {
    // 如果音频已经在播放，就暂停
    if (playerState == PlayerState.playing) {
      await audioPlayer.pause();
      _showRatingDialog();
    } else {
      // 否则就播放
      await audioPlayer.play(source);
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

  // 提交
  void _submit() {
    // 验证表单
    showDialog(
      context: context,
      barrierDismissible: true, // 点击外部不关闭对话框
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              // 一个圆形的进度指示器
              CircularProgressIndicator(),
              // 一个水平间隔
              SizedBox(width: 10),
              // 一个文本提示
              Text('加载中...'),
            ],
          ),
        );
      },
    );
    // Use Future.delayed to wait for 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      GlobalMusic.music = Music.generatedMusicExample;
      // After 5 seconds, close the dialog
      Navigator.of(context).pop(); // This line dismisses the dialog
    });
  }

  // 重写build方法，返回一个表单页面的组件
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        // 设置表单键         // 设置表单的子组件为一个水平布局的组件
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              // 设置水平布局的子组件为两端对齐
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // 设置水平布局的子组件列表
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "音乐生成疗愈",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.deepOrange.shade800,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
                Row(
                  children: [
                    const SizedBox(height: 170),
                    // 添加一个图标
                    const Icon(
                      Icons.lightbulb,
                      size: 48.0,
                      color: Colors.yellow,
                    ),
                    // 添加一个外边距组件，用于增加空间
                    const SizedBox(width: 10),
                    // 添加一个文本提示词
                    const Text(
                      '提示词',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    // 添加一个外边距组件，用于增加空间
                    const SizedBox(width: 10),
                    // 添加一个文本字段，用于输入内容
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: '一首表现清晨阳光的希望与温暖的音乐',
                          border: OutlineInputBorder(),
                        ),
                        // 设置文本字段的最大行数为3
                        maxLines: 3,
                        // 设置文本字段的验证器，用于检查输入是否为空
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入内容';
                          }
                          return null;
                        },
                      ),
                    ),
                    // 添加一个外边距组件，用于增加空间
                    const SizedBox(width: 10),
                  ],
                ),

                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "生成一段音乐需要对应的",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "提示词",
                              style: TextStyle(
                                color: Colors.yellow.shade700,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "你也可以点击",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "获取提示词",
                              style: TextStyle(
                                color: Colors.deepOrange.shade400,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "，与疗愈助手对话获取提示词",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(
                  height: 3,
                ),

                // 添加一个垂直布局的组件，用于放置按钮
                Row(
                  // 设置垂直布局的子组件为居中对齐
                  mainAxisAlignment: MainAxisAlignment.center,
                  // 设置垂直布局的子组件列表
                  children: [
                    ElevatedButton(
                      // 设置按钮的文本为获取提示词
                      child: Text(
                        '获取提示词',
                        style: TextStyle(
                          color: Colors.deepOrange.shade400,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 设置按钮的点击事件为调用获取提示词的方法
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              const GeneratePage(), // 将数据传递给下一个页面，使用_musicSheetList中的元素
                        ));
                      },
                    ),
                    const SizedBox(width: 50),
                    // 添加一个按钮组件，用于提交表单
                    ElevatedButton(
                      // 设置按钮的文本为提交
                      onPressed: _submit,
                      // 设置按钮的文本为提交
                      child: Text(
                        '生成音乐',
                        style: TextStyle(
                          color: Colors.deepOrange.shade400,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // 添加一个垂直间隔组件，用于增加空间
                    // 添加一个按钮组件，用于获取提示词
                  ],
                ),
                // 添加一个外边距组件，用于增加空间
                const Divider(
                  color: Colors.grey,
                  thickness: 2.0,
                  indent: 10.0,
                  endIndent: 10.0,
                ),
                // 添加一个外边距组件，用于增加空间
                const SizedBox(height: 10),
                const Text(
                  "—— 生成结果 ——",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // 添加一个进度条
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
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
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(playerState == PlayerState.playing
                      ? Icons.pause
                      : Icons.play_arrow),
                  iconSize: 40,
                  onPressed: play,
                ),
                // 显示歌曲播放进度和总时长
                Text(
                  '${formatDuration(position)} / ${formatDuration(duration)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 定义一个评分的组件，继承自 StatefulWidget
class RatingWidget extends StatefulWidget {

  final Function(int) onRatingChanged;

  const RatingWidget({super.key, required this.onRatingChanged});

  @override
  RatingWidgetState createState() => RatingWidgetState();
}


class RatingWidgetState extends State<RatingWidget> {

  int rating = 0;

  List<Icon> stars = [
    const Icon(Icons.star_border),
    const Icon(Icons.star_border),
    const Icon(Icons.star_border),
    const Icon(Icons.star_border),
    const Icon(Icons.star_border),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(5, (index) {

        return GestureDetector(

          child: stars[index],

          onTap: () {

            setState(() {

              rating = index + 1;

              for (int i = 0; i < 5; i++) {
                if (i < rating) {

                  stars[i] = const Icon(Icons.star, color: Colors.yellow);
                } else {

                  stars[i] = const Icon(Icons.star_border);
                }
              }

              widget.onRatingChanged(rating);
            });
          },
        );
      }),
    );
  }
}
