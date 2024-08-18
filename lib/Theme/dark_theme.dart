import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData.light().copyWith(
  primaryColor:  Colors.black, // Colore principale della tua app
  scaffoldBackgroundColor:  Colors.black, // Colore di sfondo della Scaffold
  mainColor: Colors.blueAccent,
  appBarTheme: AppBarTheme(
    backgroundColor:  Colors.black, // Colore di sfondo della AppBar
    foregroundColor: Colors.blueAccent, // Colore del testo della AppBar
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 5,
      shadowColor: Colors.black45,
    ),
  ),
  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent,
      shadows: [
        Shadow(
          offset: Offset(2, 2),
          blurRadius: 4,
          color: Colors.black45,
        ),
      ],
    ),
    innerbox: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent,
      
    ),
    ),
    
/*
                 */
  // Altri elementi personalizzati
);
