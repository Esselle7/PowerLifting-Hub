import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym/SignUp/General/profile_world_crew_page.dart';
import 'package:intl/intl.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:provider/provider.dart';
import 'package:gym/Theme/responsive_button_style.dart'; // Importa il file per i bottoni

class AthleteProfilePage extends StatefulWidget {
  final bool isBoth;

  const AthleteProfilePage({super.key, required this.isBoth});

  @override
  _AthleteProfilePageState createState() => _AthleteProfilePageState();
}

class _AthleteProfilePageState extends State<AthleteProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfile>().category = 'POWERLIFTER';
  }

  final FocusNode _squatFocusNode = FocusNode();
  final FocusNode _benchPressFocusNode = FocusNode();
  final FocusNode _deadliftFocusNode = FocusNode();
  final FocusNode _dipsFocusNode = FocusNode();

  final FocusNode _squatDateFocusNode = FocusNode();
  final FocusNode _benchPressDateFocusNode = FocusNode();
  final FocusNode _deadliftDateFocusNode = FocusNode();
  final FocusNode _dipsDateFocusNode = FocusNode();

  final TextEditingController _squatDateController = TextEditingController();
  final TextEditingController _benchPressDateController = TextEditingController();
  final TextEditingController _deadliftDateController = TextEditingController();
  final TextEditingController _dipsDateController = TextEditingController();

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
        context.read<UserProfile>().category = 'POWERLIFTER';
      } else if (index == 1) {
        context.read<UserProfile>().category = 'STREETLIFTER';
      } else {
        context.read<UserProfile>().category = 'IBRIDO';
      }
      context.read<UserProfile>().notifyListeners();
    });
  }

  List<String> _getWeightClasses() {
    return context.read<UserProfile>().isMale
        ? ['53', '59', '66', '74', '83', '93', '105', '120', '+120']
        : ['-43', '47', '52', '57', '63', '72', '84', '+84'];
  }

  Widget _buildNumberInput(String label, double value, ValueChanged<double> onChanged, FocusNode focusNode, TextEditingController dateController, FocusNode dateFocusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.innerbox,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextField(
              focusNode: focusNode,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blue, 
                    width: 3.0, 
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).primaryColor, 
                suffixText: 'Kg',
                labelText: 'Inserisci',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                suffixStyle: const TextStyle(color: Colors.blueAccent),
              ),
              onChanged: (text) {
                double? newValue = double.tryParse(text);
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              controller: dateController,
              focusNode: dateFocusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).primaryColor,
                labelText: 'Inserisci Data',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _unfocusAllTextFields() {
    _squatFocusNode.unfocus();
    _benchPressFocusNode.unfocus();
    _deadliftFocusNode.unfocus();
    _dipsFocusNode.unfocus();
    _squatDateFocusNode.unfocus();
    _benchPressDateFocusNode.unfocus();
    _deadliftDateFocusNode.unfocus();
    _dipsDateFocusNode.unfocus();
  }

  @override
  void dispose() {
    _squatFocusNode.dispose();
    _benchPressFocusNode.dispose();
    _deadliftFocusNode.dispose();
    _dipsFocusNode.dispose();
    _squatDateFocusNode.dispose();
    _benchPressDateFocusNode.dispose();
    _deadliftDateFocusNode.dispose();
    _dipsDateFocusNode.dispose();
    _squatDateController.dispose();
    _benchPressDateController.dispose();
    _deadliftDateController.dispose();
    _dipsDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>();
    _weightClasses = _getWeightClasses();
    setState(() {
      userProfile.isMale = userProfile.isMale;
      userProfile.weightClass = _weightClasses[0];
    });

    return GestureDetector(
      onTap: () {
        _unfocusAllTextFields();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crea Profilo Atleta'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              userProfile.reset();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.23,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      _onCategoryChange(index);
                    },
                  ),
                  items: [
                    if (userProfile.isMale) 'assets/avatar_m_pl.png',
                    if (userProfile.isMale) 'assets/avatar_m_sl.png',
                    if (userProfile.isMale) 'assets/avatar_m_s.jpg',
                    if (!userProfile.isMale) 'assets/avatar_w_pl.jpeg',
                    if (!userProfile.isMale) 'assets/avatar_w_sl.png',
                    if (!userProfile.isMale) 'assets/avatar_w_s.jpeg',
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            i,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Center(
                  child: Text(
                    userProfile.category,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Categoria Peso', style: Theme.of(context).textTheme.innerbox),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: CupertinoPicker(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            userProfile.weightClass = _weightClasses[index];
                          });
                        },
                        children: _weightClasses.map((String value) {
                          return Text(value, style: const TextStyle(color: Colors.blueAccent));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _buildNumberInput('Squat', userProfile.squat, (value) {
                  setState(() {
                    userProfile.squat = value;
                    _updateLevel(userProfile.squat, userProfile.benchPress, userProfile.deadlift, userProfile.dips);
                  });
                }, _squatFocusNode, _squatDateController, _squatDateFocusNode),
                _buildNumberInput('Panca  Piana', userProfile.benchPress, (value) {
                  setState(() {
                    userProfile.benchPress = value;
                    _updateLevel(userProfile.squat, userProfile.benchPress, userProfile.deadlift, userProfile.dips);
                  });
                }, _benchPressFocusNode, _benchPressDateController, _benchPressDateFocusNode),
                _buildNumberInput('Stacco da terra', userProfile.deadlift, (value) {
                  setState(() {
                    userProfile.deadlift = value;
                    _updateLevel(userProfile.squat, userProfile.benchPress, userProfile.deadlift, userProfile.dips);
                  });
                }, _deadliftFocusNode, _deadliftDateController, _deadliftDateFocusNode),
                /*_buildNumberInput('Dips', userProfile.dips, (value) {
                  setState(() {
                    userProfile.dips = value;
                    _updateLevel(userProfile.squat, userProfile.benchPress, userProfile.deadlift, userProfile.dips);
                  });
                }, _dipsFocusNode, _dipsDateController, _dipsDateFocusNode),*/
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Center(
                  child: ResponsiveButtonStyle.mediumButton(
                    context: context,
                    buttonText: 'Continua',
                    icon: Icons.navigate_next, // Aggiungi un'icona per "Continua"
                    onPressed: () {
                      _unfocusAllTextFields();
                      bool isAthlete = !widget.isBoth;
                      Provider.of<UserProfile>(context, listen: false).updateAthleteProfile(
                        category: userProfile.category,
                        isMale: userProfile.isMale,
                        weightClass: userProfile.weightClass,
                        isAlsoPrep: userProfile.isAlsoPrep,
                        squat: userProfile.squat,
                        squatDate: _parseDate(_squatDateController.text) ?? DateTime.now(),
                        benchPress: userProfile.benchPress,
                        bpDate: _parseDate(_benchPressDateController.text) ?? DateTime.now(),
                        deadlift: userProfile.deadlift,
                        dlDate: _parseDate(_deadliftDateController.text) ?? DateTime.now(),
                        dips: userProfile.dips,
                        //dipsDate: _parseDate(_dipsDateController.text) ?? DateTime.now(),
                        level: userProfile.level,
                        isAthlete: isAthlete,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileWorldCrewPage(testMode: true,),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime? _parseDate(String date) {
    try {
      return DateFormat('dd/MM/yyyy').parse(date);
    } catch (e) {
      return null;
    }
  }
}
