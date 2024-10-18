import 'package:flutter/material.dart';

class ResponsiveButtonStyle {
  // Metodo per creare uno stile per i bottoni piccoli
  static ElevatedButton smallButton({
    required BuildContext context,
    required String buttonText,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:  Theme.of(context).primaryColor,
        side: BorderSide(color: Colors.blueAccent, width: screenWidth * 0.005),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: MediaQuery.of(context).size.height * 0.015,
        ),
      ),
      child: icon == null
          ? Text(
              buttonText,
              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.blueAccent),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.blueAccent, size: screenWidth * 0.04),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  buttonText,
                  style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.blueAccent),
                ),
              ],
            ),
    );
  }

  // Metodo per creare uno stile per i bottoni medi
  static ElevatedButton mediumButton({
    required BuildContext context,
    required String buttonText,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        side: BorderSide(color: Colors.blueAccent, width: screenWidth * 0.005),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
      ),
      child: icon == null
          ? Text(
              buttonText,
              style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.blueAccent),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.blueAccent, size: screenWidth * 0.05),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  buttonText,
                  style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.blueAccent),
                ),
              ],
            ),
    );
  }

  // Metodo per creare uno stile per i bottoni grandi
  static ElevatedButton largeButton({
    required BuildContext context,
    required String buttonText,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:  Theme.of(context).primaryColor,
        side: BorderSide(color: Colors.blueAccent, width: screenWidth * 0.007),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: MediaQuery.of(context).size.height * 0.025,
        ),
      ),
      child: icon == null
          ? Text(
              buttonText,
              style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.blueAccent),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.blueAccent, size: screenWidth * 0.06),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  buttonText,
                  style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.blueAccent),
                ),
              ],
            ),
    );
  }
}
