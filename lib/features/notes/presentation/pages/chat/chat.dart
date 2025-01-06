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
    setState(() {
      // this code adds the sender's message to the message list
      messages = [chatMessage, ...messages];
    });
    try {
      // question from our user
      String question = chatMessage.text;
      // give the question to gemini
      gemini.streamGenerateContent(question).listen((event) {
        // take the first message or nothing from the list of messages and give it to the last message
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          // if the last message is from Gemini
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";

          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          // if the last message is from the user
          // response from Gemini below
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          // create a new message below
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
