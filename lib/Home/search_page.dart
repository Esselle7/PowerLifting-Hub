import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym/Services/homeAppBar.dart';
import 'package:gym/Theme/responsive_box_item.dart';
import 'package:provider/provider.dart';
import 'package:gym/Services/network_services.dart';
import 'package:gym/Theme/responsive_text_box.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:gym/SignUp/user_profile_state.dart';

// Dati di esempio in formato JSON per coach, atleti e crew
final List<Map<String, dynamic>> data = [
  {
    "name": "Coach A", 
    "type": "Coach", 
    "info": "Esperienza di 10 anni, specializzato in bodybuilding."
  },
  {
    "name": "Atleta B", 
    "type": "Atleta", 
    "info": "Campione regionale di sollevamento pesi."
  },
  {
    "name": "Crew C", 
    "type": "Crew", 
    "info": "Responsabile della gestione degli eventi sportivi."
  },
  {
    "name": "Coach D", 
    "type": "Coach", 
    "info": "Esperienza di 5 anni, specializzato in powerlifting."
  },
  {
    "name": "Atleta E", 
    "type": "Atleta", 
    "info": "Partecipante alle Olimpiadi del 2020."
  },
  {
    "name": "Crew F", 
    "type": "Crew", 
    "info": "Coordinatore delle attività di allenamento."
  },
  {
    "name": "Coach G", 
    "type": "Coach", 
    "info": "Specialista in allenamento funzionale."
  },
  {
    "name": "Atleta H", 
    "type": "Atleta", 
    "info": "Medaglia d'oro ai campionati nazionali."
  },
  {
    "name": "Crew I", 
    "type": "Crew", 
    "info": "Gestione delle attrezzature e del team tecnico."
  },
];

// Simula la chiamata API per ottenere i dati
Future<List<Map<String, dynamic>>> fetchData({required bool testMode}) async {
  if (testMode) {
    return Future.delayed(const Duration(seconds: 1), () => data);
  } else {
    throw UnimplementedError('API call is not implemented.');
  }
}

class SearchPage extends StatefulWidget {
  final bool testMode;

  const SearchPage({super.key, required this.testMode});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> _filteredResults = [];
  String _searchQuery = '';
  final NetworkService networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final results = await fetchData(testMode: widget.testMode);
    setState(() {
      _filteredResults = results;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredResults = data
          .where((item) => item['name']!.toLowerCase().startsWith(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Coach':
        return Icons.fitness_center; // Icona per Coach
      case 'Atleta':
        return Icons.sports; // Icona per Atleta
      case 'Crew':
        return Icons.group; // Icona per Crew
      default:
        return Icons.person;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Coach':
        return Colors.orange; // Colore per Coach
      case 'Atleta':
        return Colors.green; // Colore per Atleta
      case 'Crew':
        return Colors.blue; // Colore per Crew
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: HomeAppBar(title: "Ricerca Generale"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              labelText: "Inserisci nome Coach", 
              icon: Icons.search, 
              onChanged: _updateSearchQuery,
            ),
            SizedBox(height: screenHeight * 0.015),
            Expanded(
              child: _filteredResults.isEmpty
                  ? const Center(child: Text('Nessun risultato trovato'))
                  : ListView.builder(
                      itemCount: _filteredResults.length,
                      itemBuilder: (context, index) {
                        final result = _filteredResults[index];
                        return ItemBox(
                          title: result['name']!, 
                          description: result['info']!, // Dettagli aggiuntivi
                          icon: _getIconForType(result['type']!), // Icona in base al tipo
                          iconColor: _getColorForType(result['type']!), // Colore in base al tipo
                          label: result['type']!, // Etichetta per il tipo
                          onTap: () {
                            // Aggiungi l'azione che vuoi quando clicchi su un risultato
                            print('Cliccato su ${result['name']}');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
