import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym/Home/home_page.dart';
import 'package:gym/Services/network_services.dart';
import 'package:gym/Services/standardAppBar.dart';
import 'package:gym/SignUp/General/profile_world_coach_page.dart';
import 'package:gym/Theme/responsive_button_style.dart';
import 'package:gym/Theme/responsive_text_box.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:gym/SignUp/General/profile_world_athlete_page.dart';
import 'package:gym/SignUp/General/profile_world_federation_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';

// Lista di test per le top 5 athlete della provincia e della nazione in formato JSON
final List<Map<String, String>> provinceTopAthletes = [
  {"name": "Athlete A", "province": "Provincia", "nation": "Nazione"},
  {"name": "Athlete B", "province": "Provincia", "nation": "Nazione"},
  {"name": "Athlete C", "province": "Provincia", "nation": "Nazione"},
  {"name": "Athlete D", "province": "Provincia", "nation": "Nazione"},
  {"name": "Athlete E", "province": "Provincia", "nation": "Nazione"},
];

final List<Map<String, String>> nationTopAthletes = [
  {"name": "Athlete X", "province": "Provincia", "nation": "Nazione"},
  {"name": "Athlete Y", "province": "Provincia", "nation": "Nazione"},
  {"name": "Athlete Z", "province": "Provincia", "nation": "Nazione"},
  {"name": "Athlete W", "province": "Provincia", "nation": "Nazione"},
  {"name": "Athlete V", "province": "Provincia", "nation": "Nazione"},
];

// Simula la chiamata API per ottenere le top 5 athlete
Future<List<Map<String, String>>> fetchTopAthletes(String type, {required bool testMode}) async {
  if (testMode) {
    if (type == 'province') {
      return Future.delayed(const Duration(seconds: 1), () => provinceTopAthletes);
    } else if (type == 'nation') {
      return Future.delayed(const Duration(seconds: 1), () => nationTopAthletes);
    }
  } else {
    throw UnimplementedError('API call is not implemented.');
  }
  return [];
}

// Simula la chiamata API per ottenere le athlete
Future<List<Map<String, String>>> fetchAthletes({required bool testMode}) async {
  if (testMode) {
    return List.generate(
      30,
      (index) => {"name": "TestAthlete $index", "province": "Provincia", "nation": "Nazione"},
    );
  } else {
    throw UnimplementedError('API call is not implemented.');
  }
}

class ProfileWorldAthletePage extends StatefulWidget {
  final bool testMode;

  const ProfileWorldAthletePage({super.key, required this.testMode});

  @override
  _ProfileWorldAthletePageState createState() => _ProfileWorldAthletePageState();
}

class _ProfileWorldAthletePageState extends State<ProfileWorldAthletePage> {
  final FocusNode _focusNode = FocusNode();

  late Future<List<Map<String, String>>> _provinceTopAthletesFuture;
  late Future<List<Map<String, String>>> _nationTopAthletesFuture;

  final Set<String> _selectedAthletes = {};
  List<Map<String, String>> _filteredAthletes = [];
  String _searchQuery = '';
  final NetworkService networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    _provinceTopAthletesFuture = fetchTopAthletes('province', testMode: widget.testMode);
    _nationTopAthletesFuture = fetchTopAthletes('nation', testMode: widget.testMode);
    _fetchAthletes();
  }

  Future<void> _fetchAthletes() async {
    final athletes = await fetchAthletes(testMode: widget.testMode);
    setState(() {
      _filteredAthletes = athletes;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredAthletes = _filteredAthletes.where((athlete) => athlete['name']!.toLowerCase().startsWith(_searchQuery.toLowerCase())).toList();
    });
  }

  void _toggleSelection(String athleteName) {
    setState(() {
      if (_selectedAthletes.contains(athleteName)) {
        _selectedAthletes.remove(athleteName);
      } else {
        _selectedAthletes.add(athleteName);
      }
    });
  }

  void _showBottomSheet(String title, Future<List<Map<String, String>>> athleteFuture) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey.withOpacity(0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: ResponsiveTextStyles.labelLarge(context),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Expanded(
                      child: FutureBuilder<List<Map<String, String>>>(
                        future: athleteFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Errore: ${snapshot.error}', style: TextStyle(color: Colors.blueAccent)));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('Nessun dato trovato.', style: TextStyle(color: Colors.blueAccent)));
                          } else {
                            return ListView.builder(
                              controller: scrollController,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final athlete = snapshot.data![index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(athlete['name']![0], style: ResponsiveTextStyles.labelMedium(context)),
                                  ),
                                  title: Text(athlete['name']!, style: ResponsiveTextStyles.labelMedium(context)),
                                  subtitle: Text('${athlete['province']}, ${athlete['nation']}', style: ResponsiveTextStyles.labelSmall(context)),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: StandardAppBar(title: "Cerca Athletes"),
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            children: [
              CustomTextField(labelText: "Inserisci nome athlete", icon: Icons.search, onChanged: _updateSearchQuery),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _filteredAthletes.isEmpty
                        ? Center(
                            child: Text(
                              'Nessuna athlete trovata',
                              style: ResponsiveTextStyles.labelMedium(context),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width > 350 ? 4 : 3,
                              crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                              mainAxisSpacing: MediaQuery.of(context).size.width * 0.02,
                              childAspectRatio: 1,
                            ),
                            itemCount: _filteredAthletes.length,
                            itemBuilder: (context, index) {
                              final athlete = _filteredAthletes[index];
                              final isSelected = _selectedAthletes.contains(athlete['name']);
                              return GestureDetector(
                                onTap: () => _toggleSelection(athlete['name']!),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.1,
                                          height: MediaQuery.of(context).size.width * 0.1,
                                          decoration: BoxDecoration(
                                            color: isSelected ? Colors.green : Colors.blue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected ? Colors.green : Colors.blueAccent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: Icon(
                                              Icons.check_circle,
                                              size: MediaQuery.of(context).size.width * 0.07,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                    Text(
                                      athlete['name']!,
                                      style: ResponsiveTextStyles.labelSmall(context),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Pulsante per Top 5 Athlete della Provincia
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Top 5 Athlete della Provincia',
                onPressed: () => _showBottomSheet('Top 5 Athlete della Provincia', _provinceTopAthletesFuture),
                icon: Icons.star,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Pulsante per Top 5 Athlete della Nazione
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Top 5 Athlete della Nazione',
                onPressed: () => _showBottomSheet('Top 5 Athlete della Nazione', _nationTopAthletesFuture),
                icon: Icons.flag,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Pulsante per il passo successivo
              ResponsiveButtonStyle.mediumButton(
                context: context,
                onPressed: () {
                  final userProfile = Provider.of<UserProfile>(context, listen: false);
                  userProfile.updateWorldAthletes(athletes: _selectedAthletes.toList());
                  if (userProfile.isBoth) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileWorldCoachPage(testMode: true),
                      ),
                    );
                  } else {
                    Map<String, dynamic> profile = {
                      'utente': {
                        'nome': userProfile.firstName,
                        'cognome': userProfile.lastName,
                        'username': userProfile.username,
                        'dob': userProfile.dob.toIso8601String(),
                        'password': userProfile.password,
                        'mail': userProfile.email,
                        'sesso': userProfile.isMale,
                        'athletes': userProfile.athletes,
                      },
                      'trainer': {
                        'skillSpecifiche': userProfile.coachSkills,
                        'titoli': userProfile.educationTitles,
                        'atleti': userProfile.athletes,
                      },
                      'massimali': [
                        {
                          'alzata': "SQUAT",
                          'data': userProfile.squatDate.toIso8601String(),
                          'peso': userProfile.squat,
                        },
                        {
                          'alzata': "PANCA_PIANA",
                          'data': userProfile.bpDate.toIso8601String(),
                          'peso': userProfile.benchPress,
                        },
                        {
                          'alzata': "STACCO_DA_TERRA",
                          'data': userProfile.dlDate.toIso8601String(),
                          'peso': userProfile.deadlift,
                        }
                      ]
                    };
                    String profileJson = jsonEncode(profile);
                    print(profileJson);
                    if (!widget.testMode) {
                      networkService.sendData(profile, "registrazione", "8080", context);
                    }
                    userProfile.reset();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  }
                },
                buttonText: 'Prosegui',
                icon: Icons.navigate_next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
