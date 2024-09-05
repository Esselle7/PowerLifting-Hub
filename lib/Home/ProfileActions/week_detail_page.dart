import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym/Services/standardAppBar.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:http/http.dart' as http;

class WeekDetailPage extends StatelessWidget {
  final Map<String, dynamic> weekData;
  final int currentWeek;

  WeekDetailPage({required this.weekData, required this.currentWeek});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: 'Dettagli ${weekData['week']}'),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ...(weekData['sessions'] as List<dynamic>).map<Widget>((session) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session['day'],
                    style: ResponsiveTextStyles.headlineLarge(context),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 200, // Altezza del slider
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: (session['exercises'] as List<dynamic>).map<Widget>((exercise) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise['name'],
                                    style: ResponsiveTextStyles.labelMedium(context),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Serie: ${exercise['sets']}',
                                        style: ResponsiveTextStyles.labelSmall(context)
                                      ),
                                      Text(
                                        'Ripetizioni: ${exercise['reps']}',
                                         style: ResponsiveTextStyles.labelSmall(context)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Note: ${exercise['notes']}',
                                     style: ResponsiveTextStyles.labelSmall(context)
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
          }).toList(),
        ],
      ),
    );
  }
}
