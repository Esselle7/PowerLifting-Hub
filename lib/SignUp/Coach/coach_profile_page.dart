import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:provider/provider.dart';
import 'coach_profile_skills_page.dart';

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
    userProfile.updateIsBoth(isBoth: widget.isBoth);
    return GestureDetector(
      onTap: () {
        _unfocusAllTextFields();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Crea Profilo Coach',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    userProfile.isMale ? 'assets/avatar_m_coach.png' : 'assets/avatar_f_coach.png',
                    height: 200,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  style: TextStyle(color: Colors.blueAccent),
                  controller: _educationTitleController,
                  focusNode: _educationTitleFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Titolo di Studio',
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
                    filled: true,
                    fillColor: Theme.of(context).primaryColor,
                    
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
