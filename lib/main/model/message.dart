// A class to represent a message
class Message {
  final String sender;
  final String text;
  final bool isCurrentUser;

  Message({
    this.sender = "Assistant",
    required this.text,
    this.isCurrentUser = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: "Assistant",
      text: json['data'],
      isCurrentUser: false,
    );
  }
}
