import 'package:flutter/material.dart';
import 'package:gym/Services/standardAppBar.dart';
import 'package:gym/SignUp/General/profile_world_athlete_page.dart';
import 'package:gym/SignUp/General/profile_world_coach_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:gym/Theme/responsive_button_style.dart';
import 'package:gym/Theme/responsive_text_box.dart';
import 'package:provider/provider.dart';

// Lista di test per i top 5 federazioni della provincia e della nazione in formato JSON
final List<Map<String, String>> provinceTopFederations = [
  {"name": "Federation A", "province": "Provincia", "nation": "Nazione"},
  {"name": "Federation B", "province": "Provincia", "nation": "Nazione"},
  {"name": "Federation C", "province": "Provincia", "nation": "Nazione"},
  {"name": "Federation D", "province": "Provincia", "nation": "Nazione"},
  {"name": "Federation E", "province": "Provincia", "nation": "Nazione"},
];

final List<Map<String, String>> nationTopFederations = [
  {"name": "Federation X", "province": "Provincia", "nation": "Nazione"},
  {"name": "Federation Y", "province": "Provincia", "nation": "Nazione"},
  {"name": "Federation Z", "province": "Provincia", "nation": "Nazione"},
  {"name": "Federation W", "province": "Provincia", "nation": "Nazione"},
  {"name": "Federation V", "province": "Provincia", "nation": "Nazione"},
];

// Simula la chiamata API per ottenere i top 5 federazioni
Future<List<Map<String, String>>> fetchTopFederations(String type, {required bool testMode}) async {
  if (testMode) {
    if (type == 'province') {
      return Future.delayed(const Duration(seconds: 1), () => provinceTopFederations);
    } else if (type == 'nation') {
      return Future.delayed(const Duration(seconds: 1), () => nationTopFederations);
    }
  } else {
    throw UnimplementedError('API call is not implemented.');
  }
  return [];
}

// Simula la chiamata API per ottenere le federazioni
Future<List<Map<String, String>>> fetchFederations({required bool testMode}) async {
  if (testMode) {
    return List.generate(
      30,
      (index) => {"name": "TestFederation $index", "province": "Provincia", "nation": "Nazione"},
    );
  } else {
    throw UnimplementedError('API call is not implemented.');
  }
}

class ProfileWorldFederationPage extends StatefulWidget {
  final bool testMode;

  const ProfileWorldFederationPage({super.key, required this.testMode});

  @override
  _ProfileWorldFederationPageState createState() => _ProfileWorldFederationPageState();
}

class _ProfileWorldFederationPageState extends State<ProfileWorldFederationPage> {
  final FocusNode _focusNode = FocusNode();

  late Future<List<Map<String, String>>> _provinceTopFederationsFuture;
  late Future<List<Map<String, String>>> _nationTopFederationsFuture;

  Map<String, String>? _selectedFederation;
  List<Map<String, String>> _filteredFederations = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _provinceTopFederationsFuture = fetchTopFederations('province', testMode: widget.testMode);
    _nationTopFederationsFuture = fetchTopFederations('nation', testMode: widget.testMode);
    _fetchFederations();
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
          .where((federation) => federation['name']!.toLowerCase().startsWith(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _selectFederation(Map<String, String> federation) {
    setState(() {
      _selectedFederation = federation;
    });
  }

  void _showBottomSheet(String title, Future<List<Map<String, String>>> federationFuture) {
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
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Expanded(
                      child: FutureBuilder<List<Map<String, String>>>(
                        future: federationFuture,
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
                                final federation = snapshot.data![index];
                                final isSelected = _selectedFederation == federation;
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                                  leading: CircleAvatar(
                                    backgroundColor: isSelected ? Colors.green : Colors.blue,
                                    child: Text(federation['name']![0], style: const TextStyle(color: Colors.blueAccent)),
                                  ),
                                  title: Text(federation['name']!, style: const TextStyle(color: Colors.blueAccent)),
                                  subtitle: Text('${federation['province']}, ${federation['nation']}', style: const TextStyle(color: Colors.blueAccent)),
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
        appBar: StandardAppBar(title: "Cerca Federazione"),
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            children: [
              CustomTextField(labelText: "Inserisci nome federazione", icon: Icons.search, onChanged: _updateSearchQuery),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _filteredFederations.isEmpty
                        ? const Center(
                            child: Text(
                              'Nessuna federazione trovata',
                              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
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
                                      federation['name']!,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Top 5 Federazioni della Provincia',
                onPressed: () => _showBottomSheet('Top 5 Federazioni della Provincia', _provinceTopFederationsFuture),
                icon: Icons.star,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Top 5 Federazioni della Nazione',
                onPressed: () => _showBottomSheet('Top 5 Federazioni della Nazione', _nationTopFederationsFuture),
                icon: Icons.star,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Next Step',
                icon: Icons.navigate_next,
                onPressed: () {
                  final userProfile = Provider.of<UserProfile>(context, listen: false);
                  userProfile.updateWorldFederation(federation: _selectedFederation?['name'] ?? "");
                  if (userProfile.isBoth) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileWorldAthletePage(testMode: true),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileWorldCoachPage(testMode: true),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
