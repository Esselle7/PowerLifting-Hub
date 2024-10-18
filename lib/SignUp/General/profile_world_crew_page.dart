import 'package:flutter/material.dart';
import 'package:gym/Services/standardAppBar.dart';
import 'package:gym/Theme/responsive_button_style.dart';
import 'package:gym/Theme/responsive_text_box.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:gym/SignUp/General/profile_world_athlete_page.dart';
import 'package:gym/SignUp/General/profile_world_federation_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';

// Lista di test per le top 5 crew della provincia e della nazione in formato JSON
final List<Map<String, String>> provinceTopCrews = [
  {"name": "Crew A", "province": "Provincia", "nation": "Nazione"},
  {"name": "Crew B", "province": "Provincia", "nation": "Nazione"},
  {"name": "Crew C", "province": "Provincia", "nation": "Nazione"},
  {"name": "Crew D", "province": "Provincia", "nation": "Nazione"},
  {"name": "Crew E", "province": "Provincia", "nation": "Nazione"},
];

final List<Map<String, String>> nationTopCrews = [
  {"name": "Crew X", "province": "Provincia", "nation": "Nazione"},
  {"name": "Crew Y", "province": "Provincia", "nation": "Nazione"},
  {"name": "Crew Z", "province": "Provincia", "nation": "Nazione"},
  {"name": "Crew W", "province": "Provincia", "nation": "Nazione"},
  {"name": "Crew V", "province": "Provincia", "nation": "Nazione"},
];

// Simula la chiamata API per ottenere le top 5 crew
Future<List<Map<String, String>>> fetchTopCrews(String type, {required bool testMode}) async {
  if (testMode) {
    if (type == 'province') {
      return Future.delayed(const Duration(seconds: 1), () => provinceTopCrews);
    } else if (type == 'nation') {
      return Future.delayed(const Duration(seconds: 1), () => nationTopCrews);
    }
  } else {
    throw UnimplementedError('API call is not implemented.');
  }
  return [];
}

// Simula la chiamata API per ottenere le crew
Future<List<Map<String, String>>> fetchCrews({required bool testMode}) async {
  if (testMode) {
    return List.generate(
      30,
      (index) => {"name": "TestCrew $index", "province": "Provincia", "nation": "Nazione"},
    );
  } else {
    throw UnimplementedError('API call is not implemented.');
  }
}

class ProfileWorldCrewPage extends StatefulWidget {
  final bool testMode;

  const ProfileWorldCrewPage({super.key, required this.testMode});

  @override
  _ProfileWorldCrewPageState createState() => _ProfileWorldCrewPageState();
}

class _ProfileWorldCrewPageState extends State<ProfileWorldCrewPage> {
  final FocusNode _focusNode = FocusNode();

  late Future<List<Map<String, String>>> _provinceTopCrewsFuture;
  late Future<List<Map<String, String>>> _nationTopCrewsFuture;

  final Set<String> _selectedCrews = {};
  List<Map<String, String>> _filteredCrews = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _provinceTopCrewsFuture = fetchTopCrews('province', testMode: widget.testMode);
    _nationTopCrewsFuture = fetchTopCrews('nation', testMode: widget.testMode);
    _fetchCrews();
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
      _filteredCrews = _filteredCrews.where((crew) => crew['name']!.toLowerCase().startsWith(_searchQuery.toLowerCase())).toList();
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

  void _showBottomSheet(String title, Future<List<Map<String, String>>> crewFuture) {
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
                        future: crewFuture,
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
                                final crew = snapshot.data![index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(crew['name']![0], style: ResponsiveTextStyles.labelMedium(context)),
                                  ),
                                  title: Text(crew['name']!, style: ResponsiveTextStyles.labelMedium(context)),
                                  subtitle: Text('${crew['province']}, ${crew['nation']}', style: ResponsiveTextStyles.labelSmall(context)),
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
        appBar: StandardAppBar(title: "Cerca Crews"),
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            children: [
              CustomTextField(labelText: "Inserisci nome crew", icon: Icons.search, onChanged: _updateSearchQuery),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? _filteredCrews.isEmpty
                        ? Center(
                            child: Text(
                              'Nessuna crew trovata',
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
                            itemCount: _filteredCrews.length,
                            itemBuilder: (context, index) {
                              final crew = _filteredCrews[index];
                              final isSelected = _selectedCrews.contains(crew['name']);
                              return GestureDetector(
                                onTap: () => _toggleSelection(crew['name']!),
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
                                      crew['name']!,
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
              // Pulsante per Top 5 Crew della Provincia
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Top 5 Crew della Provincia',
                onPressed: () => _showBottomSheet('Top 5 Crew della Provincia', _provinceTopCrewsFuture),
                icon: Icons.star,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Pulsante per Top 5 Crew della Nazione
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Top 5 Crew della Nazione',
                onPressed: () => _showBottomSheet('Top 5 Crew della Nazione', _nationTopCrewsFuture),
                icon: Icons.flag,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Pulsante per il passo successivo
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Next Step',
                onPressed: () {
                  final userProfile = Provider.of<UserProfile>(context, listen: false);
                  userProfile.updateWorldCrews(crews: _selectedCrews.toList());
                  if (userProfile.isAthlete || userProfile.isBoth) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileWorldFederationPage(testMode: true),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileWorldAthletePage(testMode: true),
                      ),
                    );
                  }
                },
                icon: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
