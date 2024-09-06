import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData.light().copyWith(
  primaryColor:  Colors.black, // Colore principale della tua app
  scaffoldBackgroundColor:  Colors.black, // Colore di sfondo della Scaffold
  mainColor: Colors.blueAccent,
  oppositeColor: Colors.white,


  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 5,
      shadowColor: Colors.black45,
    ),
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent,
    ),
    headline2: TextStyle(
      fontWeight: FontWeight.bold,
      color:  Colors.blueAccent,
    ),
    innerbox: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent,
    ),

    ),
    
/*
                 */
  // Altri elementi personalizzati
);
