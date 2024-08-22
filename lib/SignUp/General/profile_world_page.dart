import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym/Home/home_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfileWorldPage extends StatefulWidget {
  @override
  _ProfileWorldPageState createState() => _ProfileWorldPageState();
}

class _ProfileWorldPageState extends State<ProfileWorldPage> {
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
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.blueAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            ),
          ),
          onChanged: (value) {
            setState(() {
              onChanged(value);
            });
          },
        ),
        if (showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              color:  Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
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
    final userProfile = Provider.of<UserProfile>(context, listen: false);

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
          //'crews': _crewController.text,
        },
        'atleta': {
          'federazione': _federationController.text,
          //'tipologia': userProfile.category, // fixme
          'tipologia': "POWERLIFTER",
          
          'trainer': _preparatoreController.text,
          'weightClass': userProfile.weightClass,
        },
        'massimali': [
          {
            'alzata': "SQUAT",
            // inserire data
            'peso': userProfile.squat,
          },
          {
            'alzata': "PANCA_PIANA",
            // inserire data
            'peso': userProfile.benchPress,
          },
          {
            'alzata': "STACCO_DA_TERRA",
            // inserire data
            'peso': userProfile.deadlift,
          }
          //elimina dips
        ]
      };
    } else if (userProfile.isAthlete){
      profile = {
        'utente': {
          'nome': userProfile.firstName,
          'cognome': userProfile.lastName,
          'username': userProfile.username,
          'dob': userProfile.dob.toIso8601String(),
          'password': userProfile.password,
          'mail': userProfile.email,
          'sesso': userProfile.isMale,
          //'crews': _crewController.text,
        },
        'atleta': {
          'federazione': _federationController.text,
          //'tipologia': userProfile.category, // fixme
          'tipologia': "POWERLIFTER",
          
          'trainer': _preparatoreController.text,
          'weightClass': userProfile.weightClass,
        },
        'trainer': {
          'skillSpecifiche': userProfile.coachSkills,
          'titoli': userProfile.educationTitles,
          //'atleti': da inserire
        },
        'massimali': [
          {
            'alzata': "SQUAT",
            // inserire data
            'peso': userProfile.squat,
          },
          {
            'alzata': "PANCA_PIANA",
            // inserire data
            'peso': userProfile.benchPress,
          },
          {
            'alzata': "STACCO_DA_TERRA",
            // inserire data
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
          //'crews': _crewController.text,
        },
        'trainer': {
          'skillSpecifiche': userProfile.coachSkills,
          'titoli': userProfile.educationTitles,
          //'atleti': da inserire
        },
        'massimali': [
          {
            'alzata': "SQUAT",
            // inserire data
            'peso': userProfile.squat,
          },
          {
            'alzata': "PANCA_PIANA",
            // inserire data
            'peso': userProfile.benchPress,
          },
          {
            'alzata': "STACCO_DA_TERRA",
            // inserire data
            'peso': userProfile.deadlift,
          }
          //elimina dips
        ]
      };
    }

    String profileJson = jsonEncode(profile);
    //writeProfile(profile);
    sendData(profile);
    print(profileJson);
  }

 Future<String> sendData(Map<String, dynamic> json) async {
    final url = Uri.parse('http://192.168.1.17:8090/gym/registrazione');
    

    String jsonString = jsonEncode(json);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to send data');
    }
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
          title: Text('Informazioni Aggiuntive', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      _unfocusAllTextFields();
                      _saveProfile();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Text('Salva Profilo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
