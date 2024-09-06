import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym/Home/home_page.dart';
import 'package:gym/Services/network_services.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:provider/provider.dart';

// Modello per i dati dei coach
class Coach {
  final String name;
  final String province;
  final String nation;

  Coach({required this.name, required this.province, required this.nation});
}

// Lista di test per i top 5 coach della provincia e della nazione
final List<Coach> provinceTopCoaches = [
  Coach(name: 'Coach A', province: 'Provincia', nation: 'Nazione'),
  Coach(name: 'Coach B', province: 'Provincia', nation: 'Nazione'),
  Coach(name: 'Coach C', province: 'Provincia', nation: 'Nazione'),
  Coach(name: 'Coach D', province: 'Provincia', nation: 'Nazione'),
  Coach(name: 'Coach E', province: 'Provincia', nation: 'Nazione'),
];

final List<Coach> nationTopCoaches = [
  Coach(name: 'Coach X', province: 'Provincia', nation: 'Nazione'),
  Coach(name: 'Coach Y', province: 'Provincia', nation: 'Nazione'),
  Coach(name: 'Coach Z', province: 'Provincia', nation: 'Nazione'),
  Coach(name: 'Coach W', province: 'Provincia', nation: 'Nazione'),
  Coach(name: 'Coach V', province: 'Provincia', nation: 'Nazione'),
];

// Simula la chiamata API per ottenere i top 5 coach
Future<List<Coach>> fetchTopCoaches(String type, {required bool testMode}) async {
  if (testMode) {
    if (type == 'province') {
      return Future.delayed(const Duration(seconds: 1), () => provinceTopCoaches);
    } else if (type == 'nation') {
      return Future.delayed(const Duration(seconds: 1), () => nationTopCoaches);
    }
  } else {
    // Inserisci la logica della chiamata API per ottenere i dati reali
    throw UnimplementedError('API call is not implemented.');
  }
  return [];
}

// Simula la chiamata API per ottenere i coach
Future<List<Coach>> fetchCoaches({required bool testMode}) async {
  if (testMode) {
    // Lista di coach di test
    return List.generate(
      30,
      (index) => Coach(name: 'TestCoach $index', province: 'Provincia', nation: 'Nazione'),
    );
  } else {
    // Inserisci la logica della chiamata API per ottenere i dati reali
    throw UnimplementedError('API call is not implemented.');
  }
}

// Modello per i dati delle persone
class Person {
  final String name;
  final Color color;

  Person({required this.name, required this.color});
}

// Esempio di dati per i cerchietti
final List<Person> persons = List.generate(
  30,
  (index) => Person(
    name: 'Nome $index',
    color: Colors.primaries[index % Colors.primaries.length],
  ),
);

class ProfileWorldCoachPage extends StatefulWidget {
  final bool testMode;

  const ProfileWorldCoachPage({super.key, required this.testMode});

  @override
  _ProfileWorldCoachPageState createState() => _ProfileWorldCoachPageState();
}

class _ProfileWorldCoachPageState extends State<ProfileWorldCoachPage> {
  final FocusNode _focusNode = FocusNode(); // FocusNode per il TextField

  late Future<List<Coach>> _provinceTopCoachesFuture;
  late Future<List<Coach>> _nationTopCoachesFuture;

  final Set<String> _selectedCoaches = {}; // Stato per tenere traccia dei coach selezionati
  List<Coach> _filteredCoaches = []; // Lista dei coach filtrati in base alla ricerca
  String _searchQuery = '';
  final NetworkService networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    _provinceTopCoachesFuture = fetchTopCoaches('province', testMode: widget.testMode);
    _nationTopCoachesFuture = fetchTopCoaches('nation', testMode: widget.testMode);
    _fetchCoaches(); // Ottiene i coach iniziali
  }

  Future<void> _fetchCoaches() async {
    final coaches = await fetchCoaches(testMode: widget.testMode);
    setState(() {
      _filteredCoaches = coaches;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCoaches = persons
          .where((person) => person.name.toLowerCase().startsWith(_searchQuery.toLowerCase()))
          .map((person) => Coach(name: person.name, province: '', nation: ''))
          .toList();
    });
  }

  void _toggleSelection(String coachName) {
    setState(() {
      if (_selectedCoaches.contains(coachName)) {
        _selectedCoaches.remove(coachName);
      } else {
        _selectedCoaches.add(coachName);
      }
    });
  }

  void _showBottomSheet(String title, Future<List<Coach>> coachFuture) {
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: FutureBuilder<List<Coach>>(
                        future: coachFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Errore: ${snapshot.error}', style: const TextStyle(color: Colors.blueAccent)));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('Nessun dato trovato.', style: TextStyle(color: Colors.blueAccent)));
                          } else {
                            return ListView.builder(
                              controller: scrollController,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final coach = snapshot.data![index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue, // Colore fittizio per i cerchietti dei coach
                                    child: Text(coach.name[0], style: const TextStyle(color: Colors.blueAccent)),
                                  ),
                                  title: Text(coach.name, style: const TextStyle(color: Colors.blueAccent)),
                                  subtitle: Text('${coach.province}, ${coach.nation}', style: const TextStyle(color: Colors.blueAccent)),
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
          _focusNode.unfocus(); // Assicurati che il focus sia rimosso anche quando il BottomSheet è chiuso
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Nasconde la tastiera se clicchi altrove
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cerca Coach'),
          backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo di ricerca
              TextField(
                focusNode: _focusNode,
                onChanged: _updateSearchQuery,
                decoration: const InputDecoration(
                  labelText: 'Digita il nome del tuo coach',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 16.0),
              // Sezione per i coach filtrati
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _filteredCoaches.isEmpty
                        ? const Center(
                            child: Text(
                              'Nessun coach trovato',
                              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, // Numero fisso di colonne
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: _filteredCoaches.length > 16 ? 16 : _filteredCoaches.length,
                            itemBuilder: (context, index) {
                              final coach = _filteredCoaches[index];
                              final isSelected = _selectedCoaches.contains(coach.name);
                              return GestureDetector(
                                onTap: () => _toggleSelection(coach.name),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
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
                                          const Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: Icon(
                                              Icons.check_circle,
                                              size: 20,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      coach.name,
                                      style: const TextStyle(color: Colors.blueAccent),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),
              // Pulsante per Top 5 Coach della Provincia
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                onPressed: () => _showBottomSheet('Top 5 Coach della Provincia', _provinceTopCoachesFuture),
                child: const Text(
                  'Top 5 Coach della Provincia',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Pulsante per Top 5 Coach della Nazione
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                onPressed: () => _showBottomSheet('Top 5 Coach della Nazione', _nationTopCoachesFuture),
                child: const Text(
                  'Top 5 Coach della Nazione',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Pulsante per il passo successivo
              ElevatedButton(
                onPressed: () {
                  final userProfile = Provider.of<UserProfile>(context, listen: false);
                  userProfile.updateWorldCoaches(coaches: _selectedCoaches.toList());
                  Map<String, dynamic> profile;
                  if(userProfile.isBoth){
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
          //'tipologia': "POWERLIFTER",
          
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
          //elimina dips
        ]
      };
                  }
                  else{
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
          'tipologia': userProfile.category, // fixme
          //'tipologia': "POWERLIFTER",
          
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
          //elimina dips
        ]
      };
                  }
                  String profileJson = jsonEncode(profile);
                    print(profileJson);
                    if(!widget.testMode){
                      networkService.sendData(profile, "registrazione", "8080",context);
                    }
                    userProfile.reset();
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).mainColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black45,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
