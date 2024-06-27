import 'dart:convert'; // Per convertire la mappa in JSON
import 'package:flutter/material.dart';
import 'package:gym/main.dart';
import 'package:gym/user_profile_state.dart';
import 'package:provider/provider.dart';

class AthleteProfileWorldPage extends StatefulWidget {
  final String category;
  final bool isMale;
  final String weightClass;
  final bool isAlsoPrep;
  final double squat;
  final double benchPress;
  final double deadlift;
  final double dips;
  final String level;

  AthleteProfileWorldPage({
    required this.category,
    required this.isMale,
    required this.weightClass,
    required this.isAlsoPrep,
    required this.squat,
    required this.benchPress,
    required this.deadlift,
    required this.dips,
    required this.level,
  });

  @override
  _AthleteProfileWorldPageState createState() => _AthleteProfileWorldPageState();
}

class _AthleteProfileWorldPageState extends State<AthleteProfileWorldPage> {
  final List<String> _crewSuggestions = ['Cava', 'Cavallasca', 'San Fermo', 'Como'];
  final List<String> _preparatoreSuggestions = ['Simone', 'Francesco', 'Franci', 'Simo'];
  final List<String> _federationSuggestions = ['Fed1', 'Fed2', 'Fed3'];

  List<String> _filteredCrewSuggestions = [];
  List<String> _filteredPreparatoreSuggestions = [];
  List<String> _filteredFederationSuggestions = [];

  bool _showCrewSuggestions = false;
  bool _showPreparatoreSuggestions = false;
  bool _showFederationSuggestions = false;

  TextEditingController _crewController = TextEditingController();
  TextEditingController _preparatoreController = TextEditingController();
  TextEditingController _federationController = TextEditingController();

  FocusNode _crewFocusNode = FocusNode();
  FocusNode _preparatoreFocusNode = FocusNode();
  FocusNode _federationFocusNode = FocusNode();

  void _filterCrewSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCrewSuggestions = [];
        _showCrewSuggestions = false;
      } else {
        _filteredCrewSuggestions = _crewSuggestions
            .where((suggestion) => suggestion.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
        _showCrewSuggestions = _filteredCrewSuggestions.isNotEmpty;
      }
    });
  }

  void _filterPreparatoreSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPreparatoreSuggestions = [];
        _showPreparatoreSuggestions = false;
      } else {
        _filteredPreparatoreSuggestions = _preparatoreSuggestions
            .where((suggestion) => suggestion.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
        _showPreparatoreSuggestions = _filteredPreparatoreSuggestions.isNotEmpty;
      }
    });
  }

  void _filterFederationSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFederationSuggestions = [];
        _showFederationSuggestions = false;
      } else {
        _filteredFederationSuggestions = _federationSuggestions
            .where((suggestion) => suggestion.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
        _showFederationSuggestions = _filteredFederationSuggestions.isNotEmpty;
      }
    });
  }

  Widget _buildAutocompleteTextField(
      String labelText,
      TextEditingController controller,
      List<String> suggestions,
      ValueChanged<String> onChanged,
      bool showSuggestions,
      FocusNode focusNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(labelText: labelText),
          onChanged: (value) {
            setState(() {
              onChanged(value);
            });
          },
        ),
        if (showSuggestions)
          Container(
            height: 100,
            child: ListView(
              children: suggestions.map((suggestion) {
                return ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    _unfocusAllTextFields();
                    setState(() {
                      controller.text = suggestion;
                      _showCrewSuggestions = false;
                      _showPreparatoreSuggestions = false;
                      _showFederationSuggestions = false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _saveProfile() {
    // Assicurati di passare i dati tra le pagine come necessario
    final userProfile = Provider.of<UserProfile>(context, listen: false);
    Map<String, dynamic> profile = {
      'personalInfo': {
        'firstName': userProfile.firstName,
        'lastName': userProfile.lastName,
        'dob': userProfile.dob.toIso8601String(),
        'email': userProfile.email,
      },
      'athleteInfo': {
        'category': widget.category,
        'isMale': widget.isMale,
        'weightClass': widget.weightClass,
        'isAlsoPrep': widget.isAlsoPrep,
        'squat': widget.squat,
        'benchPress': widget.benchPress,
        'deadlift': widget.deadlift,
        'dips': widget.dips,
        'level': widget.level,
        'crew': _crewController.text,
        'preparatore': _preparatoreController.text,
        'federation': _federationController.text,
      },
    };

    if (widget.isAlsoPrep) {
      profile['trainerInfo'] = {
        // Aggiungi qui i dati del preparatore quando disponibili
      };
    }

    // Converti il profilo in JSON
    String profileJson = jsonEncode(profile);

    // Salva o mostra il profilo JSON (implementa la logica di salvataggio)
    writeProfile(profile);

    // Debug: stampa il JSON
    print(profileJson);
  }

  @override
  void dispose() {
    _crewController.dispose();
    _preparatoreController.dispose();
    _federationController.dispose();
    _crewFocusNode.dispose();
    _preparatoreFocusNode.dispose();
    _federationFocusNode.dispose();
    super.dispose();
  }

  void _unfocusAllTextFields() {
    _crewFocusNode.unfocus();
    _preparatoreFocusNode.unfocus();
    _federationFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          _showCrewSuggestions = false;
          _showPreparatoreSuggestions = false;
          _showFederationSuggestions = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Informazioni Aggiuntive'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAutocompleteTextField(
                  'Unirsi a una Crew',
                  _crewController,
                  _filteredCrewSuggestions,
                  (value) {
                    _filterCrewSuggestions(value);
                  },
                  _showCrewSuggestions,
                  _crewFocusNode,
                ),
                SizedBox(height: 20),
                _buildAutocompleteTextField(
                  'Inserisci Preparatore',
                  _preparatoreController,
                  _filteredPreparatoreSuggestions,
                  (value) {
                    _filterPreparatoreSuggestions(value);
                  },
                  _showPreparatoreSuggestions,
                  _preparatoreFocusNode,
                ),
                SizedBox(height: 20),
                _buildAutocompleteTextField(
                  'Federazione',
                  _federationController,
                  _filteredFederationSuggestions,
                  (value) {
                    _filterFederationSuggestions(value);
                  },
                  _showFederationSuggestions,
                  _federationFocusNode,
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _unfocusAllTextFields(); // Rimuovi il focus dai TextField
                      _saveProfile();
                      Navigator.pop(context);
                    },
                    child: Text('Salva Profilo'),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text('Torna Indietro'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
