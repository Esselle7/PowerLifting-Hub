import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gym/athlete_profile_world_page.dart';

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

  final FocusNode _squatFocusNode = FocusNode();
  final FocusNode _benchPressFocusNode = FocusNode();
  final FocusNode _deadliftFocusNode = FocusNode();
  final FocusNode _dipsFocusNode = FocusNode();

  List<String> _weightClasses = ['53', '59', '66', '74', '83', '93', '105', '120', '+120'];
  TextEditingController _crewController = TextEditingController();
  TextEditingController _preparatoreController = TextEditingController();
  TextEditingController _federationController = TextEditingController();

   void updateProfile({
    required String category,
    required bool isMale,
    required String weightClass,
    required bool isAlsoPrep,
    required double squat,
    required double benchPress,
    required double deadlift,
    required double dips,
    required String level,
    required String crew,
    required String preparatore,
    required String federation,
  }) {
    setState(() {
      _category = category;
      _isMale = isMale;
      _weightClassIndex = _weightClasses.indexOf(weightClass);
      _isAlsoPrep = isAlsoPrep;
      _squat = squat;
      _benchPress = benchPress;
      _deadlift = deadlift;
      _dips = dips;
      _level = level;

      _crewController.text = crew;
      _preparatoreController.text = preparatore;
      _federationController.text = federation;
    });
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

  Widget _buildNumberInput(String label, double value, ValueChanged<double> onChanged, FocusNode focusNode) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(
          width: 100,
          child: TextField(
            focusNode: focusNode,
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

  void _unfocusAllTextFields() {
    _squatFocusNode.unfocus();
    _benchPressFocusNode.unfocus();
    _deadliftFocusNode.unfocus();
    _dipsFocusNode.unfocus();
  }

  @override
  void dispose() {
    _squatFocusNode.dispose();
    _benchPressFocusNode.dispose();
    _deadliftFocusNode.dispose();
    _dipsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    //final athleteProfile = Provider.of<AthleteProfile>(context);
    _weightClasses = _getWeightClasses(); 
    return GestureDetector(
      onTap: () {
         _unfocusAllTextFields();
        //FocusScope.of(context).unfocus(); // Nasconde la tastiera
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                          _weightClassIndex = 0; // Reset to first weight class
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
                  items: [
                    if (_isMale)
                      'assets/avatar_m_pl.png',
                    if (_isMale)
                      'assets/avatar_m_sl.png',
                    if (_isMale)
                      'assets/avatar_m_s.jpg',
                    if (!_isMale)
                      'assets/avatar_w_pl.jpeg',
                    if (!_isMale)
                      'assets/avatar_w_sl.png',
                    if (!_isMale)
                      'assets/avatar_w_s.jpeg',
                  ].map((i) {
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Weight Category', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 10),
                    Container(
                      width: 100,
                      height: 60, // Decrease height of picker
                      child: CupertinoPicker(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _weightClassIndex = index;
                          });
                        },
                        children: _weightClasses.map((String value) {
                          return Text(value);
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
                }, _squatFocusNode),
                SizedBox(height: 20),
                _buildNumberInput('Bench Press', _benchPress, (value) {
                  setState(() {
                    _benchPress = value;
                    _updateLevel();
                  });
                }, _benchPressFocusNode),
                SizedBox(height: 20),
                _buildNumberInput('Deadlift', _deadlift, (value) {
                  setState(() {
                    _deadlift = value;
                    _updateLevel();
                  });
                }, _deadliftFocusNode),
                SizedBox(height: 20),
                _buildNumberInput('Dips', _dips, (value) {
                  setState(() {
                    _dips = value;
                    _updateLevel();
                  });
                }, _dipsFocusNode),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _unfocusAllTextFields(); // Rimuovi il focus dai TextField
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AthleteProfileWorldPage(
                            category: _category,
                            isMale: _isMale,
                            weightClass: _weightClasses[_weightClassIndex],
                            isAlsoPrep: _isAlsoPrep,
                            squat: _squat,
                            benchPress: _benchPress,
                            deadlift: _deadlift,
                            dips: _dips,
                            level: _level,
                          ),
                        ),
                      );
                    },
                    child: Text('Continua'),
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