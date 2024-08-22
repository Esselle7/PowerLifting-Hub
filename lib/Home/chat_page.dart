import 'package:flutter/material.dart';
import 'package:gym/Services/homeAppBar.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  HomeAppBar(title: "Chat"),
      body: Center(
        child: Text(
          'Chat Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
