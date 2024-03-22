import 'package:flutter/material.dart';

// 定义一个最近播放页面的组件，继承自 StatefulWidget
class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  List<Message> messages = [
    Message(
      sender: 'Alice',
      text: 'Hi, Bob. How are you?',
      isCurrentUser: false,
    ),
    Message(
      sender: 'Bob',
      text: 'I\'m good, thanks. How about you?',
      isCurrentUser: true,
    ),
    Message(
      sender: 'Alice',
      text: 'I\'m fine too. Just a bit busy with work.',
      isCurrentUser: false,
    ),
    Message(
      sender: 'Bob',
      text: 'I see. What are you working on?',
      isCurrentUser: true,
    ),
    Message(
      sender: 'Alice',
      text:
          'I\'m writing a Flutter app for a client. It\'s a chat app with stories.',
      isCurrentUser: false,
    ),
    Message(
      sender: 'Bob',
      text: 'Wow, that sounds cool. Can you show me some screenshots?',
      isCurrentUser: true,
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
              hintText: 'Type a message',
              border: const OutlineInputBorder(),
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

// A class to represent a message
class Message {
  final String sender;
  final String text;
  final bool isCurrentUser;

  Message({
    required this.sender,
    this.text = '',
    required this.isCurrentUser,
  });
}

// A widget to display a chat bubble
class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the alignment and color of the chat bubble
    Alignment alignment =
        message.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    Color color = message.isCurrentUser ? Colors.blue : Colors.grey[300]!;

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
                          message.isCurrentUser ? Colors.white : Colors.black,
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
