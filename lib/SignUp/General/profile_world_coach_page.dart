import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym/Home/home_page.dart';
import 'package:gym/Services/network_services.dart';
import 'package:gym/Services/standardAppBar.dart';
import 'package:gym/Theme/responsive_button_style.dart';
import 'package:gym/Theme/responsive_text_box.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:gym/SignUp/General/profile_world_athlete_page.dart';
import 'package:gym/SignUp/General/profile_world_federation_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';

// Lista di test per le top 5 Coach della provincia e della nazione in formato JSON
final List<Map<String, String>> provinceTopCoachs = [
  {"name": "Coach A", "province": "Provincia", "nation": "Nazione"},
  {"name": "Coach B", "province": "Provincia", "nation": "Nazione"},
  {"name": "Coach C", "province": "Provincia", "nation": "Nazione"},
  {"name": "Coach D", "province": "Provincia", "nation": "Nazione"},
  {"name": "Coach E", "province": "Provincia", "nation": "Nazione"},
];

final List<Map<String, String>> nationTopCoachs = [
  {"name": "Coach X", "province": "Provincia", "nation": "Nazione"},
  {"name": "Coach Y", "province": "Provincia", "nation": "Nazione"},
  {"name": "Coach Z", "province": "Provincia", "nation": "Nazione"},
  {"name": "Coach W", "province": "Provincia", "nation": "Nazione"},
  {"name": "Coach V", "province": "Provincia", "nation": "Nazione"},
];

// Simula la chiamata API per ottenere le top 5 Coach
Future<List<Map<String, String>>> fetchTopCoachs(String type, {required bool testMode}) async {
  if (testMode) {
    if (type == 'province') {
      return Future.delayed(const Duration(seconds: 1), () => provinceTopCoachs);
    } else if (type == 'nation') {
      return Future.delayed(const Duration(seconds: 1), () => nationTopCoachs);
    }
  } else {
    throw UnimplementedError('API call is not implemented.');
  }
  return [];
}

// Simula la chiamata API per ottenere le Coach
Future<List<Map<String, String>>> fetchCoachs({required bool testMode}) async {
  if (testMode) {
    return List.generate(
      30,
      (index) => {"name": "TestCoach $index", "province": "Provincia", "nation": "Nazione"},
    );
  } else {
    throw UnimplementedError('API call is not implemented.');
  }
}

class ProfileWorldCoachPage extends StatefulWidget {
  final bool testMode;

  const ProfileWorldCoachPage({super.key, required this.testMode});

  @override
  _ProfileWorldCoachPageState createState() => _ProfileWorldCoachPageState();
}

class _ProfileWorldCoachPageState extends State<ProfileWorldCoachPage> {
  final FocusNode _focusNode = FocusNode();

  late Future<List<Map<String, String>>> _provinceTopCoachsFuture;
  late Future<List<Map<String, String>>> _nationTopCoachsFuture;

  final Set<String> _selectedCoaches = {};
  List<Map<String, String>> _filteredCoachs = [];
  String _searchQuery = '';
   final NetworkService networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    _provinceTopCoachsFuture = fetchTopCoachs('province', testMode: widget.testMode);
    _nationTopCoachsFuture = fetchTopCoachs('nation', testMode: widget.testMode);
    _fetchCoachs();
  }

  Future<void> _fetchCoachs() async {
    final Coachs = await fetchCoachs(testMode: widget.testMode);
    setState(() {
      _filteredCoachs = Coachs;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCoachs = _filteredCoachs.where((Coach) => Coach['name']!.toLowerCase().startsWith(_searchQuery.toLowerCase())).toList();
    });
  }

  void _toggleSelection(String CoachName) {
    setState(() {
      if (_selectedCoaches.contains(CoachName)) {
        _selectedCoaches.remove(CoachName);
      } else {
        _selectedCoaches.add(CoachName);
      }
    });
  }

  void _showBottomSheet(String title, Future<List<Map<String, String>>> CoachFuture) {
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
                        future: CoachFuture,
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
                                final Coach = snapshot.data![index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(Coach['name']![0], style: ResponsiveTextStyles.labelMedium(context)),
                                  ),
                                  title: Text(Coach['name']!, style: ResponsiveTextStyles.labelMedium(context)),
                                  subtitle: Text('${Coach['province']}, ${Coach['nation']}', style: ResponsiveTextStyles.labelSmall(context)),
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
        appBar: StandardAppBar(title: "Cerca Coachs"),
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            children: [
              CustomTextField(labelText: "Inserisci nome Coach", icon: Icons.search, onChanged: _updateSearchQuery),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _filteredCoachs.isEmpty
                        ? Center(
                            child: Text(
                              'Nessuna Coach trovata',
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
                            itemCount: _filteredCoachs.length,
                            itemBuilder: (context, index) {
                              final Coach = _filteredCoachs[index];
                              final isSelected = _selectedCoaches.contains(Coach['name']);
                              return GestureDetector(
                                onTap: () => _toggleSelection(Coach['name']!),
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
                                      Coach['name']!,
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
              // Pulsante per Top 5 Coach della Provincia
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Top 5 Coach della Provincia',
                onPressed: () => _showBottomSheet('Top 5 Coach della Provincia', _provinceTopCoachsFuture),
                icon: Icons.star,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Pulsante per Top 5 Coach della Nazione
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Top 5 Coach della Nazione',
                onPressed: () => _showBottomSheet('Top 5 Coach della Nazione', _nationTopCoachsFuture),
                icon: Icons.flag,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Pulsante per il passo successivo
                ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Save',
                onPressed: _saveProfile,
                icon: Icons.navigate_next,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    final userProfile = Provider.of<UserProfile>(context, listen: false);
    userProfile.updateWorldCoaches(coaches: _selectedCoaches.toList());
    Map<String, dynamic> profile;
    if (userProfile.isBoth) {
      profile = {
        'utente': {
          'nome': userProfile.firstName,
          'cognome': userProfile.lastName,
          'username': userProfile.username,
          'dob': userProfile.dob.toIso8601String(),
          'password': userProfile.password,
          'mail': userProfile.email,
          'sesso': userProfile.isMale,
          'crews': userProfile.crews,
        },
        'atleta': {
          'federazione': userProfile.federation,
          'tipologia': userProfile.category,
          'trainer': userProfile.coaches,
          'weightClass': userProfile.weightClass,
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
    } else {
      profile = {
        'utente': {
          'nome': userProfile.firstName,
          'cognome': userProfile.lastName,
          'username': userProfile.username,
          'dob': userProfile.dob.toIso8601String(),
          'password': userProfile.password,
          'mail': userProfile.email,
          'sesso': userProfile.isMale,
          'crews': userProfile.crews,
        },
        'atleta': {
          'federazione': userProfile.federation,
          'tipologia': userProfile.category,
          'trainers': userProfile.coaches,
          'weightClass': userProfile.weightClass,
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
    }
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
}
