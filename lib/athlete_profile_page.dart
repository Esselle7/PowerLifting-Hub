import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'main.dart';

class AthleteProfilePage extends StatefulWidget {
  @override
  _AthleteProfilePageState createState() => _AthleteProfilePageState();
}

class _AthleteProfilePageState extends State<AthleteProfilePage> {
  String _category = 'Standard';
  bool _isMale = true;
  int _weightClassIndex = 0;
  bool _isAlsoPrep = false;
  double _squat = 0;
  double _benchPress = 0;
  double _deadlift = 0;
  double _dips = 0;
  String _level = 'Base';
  String _crew = '';
  String _preparatore = '';
  String _federation = '';

  List<String> _weightClasses = ['53', '59', '66', '74', '83', '93', '105', '120', '+120'];

  final List<String> _crewSuggestions = ['Crew1', 'Crew2', 'Crew3'];
  final List<String> _preparatoreSuggestions = ['Prep1', 'Prep2', 'Prep3'];
  final List<String> _federationSuggestions = ['Fed1', 'Fed2', 'Fed3'];

  List<String> _filteredCrewSuggestions = [];
  List<String> _filteredPreparatoreSuggestions = [];
  List<String> _filteredFederationSuggestions = [];

  void _saveProfile() {
    Map<String, dynamic> profile = {
      'category': _category,
      'sex': _isMale ? 'M' : 'F',
      'weightClass': _weightClasses[_weightClassIndex],
      'squat': _squat,
      'benchPress': _benchPress,
      'deadlift': _deadlift,
      'dips': _dips,
      'level': _level,
      'crew': _crew,
      'preparatore': _preparatore,
      'federation': _federation,
      'isAlsoPrep': _isAlsoPrep,
    };

    writeProfile(profile);
  }

  void _updateLevel() {
    double total = _squat + _benchPress + _deadlift + _dips;
    if (total < 100) {
      _level = 'Base';
    } else if (total < 200) {
      _level = 'Medio';
    } else {
      _level = 'Avanzato';
    }
  }

  void _onCategoryChange(int index) {
    setState(() {
      if (index == 0) {
        _category = 'PowerLifter';
      } else if (index == 1) {
        _category = 'Street Lifter';
      } else {
        _category = 'Standard';
      }
    });
  }

  List<String> _getWeightClasses() {
    return _isMale
        ? ['53', '59', '66', '74', '83', '93', '105', '120', '+120']
        : ['-43', '47', '52', '57', '63', '72', '84', '+84'];
  }

  Widget _buildNumberInput(String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(
          width: 70,
          child: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              suffixText: 'Kg',
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            ),
            onChanged: (text) {
              double? newValue = double.tryParse(text);
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAutocompleteTextField(
      String labelText,
      List<String> suggestions,
      ValueChanged<String> onChanged,
      ValueChanged<String> onSuggestionSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(labelText: labelText),
          onChanged: (value) {
            setState(() {
              onChanged(value);
              if (value.isEmpty) {
                suggestions.clear();
              }
            });
          },
        ),
        if (suggestions.isNotEmpty)
          ListView(
            shrinkWrap: true,
            children: suggestions.map((suggestion) {
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  setState(() {
                    onSuggestionSelected(suggestion);
                    suggestions.clear();
                  });
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  void _filterCrewSuggestions(String query) {
    setState(() {
      _filteredCrewSuggestions = _crewSuggestions
          .where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _filterPreparatoreSuggestions(String query) {
    setState(() {
      _filteredPreparatoreSuggestions = _preparatoreSuggestions
          .where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _filterFederationSuggestions(String query) {
    setState(() {
      _filteredFederationSuggestions = _federationSuggestions
          .where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _weightClasses = _getWeightClasses(); 

    return Scaffold(
      appBar: AppBar(
        title: Text('Crea Profilo Atleta'),
        actions: [
          IconButton(
            icon: Icon(Icons.flag),
            onPressed: () {
              setState(() {
                _isAlsoPrep = !_isAlsoPrep;
              });
            },
          ),
          Center(
            child: Text(
              'Also Prep',
              style: TextStyle(
                color: _isAlsoPrep ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Sex: ', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _isMale,
                    onChanged: (value) {
                      setState(() {
                        _isMale = value;
                        _weightClassIndex = 0;
                      });
                    },
                    activeColor: Colors.blue,
                    inactiveThumbColor: Colors.pink,
                    inactiveTrackColor: Colors.pink.shade100,
                  ),
                  Text(_isMale ? 'M' : 'F', style: TextStyle(fontSize: 16)),
                ],
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    _onCategoryChange(index);
                  },
                ),
                items: ['assets/avatar_pl.png', 'assets/avatar_sl.png', 'assets/standard.png'].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.asset(i);
                    },
                  );
                }).toList(),
              ),
              Center(
                child: Text(
                  _category,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Weight Category: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 100,
                    height: 80, 
                    child: CupertinoPicker(
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _weightClassIndex = index;
                        });
                      },
                      children: _weightClasses.map((String value) {
                        return Center(child: Text('$value Kg'));
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildNumberInput('Squat', _squat, (value) {
                setState(() {
                  _squat = value;
                  _updateLevel();
                });
              }),
              SizedBox(height: 20),
              _buildNumberInput('Bench Press', _benchPress, (value) {
                setState(() {
                  _benchPress = value;
                  _updateLevel();
                });
              }),
              SizedBox(height: 20),
              _buildNumberInput('Deadlift', _deadlift, (value) {
                setState(() {
                  _deadlift = value;
                  _updateLevel();
                });
              }),
              SizedBox(height: 20),
              _buildNumberInput('Dips', _dips, (value) {
                setState(() {
                  _dips = value;
                  _updateLevel();
                });
              }),
              SizedBox(height: 20),
              _buildAutocompleteTextField(
                'Unirsi a una Crew',
                _filteredCrewSuggestions,
                (value) {
                  _crew = value;
                  _filterCrewSuggestions(value);
                },
                (suggestion) {
                  _crew = suggestion;
                },
              ),
              _buildAutocompleteTextField(
                'Inserisci Preparatore',
                _filteredPreparatoreSuggestions,
                (value) {
                  _preparatore = value;
                  _filterPreparatoreSuggestions(value);
                },
                (suggestion) {
                  _preparatore = suggestion;
                },
              ),
              _buildAutocompleteTextField(
                'Federazione',
                _filteredFederationSuggestions,
                (value) {
                  _federation = value;
                  _filterFederationSuggestions(value);
                },
                (suggestion) {
                  _federation = suggestion;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveProfile();
                    Navigator.pop(context);
                  },
                  child: Text('Salva Profilo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
