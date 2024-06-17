import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym/athlete_profile_world_page.dart';
import 'package:gym/login_page.dart';
import 'crew_page.dart';
import 'search_page.dart';
import 'chatbot_page.dart';
import 'profile_page.dart';
import 'chat_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Brainstorming',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
       
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static List<Widget> _pages = <Widget>[
    CrewPage(),
    SearchPage(),
    ChatbotPage(),
    ProfilePage(),
    ChatPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Crew',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}



Future<File> get _localFile async {
  const path = '/storage/emulated/0/Download';
  return File('$path/athlete_profile.json');
}

Future<File> writeProfile(Map<String, dynamic> profile) async {
  final file = await _localFile;
  return file.writeAsString(json.encode(profile));
}
