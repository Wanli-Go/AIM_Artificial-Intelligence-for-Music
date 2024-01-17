// 导入flutter库
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
      setState(() {
        playerState = state;
      });
    });
    // 监听音频播放器的进度变化
    audioPlayer.onPositionChanged.listen((pos) {
      setState(() {
        position = pos;
      });
    });
    // 监听音频播放器的时长变化
    audioPlayer.onDurationChanged.listen((dur) {
      setState(() {
        duration = dur;
      });
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
    Future<void> future = showDialog(
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
  }

  // 重写build方法，返回一个表单页面的组件
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 设置表单键         // 设置表单的子组件为一个水平布局的组件
        child: Column(
          // 设置水平布局的子组件为两端对齐
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // 设置水平布局的子组件列表
          children: [
            const Text("音乐生成",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                )),
            Row(
              children: [
                const SizedBox(height: 200),
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
            const Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "生成一段音乐需要对应的提示词\n你也可以点击获取提示词与ai对话获取提示词",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            // 添加一个垂直布局的组件，用于放置按钮
            Row(
              // 设置垂直布局的子组件为居中对齐
              mainAxisAlignment: MainAxisAlignment.center,
              // 设置垂直布局的子组件列表
              children: [
                ElevatedButton(
                  // 设置按钮的文本为获取提示词
                  child: const Text(
                    '获取提示词',
                    style: TextStyle(
                      color: Colors.blue,
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
                  child: const Text(
                    '生成音乐',
                    style: TextStyle(
                      color: Colors.blue,
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
              "生成结果",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // 添加一个进度条
            Slider(
              value: position.inSeconds.toDouble(),
              min: 0,
              max: duration.inSeconds.toDouble(),
              onChanged: (value) {
                // 拖动进度条时，跳转到相应的位置
                audioPlayer.seek(Duration(seconds: value.toInt()));
              },
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
    );
  }
}

// 定义一个评分的组件，继承自 StatefulWidget
class RatingWidget extends StatefulWidget {
  // 定义一个回调函数，用于返回评分的值
  final Function(int) onRatingChanged;
  // 定义一个构造函数，接收回调函数作为参数
  const RatingWidget({super.key, required this.onRatingChanged});
  // 重写 createState 方法，返回一个 RatingWidgetState 对象
  @override
  RatingWidgetState createState() => RatingWidgetState();
}

// 定义一个评分的组件的状态类，继承自 State<RatingWidget>
class RatingWidgetState extends State<RatingWidget> {
  // 定义一个整数变量，用于存储评分的值
  int rating = 0;
  // 定义一个列表，用于存储五个星星的图标
  List<Icon> stars = [
    const Icon(Icons.star_border),
    const Icon(Icons.star_border),
    const Icon(Icons.star_border),
    const Icon(Icons.star_border),
    const Icon(Icons.star_border),
  ];
  // 重写 build 方法，返回一个水平布局的组件
  @override
  Widget build(BuildContext context) {
    return Row(
      // 设置水平布局的主轴对齐方式为居中对齐
      mainAxisAlignment: MainAxisAlignment.center,
      // 设置水平布局的子组件为一个循环生成的列表
      children: List.generate(5, (index) {
        // 返回一个手势检测的组件，用于处理点击事件
        return GestureDetector(
          // 设置手势检测的子组件为列表中对应的星星图标
          child: stars[index],
          // 设置手势检测的点击事件的回调函数
          onTap: () {
            // 调用 setState 方法，更新组件的状态
            setState(() {
              // 根据点击的索引，更新评分的值
              rating = index + 1;
              // 根据评分的值，更新星星的图标
              for (int i = 0; i < 5; i++) {
                if (i < rating) {
                  // 如果小于评分的值，设置为实心的星星
                  stars[i] = const Icon(Icons.star, color: Colors.yellow);
                } else {
                  // 如果大于等于评分的值，设置为空心的星星
                  stars[i] = const Icon(Icons.star_border);
                }
              }
              // 调用父组件传入的回调函数，传递评分的值
              widget.onRatingChanged(rating);
            });
          },
        );
      }),
    );
  }
}
