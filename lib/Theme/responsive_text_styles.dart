import 'package:flutter/material.dart';

class ResponsiveTextStyles {
  static TextStyle miniLabel(BuildContext context, [Color? newColor]) {
    final width = MediaQuery.of(context).size.width;
    if(newColor == null){
      return TextStyle(
      fontSize: width * 0.035, // 3% della larghezza dello schermo
      color: Colors.grey.shade400, // Colore grigio
    );
    }
    else{
      return TextStyle(
      fontSize: width * 0.035,
      color: newColor,
    );
    }
  }

  static TextStyle labelSmall(BuildContext context, [Color? newColor]) {
    final width = MediaQuery.of(context).size.width;
    if(newColor == null){
      return TextStyle(
      fontSize: width * 0.04,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor == Colors.white ? Colors.black : Colors.white,
    );
    }
    else{
      return TextStyle(
      fontSize: width * 0.04,
      fontWeight: FontWeight.bold,
      color: newColor,
    );
    }
    
  }

  static TextStyle labelMedium(BuildContext context, [Color? newColor]) {
    final width = MediaQuery.of(context).size.width;
    if(newColor == null){
      return TextStyle(
      fontSize: width * 0.05,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor == Colors.white ? Colors.black : Colors.white,
    );
    }
    else{
      return TextStyle(
      fontSize: width * 0.05,
      fontWeight: FontWeight.bold,
      color: newColor,
    );
    }
    
  }

  static TextStyle labelLarge(BuildContext context, [Color? newColor]) {
    final width = MediaQuery.of(context).size.width;
    if(newColor == null){
      return TextStyle(
      fontSize: width * 0.07,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor == Colors.white ? Colors.black : Colors.white,
    );
    }
    else{
      return TextStyle(
      fontSize: width * 0.07,
      fontWeight: FontWeight.bold,
      color: newColor,
    );
    }
    
  }

  static TextStyle headlineLarge(BuildContext context, [Color? newColor]) {
    final width = MediaQuery.of(context).size.width;
    if(newColor == null){
      return TextStyle(
      fontSize: width * 0.08,
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent, // Colore bianco
    );
    }
    else{
      return TextStyle(
      fontSize: width * 0.08,
      fontWeight: FontWeight.bold,
      color: newColor,
    );
    }
  }

}
