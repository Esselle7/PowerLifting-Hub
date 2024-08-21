import 'package:flutter/material.dart';
import 'package:gym/SignUp/General/profile_world_athlete_page.dart';
import 'package:gym/SignUp/General/profile_world_federation_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:provider/provider.dart';

// Modello per i dati delle crew
class Crew {
  final String name;
  final String province;
  final String nation;

  Crew({required this.name, required this.province, required this.nation});
}

// Lista di test per le top 5 crew della provincia e della nazione
final List<Crew> provinceTopCrews = [
  Crew(name: 'Crew A', province: 'Provincia', nation: 'Nazione'),
  Crew(name: 'Crew B', province: 'Provincia', nation: 'Nazione'),
  Crew(name: 'Crew C', province: 'Provincia', nation: 'Nazione'),
  Crew(name: 'Crew D', province: 'Provincia', nation: 'Nazione'),
  Crew(name: 'Crew E', province: 'Provincia', nation: 'Nazione'),
];

final List<Crew> nationTopCrews = [
  Crew(name: 'Crew X', province: 'Provincia', nation: 'Nazione'),
  Crew(name: 'Crew Y', province: 'Provincia', nation: 'Nazione'),
  Crew(name: 'Crew Z', province: 'Provincia', nation: 'Nazione'),
  Crew(name: 'Crew W', province: 'Provincia', nation: 'Nazione'),
  Crew(name: 'Crew V', province: 'Provincia', nation: 'Nazione'),
];

// Simula la chiamata API per ottenere le top 5 crew
Future<List<Crew>> fetchTopCrews(String type, {required bool testMode}) async {
  if (testMode) {
    if (type == 'province') {
      return Future.delayed(Duration(seconds: 1), () => provinceTopCrews);
    } else if (type == 'nation') {
      return Future.delayed(Duration(seconds: 1), () => nationTopCrews);
    }
  } else {
    // Inserisci la logica della chiamata API per ottenere i dati reali
    throw UnimplementedError('API call is not implemented.');
  }
  return [];
}

// Simula la chiamata API per ottenere le crew
Future<List<Crew>> fetchCrews({required bool testMode}) async {
  if (testMode) {
    // Lista di crew di test
    return List.generate(
      30,
      (index) => Crew(name: 'TestCrew $index', province: 'Provincia', nation: 'Nazione'),
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

class ProfileWorldCrewPage extends StatefulWidget {
  final bool testMode;

  ProfileWorldCrewPage({required this.testMode});

  @override
  _ProfileWorldCrewPageState createState() => _ProfileWorldCrewPageState();
}

class _ProfileWorldCrewPageState extends State<ProfileWorldCrewPage> {
  final FocusNode _focusNode = FocusNode(); // FocusNode per il TextField

  late Future<List<Crew>> _provinceTopCrewsFuture;
  late Future<List<Crew>> _nationTopCrewsFuture;

  Set<String> _selectedCrews = {}; // Stato per tenere traccia delle crew selezionate
  List<Crew> _filteredCrews = []; // Lista delle crew filtrate in base alla ricerca
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _provinceTopCrewsFuture = fetchTopCrews('province', testMode: widget.testMode);
    _nationTopCrewsFuture = fetchTopCrews('nation', testMode: widget.testMode);
    _fetchCrews(); // Ottiene le crew iniziali
  }

  Future<void> _fetchCrews() async {
    final crews = await fetchCrews(testMode: widget.testMode);
    setState(() {
      _filteredCrews = crews;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCrews = persons
          .where((person) => person.name.toLowerCase().startsWith(_searchQuery.toLowerCase()))
          .map((person) => Crew(name: person.name, province: '', nation: ''))
          .toList();
    });
  }

  void _toggleSelection(String crewName) {
    setState(() {
      if (_selectedCrews.contains(crewName)) {
        _selectedCrews.remove(crewName);
      } else {
        _selectedCrews.add(crewName);
      }
    });
  }

  void _showBottomSheet(String title, Future<List<Crew>> crewFuture) {
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
                      child: FutureBuilder<List<Crew>>(
                        future: crewFuture,
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
                                final crew = snapshot.data![index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue, // Colore fittizio per i cerchietti delle crew
                                    child: Text(crew.name[0], style: TextStyle(color: Colors.blueAccent)),
                                  ),
                                  title: Text(crew.name, style: TextStyle(color: Colors.blueAccent)),
                                  subtitle: Text('${crew.province}, ${crew.nation}', style: TextStyle(color: Colors.blueAccent)),
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
          title: Text('Cerca Persone'),
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
                  labelText: 'Digita il nome della tua crew',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                ),
              ),
              SizedBox(height: 16.0),
              // Sezione per le crew filtrate
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _filteredCrews.isEmpty
                        ? Center(
                            child: Text(
                              'Nessuna crew trovata',
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
                            
                            itemCount: _filteredCrews.length,
                            itemBuilder: (context, index) {
                              final crew = _filteredCrews[index];
                              final isSelected = _selectedCrews.contains(crew.name);
                              return GestureDetector(
                                onTap: () => _toggleSelection(crew.name),
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
                                      crew.name,
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
              // Pulsante per Top 5 Crew della Provincia
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                onPressed: () => _showBottomSheet('Top 5 Crew della Provincia', _provinceTopCrewsFuture),
                child: Text(
                  'Top 5 Crew della Provincia',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Pulsante per Top 5 Crew della Nazione
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                onPressed: () => _showBottomSheet('Top 5 Crew della Nazione', _nationTopCrewsFuture),
                child: Text(
                  'Top 5 Crew della Nazione',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Pulsante per il passo successivo
              ElevatedButton(
                onPressed: () {
                  final userProfile = Provider.of<UserProfile>(context, listen: false);
                  userProfile.updateWorldCrews(crews: _selectedCrews.toList());
                  if(userProfile.isAthlete || userProfile.isBoth){
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileWorldFederationPage(testMode: true),
                    ),
                  );
                  }else{
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileWorldAthletePage(testMode: true),
                    ),
                  );

                  }
                  
                },
                child: Text(
                  'Next Step',
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
