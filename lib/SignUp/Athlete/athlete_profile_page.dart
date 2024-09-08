import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gym/SignUp/General/profile_world_crew_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:gym/Theme/responsive_button_style.dart';

class AthleteProfilePage extends StatefulWidget {
  final bool isBoth;

  const AthleteProfilePage({super.key, required this.isBoth});

  @override
  _AthleteProfilePageState createState() => _AthleteProfilePageState();
}

class _AthleteProfilePageState extends State<AthleteProfilePage> {
  // Text Controllers
  final Map<String, TextEditingController> _textControllers = {
    'squatDate': TextEditingController(),
    'benchPressDate': TextEditingController(),
    'deadliftDate': TextEditingController(),
    'dipsDate': TextEditingController(),
  };

  // Focus Nodes
  final Map<String, FocusNode> _focusNodes = {
    'squatValue': FocusNode(),
    'benchPressValue': FocusNode(),
    'deadliftValue': FocusNode(),
    'squatDate': FocusNode(),
    'benchPressDate': FocusNode(),
    'deadliftDate': FocusNode(),
    'dipsDate': FocusNode(),
  };

  @override
  void initState() {
    super.initState();
    context.read<UserProfile>().category = 'POWERLIFTER';

    // Add listeners to focus nodes
    _focusNodes.forEach((key, focusNode) {
      focusNode.addListener(() {
        setState(() {}); // Refresh to update border and label color
      });
    });
  }

  @override
  void dispose() {
    _textControllers.values.forEach((controller) => controller.dispose());
    _focusNodes.values.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void _updateLevel(UserProfile userProfile) {
    double total = userProfile.squat + userProfile.benchPress + userProfile.deadlift + userProfile.dips;
    userProfile.level = total < 100 ? 'Base' : total < 200 ? 'Medio' : 'Avanzato';
  }

  List<String> _getWeightClasses(bool isMale) {
    return isMale
        ? ['53', '59', '66', '74', '83', '93', '105', '120', '+120']
        : ['-43', '47', '52', '57', '63', '72', '84', '+84'];
  }

  Widget _buildNumberInput({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required TextEditingController dateController,
    required FocusNode valueFocusNode,
    required FocusNode dateFocusNode,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.015),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: ResponsiveTextStyles.labelMedium(context),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextField(
              focusNode: valueFocusNode,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: valueFocusNode.hasFocus ? Colors.blueAccent : Colors.grey, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: valueFocusNode.hasFocus ? Colors.blueAccent : Colors.grey, width: 2.0),
                ),
                filled: true,
                fillColor: Theme.of(context).primaryColor,
                suffixText: 'Kg',
                labelText: 'Inserisci',
                labelStyle: TextStyle(color: valueFocusNode.hasFocus ? Colors.blueAccent : Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                suffixStyle: TextStyle(color: Colors.blueAccent),
              ),
              onChanged: (text) {
                final double? newValue = double.tryParse(text);
                if (newValue != null) onChanged(newValue);
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
                  borderSide: BorderSide(color: dateFocusNode.hasFocus ? Colors.blueAccent : Colors.grey, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: dateFocusNode.hasFocus ? Colors.blueAccent : Colors.grey, width: 2.0),
                ),
                filled: true,
                fillColor: Theme.of(context).primaryColor,
                labelText: 'Inserisci Data',
                labelStyle: TextStyle(color: dateFocusNode.hasFocus ? Colors.blueAccent : Colors.grey),
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

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>();
    final isMale = userProfile.isMale;
    final weightClasses = _getWeightClasses(isMale);

    return GestureDetector(
      onTap: () {
        // Nessun focus node da perdere ora
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crea Profilo Atleta'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              userProfile.reset();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.25,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      userProfile.category = index == 0
                          ? 'POWERLIFTER'
                          : index == 1
                              ? 'STREETLIFTER'
                              : 'IBRIDO';
                      context.read<UserProfile>().notifyListeners();
                    },
                  ),
                  items: [
                    if (isMale) 'assets/avatar_m_pl.png',
                    if (isMale) 'assets/avatar_m_sl.png',
                    if (isMale) 'assets/avatar_m_s.jpg',
                    if (!isMale) 'assets/avatar_w_pl.jpeg',
                    if (!isMale) 'assets/avatar_w_sl.png',
                    if (!isMale) 'assets/avatar_w_s.jpeg',
                  ].map((path) {
                    return Builder(
                      builder: (context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            path,
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
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).textScaleFactor * 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Categoria Peso',
                        style: ResponsiveTextStyles.labelMedium(context)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: CupertinoPicker(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            userProfile.weightClass = weightClasses[index];
                          });
                        },
                        children: weightClasses.map((value) {
                          return Text(value, style: TextStyle(color: Colors.blueAccent));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _buildNumberInput(
                  label: 'Squat',
                  value: userProfile.squat,
                  onChanged: (value) {
                    setState(() {
                      userProfile.squat = value;
                      _updateLevel(userProfile);
                    });
                  },
                  dateController: _textControllers['squatDate']!,
                  valueFocusNode: _focusNodes['squatValue']!,
                  dateFocusNode: _focusNodes['squatDate']!,
                ),
                _buildNumberInput(
                  label: 'Panca Piana',
                  value: userProfile.benchPress,
                  onChanged: (value) {
                    setState(() {
                      userProfile.benchPress = value;
                      _updateLevel(userProfile);
                    });
                  },
                  dateController: _textControllers['benchPressDate']!,
                  valueFocusNode: _focusNodes['benchPressValue']!,
                  dateFocusNode: _focusNodes['benchPressDate']!,
                ),
                _buildNumberInput(
                  label: 'Stacco da terra',
                  value: userProfile.deadlift,
                  onChanged: (value) {
                    setState(() {
                      userProfile.deadlift = value;
                      _updateLevel(userProfile);
                    });
                  },
                  dateController: _textControllers['deadliftDate']!,
                  valueFocusNode: _focusNodes['deadliftValue']!,
                  dateFocusNode: _focusNodes['deadliftDate']!,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Center(
                  child: ResponsiveButtonStyle.mediumButton(
                    context: context,
                    buttonText: 'Continua',
                    icon: Icons.navigate_next,
                    onPressed: () {
                      final isAthlete = !widget.isBoth;
                      Provider.of<UserProfile>(context, listen: false).updateAthleteProfile(
                        category: userProfile.category,
                        isMale: userProfile.isMale,
                        weightClass: userProfile.weightClass,
                        isAlsoPrep: userProfile.isAlsoPrep,
                        squat: userProfile.squat,
                        squatDate: _parseDate(_textControllers['squatDate']!.text) ?? DateTime.now(),
                        benchPress: userProfile.benchPress,
                        bpDate: _parseDate(_textControllers['benchPressDate']!.text) ?? DateTime.now(),
                        deadlift: userProfile.deadlift,
                        dlDate: _parseDate(_textControllers['deadliftDate']!.text) ?? DateTime.now(),
                        dips: userProfile.dips,
                        level: userProfile.level,
                        isAthlete: isAthlete,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileWorldCrewPage(testMode: true),
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
