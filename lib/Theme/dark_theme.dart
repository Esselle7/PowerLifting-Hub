import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData.light().copyWith(
  primaryColor:  Colors.black, // Colore principale della tua app
  scaffoldBackgroundColor:  Colors.black, // Colore di sfondo della Scaffold
  mainColor: Colors.blueAccent,
  /*appBarTheme: AppBarTheme(
    backgroundColor:  Colors.black,
    foregroundColor:  Colors.blueAccent,
    titleTextStyle: TextStyle(
    fontWeight: FontWeight.bold, // Imposta il testo in grassetto
    color: Colors.blueAccent, // Colore del testo, se necessario
    fontSize: 25, // Dimensione del testo, se necessario
    ),
  ),*/
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
    ),
    headline2: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color:  Colors.blueAccent,
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
