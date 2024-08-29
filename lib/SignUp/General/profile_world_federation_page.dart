import 'package:flutter/material.dart';
import 'package:gym/SignUp/General/profile_world_athlete_page.dart';
import 'package:gym/SignUp/General/profile_world_coach_page.dart';
import 'package:gym/SignUp/General/profile_world_federation_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:provider/provider.dart';

// Modello per i dati delle federazioni
class Federation {
  final String name;
  final String province;
  final String nation;

  Federation({required this.name, required this.province, required this.nation});
}

// Lista di test per i top 5 federazioni della provincia e della nazione
final List<Federation> provinceTopFederations = [
  Federation(name: 'Federation A', province: 'Provincia', nation: 'Nazione'),
  Federation(name: 'Federation B', province: 'Provincia', nation: 'Nazione'),
  Federation(name: 'Federation C', province: 'Provincia', nation: 'Nazione'),
  Federation(name: 'Federation D', province: 'Provincia', nation: 'Nazione'),
  Federation(name: 'Federation E', province: 'Provincia', nation: 'Nazione'),
];

final List<Federation> nationTopFederations = [
  Federation(name: 'Federation X', province: 'Provincia', nation: 'Nazione'),
  Federation(name: 'Federation Y', province: 'Provincia', nation: 'Nazione'),
  Federation(name: 'Federation Z', province: 'Provincia', nation: 'Nazione'),
  Federation(name: 'Federation W', province: 'Provincia', nation: 'Nazione'),
  Federation(name: 'Federation V', province: 'Provincia', nation: 'Nazione'),
];

// Simula la chiamata API per ottenere i top 5 federazioni
Future<List<Federation>> fetchTopFederations(String type, {required bool testMode}) async {
  if (testMode) {
    if (type == 'province') {
      return Future.delayed(Duration(seconds: 1), () => provinceTopFederations);
    } else if (type == 'nation') {
      return Future.delayed(Duration(seconds: 1), () => nationTopFederations);
    }
  } else {
    // Inserisci la logica della chiamata API per ottenere i dati reali
    throw UnimplementedError('API call is not implemented.');
  }
  return [];
}

// Simula la chiamata API per ottenere le federazioni
Future<List<Federation>> fetchFederations({required bool testMode}) async {
  if (testMode) {
    // Lista di federazioni di test
    return List.generate(
      30,
      (index) => Federation(name: 'TestFederation $index', province: 'Provincia', nation: 'Nazione'),
    );
  } else {
    // Inserisci la logica della chiamata API per ottenere i dati reali
    throw UnimplementedError('API call is not implemented.');
  }
}

class ProfileWorldFederationPage extends StatefulWidget {
  final bool testMode;

  ProfileWorldFederationPage({required this.testMode});

  @override
  _ProfileWorldFederationPageState createState() => _ProfileWorldFederationPageState();
}

class _ProfileWorldFederationPageState extends State<ProfileWorldFederationPage> {
  final FocusNode _focusNode = FocusNode(); // FocusNode per il TextField

  late Future<List<Federation>> _provinceTopFederationsFuture;
  late Future<List<Federation>> _nationTopFederationsFuture;

  Federation? _selectedFederation; // Stato per tenere traccia della federazione selezionata
  List<Federation> _filteredFederations = []; // Lista delle federazioni filtrate in base alla ricerca
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _provinceTopFederationsFuture = fetchTopFederations('province', testMode: widget.testMode);
    _nationTopFederationsFuture = fetchTopFederations('nation', testMode: widget.testMode);
    _fetchFederations(); // Ottiene le federazioni iniziali
  }

  Future<void> _fetchFederations() async {
    final federations = await fetchFederations(testMode: widget.testMode);
    setState(() {
      _filteredFederations = federations;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredFederations = _filteredFederations
          .where((federation) => federation.name.toLowerCase().startsWith(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _selectFederation(Federation federation) {
    setState(() {
      _selectedFederation = federation;
    });
  }

  void _showBottomSheet(String title, Future<List<Federation>> federationFuture) {
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
                      child: FutureBuilder<List<Federation>>(
                        future: federationFuture,
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
                                final federation = snapshot.data![index];
                                final isSelected = _selectedFederation == federation;
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                  leading: CircleAvatar(
                                    backgroundColor: isSelected ? Colors.green : Colors.blue, // Colore fittizio per i cerchietti delle federazioni
                                    child: Text(federation.name[0], style: TextStyle(color: Colors.blueAccent)),
                                  ),
                                  title: Text(federation.name, style: TextStyle(color: Colors.blueAccent)),
                                  subtitle: Text('${federation.province}, ${federation.nation}', style: TextStyle(color: Colors.blueAccent)),
                                  onTap: () => _selectFederation(federation),
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
          title: Text('Cerca Federazione'),
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
                decoration: InputDecoration(
                  labelText: 'Digita il nome della tua federazione',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                ),
              ),
              SizedBox(height: 16.0),
              // Sezione per le federazioni filtrate
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _filteredFederations.isEmpty
                        ? Center(
                            child: Text(
                              'Nessuna federazione trovata',
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
                            itemCount: _filteredFederations.length > 16 ? 16 : _filteredFederations.length,
                            itemBuilder: (context, index) {
                              final federation = _filteredFederations[index];
                              final isSelected = _selectedFederation == federation;
                              return GestureDetector(
                                onTap: () => _selectFederation(federation),
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
                                      federation.name,
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
              // Pulsante per Top 5 Federazioni della Provincia
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                onPressed: () => _showBottomSheet('Top 5 Federazioni della Provincia', _provinceTopFederationsFuture),
                child: Text(
                  'Top 5 Federazioni della Provincia',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Pulsante per Top 5 Federazioni della Nazione
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                onPressed: () => _showBottomSheet('Top 5 Federazioni della Nazione', _nationTopFederationsFuture),
                child: Text(
                  'Top 5 Federazioni della Nazione',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Pulsante per il passo successivo
              ElevatedButton(
                onPressed: () {
                  final userProfile = Provider.of<UserProfile>(context, listen: false);
                  userProfile.updateWorldFederation(federation: _selectedFederation?.name ?? "");
                  if(userProfile.isBoth){
                     Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileWorldAthletePage(testMode: true),
                    ),
                  );
                  }
                  else{
                     Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileWorldCoachPage(testMode: true),
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
