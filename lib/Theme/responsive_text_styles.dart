import 'package:flutter/material.dart';

class ResponsiveTextStyles {
  static TextStyle labelSmall(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: width * 0.035, // 3% della larghezza dello schermo
      color: Colors.grey.shade400, // Colore grigio
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: width * 0.05,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor == Colors.white ? Colors.black : Colors.white, // Colore grigio
    );
  }

  static TextStyle labelLarge(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: width * 0.07, // 5% della larghezza dello schermo
      color: Theme.of(context).primaryColor == Colors.white ? Colors.black : Colors.white, // Colore bianco
    );
  }
}
