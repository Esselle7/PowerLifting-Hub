import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym/Home/ProfileActions/edit_personal_info_page.dart';
import 'package:gym/Home/ProfileActions/workout_page.dart';
import 'package:gym/Services/homeAppBar.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final bool testMode;

  const ProfilePage({super.key, required this.testMode});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _profileData;

  @override
  void initState() {
    super.initState();
    _profileData = fetchProfileData();
  }

  Future<Map<String, dynamic>> fetchProfileData() async {
    if (widget.testMode) {
      return {
        "avatar": "avatar_w_pl",
        "storico": [
          {"alzata": "SQUAT", "data": "2023-10-01", "peso": 150.5},
          {"alzata": "SQUAT", "data": "2023-09-25", "peso": 145.0},
          {"alzata": "SQUAT", "data": "2023-09-20", "peso": 140.0},
          {"alzata": "SQUAT", "data": "2023-09-15", "peso": 137.5},
          {"alzata": "SQUAT", "data": "2023-09-10", "peso": 135.0},
          {"alzata": "PANCA_PIANA", "data": "2023-10-11", "peso": 100.0},
          {"alzata": "PANCA_PIANA", "data": "2023-09-26", "peso": 98.0},
          {"alzata": "PANCA_PIANA", "data": "2023-09-16", "peso": 97.0},
          {"alzata": "PANCA_PIANA", "data": "2023-09-01", "peso": 95.0},
          {"alzata": "STACCO_DA_TERRA", "data": "2023-10-12", "peso": 180.0},
          {"alzata": "STACCO_DA_TERRA", "data": "2023-09-22", "peso": 175.0},
          {"alzata": "STACCO_DA_TERRA", "data": "2023-09-12", "peso": 170.0},
        ],
        "wod": [
          {"esercizio": "Spinte con manubri", "serie": 4, "rep": 10, "note": "Discesa lenta"},
          {"esercizio": "Stacchi da terra", "serie": 4, "rep": 8, "note": "Mantieni la schiena dritta"},
          {"esercizio": "Trazioni", "serie": 3, "rep": 12, "note": "Esegui lentamente"}
        ],
        "nome": "Simone",
        "cognome": "Rovetti",
        "citta": "Como, Italy",
        "badge": ["BADGE_ORO"],
      };
    } else {
      final url = Uri.parse('http://your-api-url/profile');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load profile data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: HomeAppBar(title: "Profilo"),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Nessun dato disponibile'));
          }

          final data = snapshot.data!;
          final storicos = data['storico'] as List<dynamic>;

          final eserciziMap = <String, List<Map<String, dynamic>>>{};
          for (var item in storicos) {
            final alzata = item['alzata'];
            if (!eserciziMap.containsKey(alzata)) {
              eserciziMap[alzata] = [];
            }
            eserciziMap[alzata]!.add(item);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar, Badge e Bottoni
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: screenWidth * 0.12,
                                backgroundImage: AssetImage('assets/${data['avatar']}.jpeg'),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${data['nome']} ${data['cognome']}',
                                          style: ResponsiveTextStyles.labelMedium(context),
                                        ),
                                        SizedBox(width: screenWidth * 0.10),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditProfilePage(testMode: true),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.blueAccent,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.030,
                                              vertical: screenHeight * 0.01,
                                            ),
                                            side: const BorderSide(color: Colors.blueAccent),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular((screenWidth * 0.03)),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.edit, color: Colors.blueAccent),
                                              SizedBox(width: screenWidth * 0.01),
                                              const Text('Edit'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${data['citta']}',
                                      style: ResponsiveTextStyles.labelSmall(context),
                                    ),
                                    SizedBox(height: screenHeight * 0.015),
                                    Wrap(
                                      spacing: screenWidth * 0.02,
                                      children: data['badge'].map<Widget>((badge) {
                                        return Column(
                                          children: [
                                            SizedBox(height: screenHeight * 0.005),
                                            Text(
                                              badge.replaceAll('BADGE_', ''),
                                              style: ResponsiveTextStyles.labelMedium(context),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),

                // Storico
                Text(
                  'Storico',
                  style: ResponsiveTextStyles.labelMedium(context, Colors.blueAccent),
                ),
                SizedBox(height: screenHeight * 0.015),

                // Slider per visualizzare i grafici
                SizedBox(
                  height: screenHeight * 0.3,
                  child: PageView.builder(
                    itemCount: eserciziMap.keys.length,
                    itemBuilder: (context, index) {
                      final esercizio = eserciziMap.keys.elementAt(index);
                      final datiEsercizio = eserciziMap[esercizio]!;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            border: Border.all(color: Colors.blueAccent, width: screenWidth * 0.005),
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                esercizio,
                                style: ResponsiveTextStyles.labelMedium(context, Colors.blueAccent),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Expanded(
                                child: LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: true,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Colors.blueAccent.withOpacity(0.2),
                                          strokeWidth: 1,
                                        );
                                      },
                                      getDrawingVerticalLine: (value) {
                                        return FlLine(
                                          color: Colors.blueAccent.withOpacity(0.2),
                                          strokeWidth: 1,
                                        );
                                      },
                                    ),
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 20,
                                          getTitlesWidget: (value, meta) {
                                            final int index = value.toInt();
                                            if (index == 0 || index == datiEsercizio.length - 1) {
                                              final date = datiEsercizio[index]['data'];
                                              return SideTitleWidget(
                                                axisSide: meta.axisSide,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    right: index == datiEsercizio.length - 1 ? screenWidth * 0.05 : 0.0,
                                                  ),
                                                  child: Text(
                                                    date.substring(5),
                                                    style: ResponsiveTextStyles.labelSmall(context, Colors.blueAccent),
                                                  ),
                                                ),
                                              );
                                            }
                                            return SideTitleWidget(
                                              axisSide: meta.axisSide,
                                              child: const SizedBox.shrink(),
                                            );
                                          },
                                          interval: 1,
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 30,
                                          getTitlesWidget: (value, meta) {
                                            final firstPeso = datiEsercizio.first['peso'];
                                            final lastPeso = datiEsercizio.last['peso'];
                                            if (value == firstPeso || value == lastPeso) {
                                              return SideTitleWidget(
                                                axisSide: meta.axisSide,
                                                child: Text(
                                                  '${value.toInt()} kg',
                                                  style: ResponsiveTextStyles.labelSmall(context, Colors.blueAccent),
                                                ),
                                              );
                                            }
                                            return SideTitleWidget(
                                              axisSide: meta.axisSide,
                                              child: const SizedBox.shrink(),
                                            );
                                          },
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(color: Colors.blueAccent),
                                    ),
                                    minX: 0,
                                    maxX: (datiEsercizio.length - 1).toDouble(),
                                    minY: datiEsercizio.map((e) => e['peso']).reduce((a, b) => a < b ? a : b) - 10,
                                    maxY: datiEsercizio.map((e) => e['peso']).reduce((a, b) => a > b ? a : b) + 10,
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: List.generate(datiEsercizio.length, (i) {
                                          return FlSpot(i.toDouble(), datiEsercizio[i]['peso']);
                                        }),
                                        isCurved: true,
                                        color: Colors.blueAccent,
                                        barWidth: 2,
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.blueAccent.withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // WOD e Bottone Visualizza Workout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'WOD',
                      style: ResponsiveTextStyles.labelMedium(context, Colors.blueAccent),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutPage(testMode: true),
                            ),
                          );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.015,
                        ),
                        side: const BorderSide(color: Colors.blueAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        ),
                      ),
                      child: Text('Visualizza Workout', style: ResponsiveTextStyles.labelMedium(context, Colors.blueAccent),),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.015),
                // Slider WOD
                SizedBox(
                    height: screenHeight * 0.20, // Altezza del slider (20% dell'altezza dello schermo)
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: (data['wod'] as List<dynamic>).map<Widget>((exercise) {
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
                                          exercise['esercizio'],
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
                                            'Serie: ${exercise['serie']}',
                                            style: ResponsiveTextStyles.labelSmall(context),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.looks, color: Colors.blueAccent, size: screenWidth * 0.05),
                                          SizedBox(width: screenWidth * 0.02),
                                          Text(
                                            'Ripetizioni: ${exercise['rep']}',
                                            style: ResponsiveTextStyles.labelSmall(context),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'Note:',
                                    style: ResponsiveTextStyles.labelSmall(context),
                                  ),
                                  Text(
                                    exercise['note'],
                                    style: ResponsiveTextStyles.labelSmall(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          );
        },
      ),
    );
  }
}
