import 'package:flutter/material.dart';
// import 'package:audio_manager/audio_manager.dart'; // 引入音频管理器的包

class MusicGeneratorPage extends StatefulWidget {
  const MusicGeneratorPage({Key? key}) : super(key: key);

  @override
  _MusicGeneratorPageState createState() => _MusicGeneratorPageState();
}

class _MusicGeneratorPageState extends State<MusicGeneratorPage> {
  // 定义一个文本控制器，用于获取输入框的内容
  final TextEditingController _textController = TextEditingController();
  // 定义一个音频管理器的实例
  // var _audioManagerInstance = AudioManager.instance;
  // 定义一个音频的URL，用于播放生成的音乐
  final String _audioUrl = '';

  // 定义一个生成音乐的方法，接收一个描述作为参数
  void _generateMusic(String description) async {
    // 调用一个自定义的内部工具，传入描述，返回一个音频的URL
    // String url = await generate_music(description);
    // // 将URL赋值给_audioUrl变量
    // setState(() {
    //   _audioUrl = url;
    // });
    // // 调用音频管理器的start方法，传入URL，开始播放音乐
    // _audioManagerInstance.start(_audioUrl, 'Generated Music');
  }

  // 定义一个构建界面的方法，返回一个Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _textController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  // 设置decoration为一个InputDecoration对象，设置一些边框，背景色，提示文本等属性
                  decoration: const InputDecoration(
                    hintText: '请输入推荐音乐的描述',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
            ),
            // 使用SizedBox添加一些垂直间距
            const SizedBox(
              height: 10.0,
            ),
            // 使用Align包裹ElevatedButton，设置alignment为Alignment.bottomRight
            Align(
              alignment: Alignment.bottomRight,
              // 显示一个提交按钮，用于生成音乐
              child: ElevatedButton(
                onPressed: () {
                  // 调用_generateMusic方法，传入输入框的内容
                  _generateMusic(_textController.text);
                },
                child: const Text('推荐音乐'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
