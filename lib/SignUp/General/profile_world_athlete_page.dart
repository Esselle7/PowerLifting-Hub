import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym/Home/home_page.dart';
import 'package:gym/Services/network_services.dart';
import 'package:gym/SignUp/General/profile_world_coach_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:provider/provider.dart';

// Modello per i dati degli atleti
class Athlete {
  final String name;
  final String province;
  final String nation;

  Athlete({required this.name, required this.province, required this.nation});
}

// Lista di test per i top 5 atleti della provincia e della nazione
final List<Athlete> provinceTopAthletes = [
  Athlete(name: 'Athlete A', province: 'Provincia', nation: 'Nazione'),
  Athlete(name: 'Athlete B', province: 'Provincia', nation: 'Nazione'),
  Athlete(name: 'Athlete C', province: 'Provincia', nation: 'Nazione'),
  Athlete(name: 'Athlete D', province: 'Provincia', nation: 'Nazione'),
  Athlete(name: 'Athlete E', province: 'Provincia', nation: 'Nazione'),
];

final List<Athlete> nationTopAthletes = [
  Athlete(name: 'Athlete X', province: 'Provincia', nation: 'Nazione'),
  Athlete(name: 'Athlete Y', province: 'Provincia', nation: 'Nazione'),
  Athlete(name: 'Athlete Z', province: 'Provincia', nation: 'Nazione'),
  Athlete(name: 'Athlete W', province: 'Provincia', nation: 'Nazione'),
  Athlete(name: 'Athlete V', province: 'Provincia', nation: 'Nazione'),
];

// Simula la chiamata API per ottenere i top 5 atleti
Future<List<Athlete>> fetchTopAthletes(String type, {required bool testMode}) async {
  if (testMode) {
    if (type == 'province') {
      return Future.delayed(Duration(seconds: 1), () => provinceTopAthletes);
    } else if (type == 'nation') {
      return Future.delayed(Duration(seconds: 1), () => nationTopAthletes);
    }
  } else {
    // Inserisci la logica della chiamata API per ottenere i dati reali
    throw UnimplementedError('API call is not implemented.');
  }
  return [];
}

// Simula la chiamata API per ottenere gli atleti
Future<List<Athlete>> fetchAthletes({required bool testMode}) async {
  if (testMode) {
    // Lista di atleti di test
    return List.generate(
      30,
      (index) => Athlete(name: 'TestAthlete $index', province: 'Provincia', nation: 'Nazione'),
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

class ProfileWorldAthletePage extends StatefulWidget {
  final bool testMode;

  ProfileWorldAthletePage({required this.testMode});

  @override
  _ProfileWorldAthletePageState createState() => _ProfileWorldAthletePageState();
}

class _ProfileWorldAthletePageState extends State<ProfileWorldAthletePage> {
  final FocusNode _focusNode = FocusNode(); // FocusNode per il TextField

  late Future<List<Athlete>> _provinceTopAthletesFuture;
  late Future<List<Athlete>> _nationTopAthletesFuture;

  Set<String> _selectedAthletes = {}; // Stato per tenere traccia degli atleti selezionati
  List<Athlete> _filteredAthletes = []; // Lista degli atleti filtrati in base alla ricerca
  String _searchQuery = '';
  final NetworkService networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    _provinceTopAthletesFuture = fetchTopAthletes('province', testMode: widget.testMode);
    _nationTopAthletesFuture = fetchTopAthletes('nation', testMode: widget.testMode);
    _fetchAthletes(); // Ottiene gli atleti iniziali
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
      _filteredAthletes = persons
          .where((person) => person.name.toLowerCase().startsWith(_searchQuery.toLowerCase()))
          .map((person) => Athlete(name: person.name, province: '', nation: ''))
          .toList();
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

  void _showBottomSheet(String title, Future<List<Athlete>> athleteFuture) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: FutureBuilder<List<Athlete>>(
                        future: athleteFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Errore: ${snapshot.error}', style: TextStyle(color: Colors.blueAccent)));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('Nessun dato trovato.', style: TextStyle(color: Colors.blueAccent)));
                          } else {
                            return ListView.builder(
                              controller: scrollController,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final athlete = snapshot.data![index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue, // Colore fittizio per i cerchietti degli atleti
                                    child: Text(athlete.name[0], style: TextStyle(color: Colors.blueAccent)),
                                  ),
                                  title: Text(athlete.name, style: TextStyle(color: Colors.blueAccent)),
                                  subtitle: Text('${athlete.province}, ${athlete.nation}', style: TextStyle(color: Colors.blueAccent)),
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
    String nextStep = "";
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Nasconde la tastiera se clicchi altrove
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cerca Atleti'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo di ricerca
              TextField(
                focusNode: _focusNode,
                onChanged: _updateSearchQuery,
                decoration: InputDecoration(
                  labelText: 'Digita il nome del tuo atleta',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                ),
              ),
              SizedBox(height: 16.0),
              // Sezione per gli atleti filtrati
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _filteredAthletes.isEmpty
                        ? Center(
                            child: Text(
                              'Nessun atleta trovato',
                              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, // Numero fisso di colonne
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: _filteredAthletes.length > 16 ? 16 : _filteredAthletes.length,
                            itemBuilder: (context, index) {
                              final athlete = _filteredAthletes[index];
                              final isSelected = _selectedAthletes.contains(athlete.name);
                              return GestureDetector(
                                onTap: () => _toggleSelection(athlete.name),
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
                                          Positioned(
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
                                    SizedBox(height: 4),
                                    Text(
                                      athlete.name,
                                      style: TextStyle(color: Colors.blueAccent),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                    : SizedBox.shrink(),
              ),
              SizedBox(height: 20),
              // Pulsante per Top 5 Atleti della Provincia
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                onPressed: () => _showBottomSheet('Top 5 Atleti della Provincia', _provinceTopAthletesFuture),
                child: Text(
                  'Top 5 Atleti della Provincia',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Pulsante per Top 5 Atleti della Nazione
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                onPressed: () => _showBottomSheet('Top 5 Atleti della Nazione', _nationTopAthletesFuture),
                child: Text(
                  'Top 5 Atleti della Nazione',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Pulsante per il passo successivo
              ElevatedButton(
                onPressed: () {
                  final userProfile = Provider.of<UserProfile>(context, listen: false);
                  userProfile.updateWorldAthletes(athletes: _selectedAthletes.toList());
                  if(userProfile.isBoth){
                    nextStep = "Next Step";
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileWorldCoachPage(testMode: true),
                    ),
                  );
                  } else{
                    nextStep = "Save";

                    Map<String, dynamic> profile;
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
        'trainer': {
          'skillSpecifiche': userProfile.coachSkills,
          'titoli': userProfile.educationTitle,
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
                    String profileJson = jsonEncode(profile);
                    print(profileJson);
                    if(!widget.testMode){
                      networkService.sendData(profile);
                    }
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                  }
                  
                },
                child: Text(
                  nextStep,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).mainColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
