import 'package:flutter/material.dart';
import 'package:gym/Services/standardAppBar.dart';
import 'package:gym/SignUp/Athlete/athlete_profile_page.dart';
import 'package:gym/SignUp/General/profile_world_crew_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:gym/Theme/responsive_button_style.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:provider/provider.dart';

class CoachProfileSkillsPage extends StatefulWidget {
  final bool isBoth;

  const CoachProfileSkillsPage({super.key, required this.isBoth});

  @override
  _CoachProfileSkillsPageState createState() => _CoachProfileSkillsPageState();
}

class _CoachProfileSkillsPageState extends State<CoachProfileSkillsPage> {
  final Map<String, int> _skills = {
    'Strength Training': 0,
    'Nutrition': 0,
    'Motivation': 0,
    'Flexibility': 0,
    'Endurance': 0,
    'Recovery': 0,
    'Mental Coaching': 0,
    'Injury Prevention': 0,
    'Boh': 0,
    'Team Work': 0,
  };

  void _setSkillLevel(String skill, int level) {
    setState(() {
      _skills[skill] = level;
    });
  }

  Widget _buildSkillRow(String skill, int level) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(skill, style: ResponsiveTextStyles.labelSmall(context)),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < level ? Icons.star : Icons.star_border,
                color: index < level ? Colors.amber : Colors.grey,
              ),
              onPressed: () {
                _setSkillLevel(skill, index + 1);
              },
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: "Completa le skills"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ..._skills.keys.map((skill) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildSkillRow(skill, _skills[skill]!),
                );
              }),
              const SizedBox(height: 20),
              Center(
                child: 
                
                ResponsiveButtonStyle.mediumButton(context: context, buttonText: "Prosegui", icon: Icons.navigate_next,
                onPressed: () {
                  Provider.of<UserProfile>(context, listen: false).updateCoachSkills(_skills);
                    if(widget.isBoth == true){
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AthleteProfilePage(isBoth: false),
                      ),
                    );
                  }
                  else{
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileWorldCrewPage(testMode: true),
                      ),
                    );
                  }
                    
                  
                  
                },)
                
               
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
