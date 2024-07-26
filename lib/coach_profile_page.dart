import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'coach_profile_skills_page.dart';
import 'user_profile_state.dart';

class CoachProfilePage extends StatefulWidget {
  final bool isBoth;

  CoachProfilePage({required this.isBoth});

  @override
  _CoachProfilePageState createState() => _CoachProfilePageState();
}

class _CoachProfilePageState extends State<CoachProfilePage> {
  final FocusNode _educationTitleFocusNode = FocusNode();
  final TextEditingController _educationTitleController = TextEditingController();

  void _unfocusAllTextFields() {
    _educationTitleFocusNode.unfocus();
  }

  @override
  void dispose() {
    _educationTitleFocusNode.dispose();
    _educationTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>();

    return GestureDetector(
      onTap: () {
        _unfocusAllTextFields();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Create Coach Profile'),
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
                        });
                      },
                      activeColor: Colors.blue,
                      inactiveThumbColor: Colors.pink,
                      inactiveTrackColor: Colors.pink.shade100,
                    ),
                    Text(userProfile.isMale ? 'M' : 'F', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Center(
                  child: Image.asset(
                    userProfile.isMale ? 'assets/avatar_m_coach.png' : 'assets/avatar_f_coach.png',
                    height: 200,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _educationTitleController,
                  focusNode: _educationTitleFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Titolo di Studio',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _unfocusAllTextFields(); // Rimuovi il focus dai TextField
                      Provider.of<UserProfile>(context, listen: false).updateCoachProfile(
                        isMale: userProfile.isMale,
                        educationTitle: _educationTitleController.text,
                        isAlsoPrep: userProfile.isAlsoPrep,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoachProfileSkillsPage(
                            isBoth: widget.isBoth,
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
