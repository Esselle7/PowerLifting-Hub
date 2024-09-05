import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym/Home/ProfileActions/week_detail_page.dart';
import 'package:gym/Services/standardAppBar.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final bool testMode;

  WorkoutPage({required this.testMode});

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late Future<Map<String, dynamic>> _workoutData;

  @override
  void initState() {
    super.initState();
    _workoutData = fetchWorkoutData();
  }

  Color getWeekColor(int weekNumber, int currentWeek) {
    if (weekNumber < currentWeek) return Colors.green; // Settimane completate
    if (weekNumber == currentWeek) return Colors.yellowAccent; // Settimana attuale
    return Colors.white; // Settimane future
  }

  Future<Map<String, dynamic>> fetchWorkoutData() async {
    if (widget.testMode) {
      return generateTestData();
    } else {
      final url = Uri.parse('http://your-api-url/workout');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load workout data');
      }
    }
  }

  Map<String, dynamic> generateTestData() {
    // Definiamo la settimana attuale per la simulazione
    const currentWeek = 6; // Setta questa settimana come la settimana attuale

    List<Map<String, dynamic>> weeklySessions = [];
    for (int week = 1; week <= 12; week++) {
      List<Map<String, dynamic>> sessions = [];
      for (int session = 1; session <= 3; session++) {
        List<Map<String, dynamic>> exercises = [];
        for (int exercise = 1; exercise <= 5; exercise++) {
          exercises.add({
            "name": "Esercizio $exercise",
            "sets": 4,
            "reps": 10,
            "notes": "Note $exercise"
          });
        }
        sessions.add({
          "day": "Giorno $session",
          "exercises": exercises
        });
      }
      weeklySessions.add({
        "week": "Settimana $week",
        "sessions": sessions
      });
    }

    return {
      "athlete": {
        "name": "Simone Rovetti",
        "avatar": "avatar_w_pl",
        "city": "Como, Italy"
      },
      "workouts": weeklySessions,
      "currentWeek": currentWeek
    };
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double width = mediaQuery.size.width;
    final double height = mediaQuery.size.height;
    
    // Calcola dimensioni responsive
    final double cardMarginVertical = height * 0.01;
    final double cardMarginHorizontal = width * 0.04;
    final double cardPadding = width * 0.04;

    return Scaffold(
      appBar: StandardAppBar(title: "Scheda"),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _workoutData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Nessun dato disponibile'));
          }

          final data = snapshot.data!;
          final currentWeek = data['currentWeek'];
          final workouts = data['workouts'] as List<dynamic>;

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final weekData = workouts[index];
              final weekNumber = int.parse(weekData['week'].split(' ')[1]);

              return Card(
                margin: EdgeInsets.symmetric(
                  vertical: cardMarginVertical,
                  horizontal: cardMarginHorizontal,
                ),
                color: getWeekColor(weekNumber, currentWeek),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 1), // Aggiungi bordo
                  borderRadius: BorderRadius.circular(8), // Raggio di curvatura
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(cardPadding),
                  title: Text(
                    weekData['week'],
                    style: ResponsiveTextStyles.labelMedium(context, Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeekDetailPage(
                          weekData: weekData,
                          currentWeek: currentWeek,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
