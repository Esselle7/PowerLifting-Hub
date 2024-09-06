import 'dart:convert';
import 'dart:io';
import 'package:gym/Home/home_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:gym/Theme/dark_theme.dart';
import 'package:gym/Theme/light_teme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:gym/wellcome_page.dart';
import 'package:dart_ping/dart_ping.dart';
void main() {
  /*final ping = Ping('http://192.168.1.17:8080', count: 5);
  ping.stream.listen((event) {
    print(event);
  });*/
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProfile(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym',
      theme: lightTheme, 
      darkTheme: darkTheme, 
      themeMode: ThemeMode.system,
      home: WelcomePage(),
      //home: HomePage(),
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






