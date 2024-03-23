import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/model/dialog_provider.dart';
import 'package:music_therapy/main/model/message.dart';
import 'package:music_therapy/main/model/user_data.dart';
import 'package:music_therapy/main/service/chat_service.dart';
import 'package:provider/provider.dart';

// 定义一个最近播放页面的组件，继承自 StatefulWidget
class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<Message> messages = [
    Message(
      sender: 'Assistant',
      text: '您好！\n我是音乐疗愈助手，我会引导您通过音乐治疗自己。',
      isCurrentUser: false,
    )
  ];

  final bool _isFirstMessage = true;

  void _sendMessage(Message message) async {
    setState(() {
      messages.add(message);
      _listKey.currentState!.insertItem(messages.length - 1);
      _textController.clear();
    });
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollDown();
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void awaitServerResponse(String text) async {
    Message response =
        await ChatService.sendMessage(UserData.userId, text, _isFirstMessage);
    _sendMessage(response);
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollDown();
  }

  @override
  void initState() {
    super.initState();
    initializeMessages();
    _focusNode.addListener(() async {
      if (_focusNode.hasFocus) {
        await Future.delayed(const Duration(milliseconds: 600));
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void initializeMessages() async {
    await Future.delayed(const Duration(milliseconds: 700));
    Message messageStarter = Message(
      sender: 'Assistant',
      text: '请问您现在的心情用以下哪一点描述比较合适？\n 1. 欢快 \n 2. 平静 \n 3. 悲郁 \n 4. 其它，请言明',
      isCurrentUser: false,
    );
    _sendMessage(messageStarter);
  }

  // 定义一个方法，用于构建页面的界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              controller: _scrollController,
              initialItemCount: messages.length,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0,
                      end: 1,
                    ).animate(animation),
                    child: ChatBubble(
                      message: messages[index],
                      isValid: index % 2 == 1 && index >= 5,
                    ),
                  ),
                );
              },
            ),
          ),
          TextField(
            focusNode: _focusNode,
            controller: _textController,
            enabled: !messages.last
                .isCurrentUser, // If the user is completing the input, await the server's response.
            decoration: InputDecoration(
              hintText: '输入...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: messages.last.isCurrentUser
                  ? const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send_rounded),
                      onPressed: () {
                        if (_textController.text.isNotEmpty) {
                          final message = Message(
                            sender: 'You', // Or get the user's name
                            text: _textController.text,
                            isCurrentUser: true,
                          );
                          _sendMessage(message);
                          _textController.clear();
                          awaitServerResponse(_textController.text);
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// A widget to display a chat bubble
class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isValid;

  const ChatBubble({Key? key, required this.message, this.isValid = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the alignment and color of the chat bubble
    Alignment alignment =
        message.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    Color color =
        message.isCurrentUser ? Colors.grey[200]! : mainTheme.withOpacity(0.7);

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.text.isNotEmpty)
                  Text(
                    message.text,
                    style: TextStyle(
                        color:
                            message.isCurrentUser ? Colors.black : Colors.white,
                        shadows: [
                          Shadow(
                            color: message.isCurrentUser
                                ? Colors.white
                                : Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ]),
                  ),
                if (isValid)
                  Column(
                    children: [
                      const Divider(),
                      Text(
                        "—— 根据这一段描述生成/推荐 ——",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            shadows: [
                              Shadow(
                                color: message.isCurrentUser
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.3),
                                blurRadius: 2,
                              )
                            ]),
                      ),
                      Consumer<DialogProvider>(
                        builder: (context, provider, child) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  _buttonClicked(context, provider, 1);
                                },
                                child: const Text("推荐",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ))),
                            ElevatedButton(
                                onPressed: (){
                                  _buttonClicked(context, provider, 2);
                                },
                                child: const Text("生成",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ))),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _buttonClicked(BuildContext c, DialogProvider p, int submit) async {
    Navigator.of(c).pop();
    p.submit(submit);
  }
}
