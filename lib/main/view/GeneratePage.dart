// 导入flutter库
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/component/GenericMusicList.dart';
import 'package:music_therapy/main/model/Music.dart';
import 'package:music_therapy/main/model/user_data.dart';
import 'package:music_therapy/main/service/MusicService.dart';

class GeneratePage extends StatefulWidget {
  bool reloaded;
  final List<Music> generatedMusicList = [];
  GeneratePage({Key? key, this.reloaded = true}) : super(key: key);

  @override
  _GeneratePageState createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  final MusicService _service = MusicService();
  final TextEditingController _controller = TextEditingController();

  Future<bool> _requestMusicList(String description) async {
    if (widget.generatedMusicList.isEmpty || widget.reloaded) {
      await _service.getGenerated(UserData.userId, description).then((value) {
        setState(() {
          widget.generatedMusicList.add(value);
          widget.reloaded = false;
        });
      });
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    if(widget.reloaded){
      widget.generatedMusicList.clear();
    }
    if( UserData.tokens.isNotEmpty )_controller.text = UserData.tokens;
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
  void _submit() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('请输入提示词！'), // Incorporate error code
        backgroundColor: mainTheme, // Set a color for error
      ));
      return;
    }
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
              Text('生成中，请稍后...'),
            ],
          ),
        );
      },
    );
    await _requestMusicList(_controller.text);
    Navigator.of(context).pop();
    setState(() {
      
    });
  }

  // 重写build方法，返回一个表单页面的组件
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [mainTheme, Colors.purple[50]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // 设置水平布局的子组件列表
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "音乐生成疗愈",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              blurRadius: 10,
                              color: Colors.deepOrange.shade800,
                              offset: Offset(0, 3))
                        ],
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: mainTheme,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white70,
                            spreadRadius: 1,
                            blurRadius: 1.5,
                            offset:
                                Offset(0, 0.5), // changes position of shadow
                          )
                        ]),
                    width: 90,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.diamond_outlined,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text("VIP 独享")
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lightbulb,
                              size: 48.0,
                              color: Colors.yellowAccent,
                            ),
                            // 添加一个外边距组件，用于增加空间
                            SizedBox(width: 10),
                            // 添加一个文本提示词
                            Text(
                              '提示词',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5,
                                      color: Colors.amber,
                                      offset: Offset(0, 2),
                                    )
                                  ]),
                            ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.75,
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 8),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(
                                      0, 0.5), // changes position of shadow
                                )
                              ]),
                          child: TextFormField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: '例：一首表现清晨阳光的希望与温暖的音乐',
                              border: UnderlineInputBorder(),
                            ),
                            // 设置文本字段的最大行数为3
                            maxLines: 5,
                            // 设置文本字段的验证器，用于检查输入是否为空
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入内容';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  // 添加一个垂直布局的组件，用于放置按钮
                  Row(
                    // 设置垂直布局的子组件为居中对齐
                    mainAxisAlignment: MainAxisAlignment.center,
                    // 设置垂直布局的子组件列表
                    children: [
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
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2.0,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  // 添加一个外边距组件，用于增加空间
                  const SizedBox(height: 20),
                  const Text(
                    "—— 生成结果 ——",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.white24,
                          offset: Offset(0, 2),
                        )
                      ]
                    ),
                  ),
                  widget.generatedMusicList.isEmpty
                      ? Expanded(child: const Center(child: Text('请按下『生成音乐按钮』，根据提示词生成音乐\n点击右下角『疗愈助手』可以辅助获取提示词')))
                      : Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.grey,
                          )
                        ),
                        child: GenericMusicList(
                            list: widget.generatedMusicList,
                            heightPercentage: 0.21),
                      )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
