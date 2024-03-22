import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:music_therapy/app_theme.dart';

// 定义一个最近播放页面的组件，继承自 StatefulWidget
class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  _DialogPageState createState() => _DialogPageState();
}

// A class to represent a message
class _Message {
  final String sender;
  final String text;
  final bool isCurrentUser;

  _Message({
    required this.sender,
    this.text = '',
    required this.isCurrentUser,
  });
}

class _DialogPageState extends State<DialogPage> {
  List<_Message> messages = [
    _Message(
      sender: 'Assistant',
      text: '您好！\n我是音乐疗愈助手，我会引导您通过音乐治疗自己。',
      isCurrentUser: false,
    ),
    _Message(
      sender: 'Assistant',
      text: '请问您现在的心情用以下哪一点描述比较合适？\n 1. 欢快 \n 2. 平静 \n 3. 悲郁 \n 4. 其它，请言明',
      isCurrentUser: false,
    ),
  ];

  int index = 1;

  // 定义一个方法，用于构建页面的界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              index = (index + 1) % 2;
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: messages[index],
                );
              },
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: '输入...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // TODO: Implement sending messages
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
  final _Message message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the alignment and color of the chat bubble
    Alignment alignment =
        message.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    Color color = message.isCurrentUser ? Colors.grey[200]! : mainTheme.withOpacity(0.7);

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
                // Show the sender name if the message is not from the current user

                // Show the message text if any
                if (message.text.isNotEmpty)
                  Text(
                    message.text,
                    style: TextStyle(
                      color:
                          message.isCurrentUser ? Colors.black : Colors.white,
                          shadows: [Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          )]
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
