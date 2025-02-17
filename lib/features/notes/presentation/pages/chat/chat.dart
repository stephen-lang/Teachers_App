import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class chatpage extends StatefulWidget {
  chatpage({super.key});
  static String routeName = '/chatpage';
  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = <ChatMessage>[];

  ChatUser Currenuser = ChatUser(
    id: '0',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );

  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: "assets/images/chatbot.PNG",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat"),
      ),
      body: buildUi(),
    );
  }

  Widget buildUi() {
    return DashChat(
      currentUser: Currenuser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

 void _sendMessage(ChatMessage chatMessage) {
  if (chatMessage.text.trim().isEmpty) return;

  setState(() {
    // Add the sender's message to the message list
    messages = [
      ChatMessage(
        user: chatMessage.user,
        createdAt: chatMessage.createdAt,
        text: chatMessage.text,
      ),
      ...messages,
      ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "Typing...",
      ),
    ];
  });

  try {
    String question = chatMessage.text;

    gemini.streamGenerateContent(question).listen((event) {
      // Remove "Typing..." indicator
      messages.removeWhere((msg) => msg.text == "Typing...");

      String response = event.content?.parts?.fold(
              "", (previous, current) => "$previous ${current.text}") ??
          "";

      ChatMessage message = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: response,
      );

      setState(() {
        messages = [message, ...messages];
      });
    });
  } catch (e) {
    print(e);
    setState(() {
      messages = [
        ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: "Sorry, something went wrong. Please try again later.",
        ),
        ...messages,
      ];
    });
  }
}

}
