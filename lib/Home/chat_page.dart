import 'package:flutter/material.dart';
import 'package:gym/Services/homeAppBar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  HomeAppBar(title: "Chat"),
      body: const Center(
        child: Text(
          'Chat Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
