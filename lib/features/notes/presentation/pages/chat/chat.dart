import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class chatpage extends StatefulWidget {
  const chatpage({super.key});
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
    messages = [
      chatMessage,
      ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "Typing...",
      ),
      ...messages,
    ];
  });

  try {
    String question = chatMessage.text;

    gemini.streamGenerateContent(question,
      modelName: 'gemini-2.0-flash',
    ).listen((event) {
      messages.removeWhere((msg) => msg.text == "Typing...");

      String response = event.content?.parts
    ?.whereType<TextPart>() // ✅ Filter only TextPart objects
    .map((part) => part.text) // ✅ Now safely access 'text'
    .join(" ") ?? "Sorry, I couldn't generate a response.";

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
