import 'package:flutter/material.dart';

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

// Modello per i dati delle persone
class Person {
  final String name;
  final Color color;

  Person({required this.name, required this.color});
}

// Esempio di dati per i cerchietti
final List<Person> persons = List.generate(
  12,
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
  late Future<List<Crew>> _provinceTopCrewsFuture;
  late Future<List<Crew>> _nationTopCrewsFuture;

  // Stato per tenere traccia della selezione dei cerchietti
  Set<int> _selectedPersons = {}; // Usa un Set per evitare duplicati

  @override
  void initState() {
    super.initState();
    _provinceTopCrewsFuture = fetchTopCrews('province', testMode: widget.testMode);
    _nationTopCrewsFuture = fetchTopCrews('nation', testMode: widget.testMode);
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedPersons.contains(index)) {
        _selectedPersons.remove(index);
      } else {
        _selectedPersons.add(index);
      }
    });
  }

  void _showBottomSheet(String title, Future<List<Crew>> crewFuture) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
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
                color: Colors.black87,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cerca Persone'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cerca per nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Persone',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ),
                // Lista di cerchietti delle persone
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedPersons.contains(index);
                    return GestureDetector(
                      onTap: () => _toggleSelection(index),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                width: 40, // Dimensione cerchietto
                                height: 40, // Dimensione cerchietto
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.green : persons[index].color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.green : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    persons[index].name[0],
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  bottom: -5,
                                  left: -5,
                                  child: Icon(
                                    Icons.check,
                                    size: 20,
                                    color:  Colors.blueAccent,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 4), // Spazio tra cerchietto e nome
                          Text(
                            persons[index].name,
                            style: Theme.of(context).textTheme.innerbox,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                // Pulsante per Top 5 Crew della Provincia
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Colore di sfondo
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
                ),
                SizedBox(height: 20),
                // Pulsante per Top 5 Crew della Nazione
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Colore di sfondo
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileWorldCrewPage(testMode: true), // Imposta testMode a true o false
  ));
}
