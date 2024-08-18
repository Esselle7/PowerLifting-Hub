import 'dart:convert';
import 'dart:io';

import 'package:gym/Home/home_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:gym/Theme/dark_theme.dart';
import 'package:gym/Theme/light_teme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:gym/wellcome_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProfile(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym',
      theme: lightTheme, // Tema chiaro
      darkTheme: darkTheme, // Tema scuro
      themeMode: ThemeMode.system, // Usa il tema del sistema
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


