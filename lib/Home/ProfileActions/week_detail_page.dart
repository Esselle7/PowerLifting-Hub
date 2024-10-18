import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym/Services/standardAppBar.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:http/http.dart' as http;

class WeekDetailPage extends StatelessWidget {
  final Map<String, dynamic> weekData;
  final int currentWeek;

  const WeekDetailPage({super.key, required this.weekData, required this.currentWeek});

  @override
  Widget build(BuildContext context) {
    // Ottieni le dimensioni dello schermo
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: StandardAppBar(title: 'Dettagli ${weekData['week']}'),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        children: [
          ...(weekData['sessions'] as List<dynamic>).map<Widget>((session) {
            return Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session['day'],
                    style: ResponsiveTextStyles.headlineLarge(context),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  SizedBox(
                    height: screenHeight * 0.20, // Altezza del slider (20% dell'altezza dello schermo)
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: (session['exercises'] as List<dynamic>).map<Widget>((exercise) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent, // Sfondo trasparente
                              border: Border.all(
                                color: Colors.blueAccent, // Colore del bordo
                                width: screenWidth * 0.005, // Larghezza del bordo (sottile e responsive)
                              ),
                              borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.fitness_center, color: Colors.blueAccent, size: screenWidth * 0.08),
                                      SizedBox(width: screenWidth * 0.02),
                                      Expanded(
                                        child: Text(
                                          exercise['name'],
                                          style: ResponsiveTextStyles.labelMedium(context),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Divider(color: Colors.blueAccent, thickness: screenWidth * 0.002),
                                  SizedBox(height: screenHeight * 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.repeat, color: Colors.blueAccent, size: screenWidth * 0.05),
                                          SizedBox(width: screenWidth * 0.02),
                                          Text(
                                            'Serie: ${exercise['sets']}',
                                            style: ResponsiveTextStyles.miniLabel(context),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.looks, color: Colors.blueAccent, size: screenWidth * 0.05),
                                          SizedBox(width: screenWidth * 0.02),
                                          Text(
                                            'Ripetizioni: ${exercise['reps']}',
                                            style: ResponsiveTextStyles.miniLabel(context),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'Note:',
                                    style: ResponsiveTextStyles.miniLabel(context),
                                  ),
                                  Text(
                                    exercise['notes'],
                                    style: ResponsiveTextStyles.miniLabel(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
