import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor:  Colors.white, 
  scaffoldBackgroundColor:  Colors.white,
  mainColor: Colors.blueAccent,
  oppositeColor: Colors.black,

  
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
      color:  Colors.blueAccent,
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
  // Altri elementi personalizzati
);
