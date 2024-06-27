import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gym/user_profile_state.dart';
import 'package:provider/provider.dart';
import 'athlete_profile_world_page.dart';

class AthleteProfilePage extends StatefulWidget {
  @override
  _AthleteProfilePageState createState() => _AthleteProfilePageState();
}

class _AthleteProfilePageState extends State<AthleteProfilePage> {
  final FocusNode _squatFocusNode = FocusNode();
  final FocusNode _benchPressFocusNode = FocusNode();
  final FocusNode _deadliftFocusNode = FocusNode();
  final FocusNode _dipsFocusNode = FocusNode();

  List<String> _weightClasses = ['53', '59', '66', '74', '83', '93', '105', '120', '+120'];

  void _updateLevel(double squat, double benchPress, double deadlift, double dips) {
    double total = squat + benchPress + deadlift + dips;
    if (total < 100) {
      context.read<UserProfile>().level = 'Base';
    } else if (total < 200) {
      context.read<UserProfile>().level = 'Medio';
    } else {
      context.read<UserProfile>().level = 'Avanzato';
    }
    context.read<UserProfile>().notifyListeners();
  }

  void _onCategoryChange(int index) {
    setState(() {
      if (index == 0) {
        context.read<UserProfile>().category = 'PowerLifter';
      } else if (index == 1) {
        context.read<UserProfile>().category = 'Street Lifter';
      } else {
        context.read<UserProfile>().category = 'Standard';
      }
      context.read<UserProfile>().notifyListeners();
    });
  }

  List<String> _getWeightClasses() {
    return context.read<UserProfile>().isMale
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
    final userProfile = context.watch<UserProfile>();
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
                  userProfile.isAlsoPrep = !userProfile.isAlsoPrep;
                });
              },
            ),
            Center(
              child: Text(
                'Also Prep',
                style: TextStyle(
                  color: userProfile.isAlsoPrep ? Colors.green : Colors.red,
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
                      value: userProfile.isMale,
                      onChanged: (value) {
                        setState(() {
                          userProfile.isMale = value;
                          userProfile.weightClass = _weightClasses[0]; // Reset to first weight class
                        });
                      },
                      activeColor: Colors.blue,
                      inactiveThumbColor: Colors.pink,
                      inactiveTrackColor: Colors.pink.shade100,
                    ),
                    Text(userProfile.isMale ? 'M' : 'F', style: TextStyle(fontSize: 16)),
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
                    if (userProfile.isMale)
                      'assets/avatar_m_pl.png',
                    if (userProfile.isMale)
                      'assets/avatar_m_sl.png',
                    if (userProfile.isMale)
                      'assets/avatar_m_s.jpg',
                    if (!userProfile.isMale)
                      'assets/avatar_w_pl.jpeg',
                    if (!userProfile.isMale)
                      'assets/avatar_w_sl.png',
                    if (!userProfile.isMale)
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
                    userProfile.category,
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
                            userProfile.weightClass = _weightClasses[index];
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
                _buildNumberInput('Squat', userProfile.squat, (value) {
                  setState(() {
                    userProfile.squat = value;
                    _updateLevel(userProfile.squat, userProfile.benchPress, userProfile.deadlift, userProfile.dips);
                  });
                }, _squatFocusNode),
                SizedBox(height: 20),
                _buildNumberInput('Bench Press', userProfile.benchPress, (value) {
                  setState(() {
                    userProfile.benchPress = value;
                    _updateLevel(userProfile.squat, userProfile.benchPress, userProfile.deadlift, userProfile.dips);
                  });
                }, _benchPressFocusNode),
                SizedBox(height: 20),
                _buildNumberInput('Deadlift', userProfile.deadlift, (value) {
                  setState(() {
                    userProfile.deadlift = value;
                    _updateLevel(userProfile.squat, userProfile.benchPress, userProfile.deadlift, userProfile.dips);
                  });
                }, _deadliftFocusNode),
                SizedBox(height: 20),
                _buildNumberInput('Dips', userProfile.dips, (value) {
                  setState(() {
                    userProfile.dips = value;
                    _updateLevel(userProfile.squat, userProfile.benchPress, userProfile.deadlift, userProfile.dips);
                  });
                }, _dipsFocusNode),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _unfocusAllTextFields(); // Rimuovi il focus dai TextField
                      Provider.of<UserProfile>(context, listen: false).updateAthleteProfile(
                        category: userProfile.category,
                        isMale: userProfile.isMale,
                        weightClass: userProfile.weightClass,
                        isAlsoPrep: userProfile.isAlsoPrep,
                        squat: userProfile.squat,
                        benchPress: userProfile.benchPress,
                        deadlift: userProfile.deadlift,
                        dips: userProfile.dips,
                        level: userProfile.level,
                        crew: userProfile.crew,
                        preparatore: userProfile.preparatore,
                        federation: userProfile.federation,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AthleteProfileWorldPage(
                            category: userProfile.category,
                            isMale: userProfile.isMale,
                            weightClass: userProfile.weightClass,
                            isAlsoPrep: userProfile.isAlsoPrep,
                            squat: userProfile.squat,
                            benchPress: userProfile.benchPress,
                            deadlift: userProfile.deadlift,
                            dips: userProfile.dips,
                            level: userProfile.level,
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
