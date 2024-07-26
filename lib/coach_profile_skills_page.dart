import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'coach_profile_world_page.dart';
import 'user_profile_state.dart';

class CoachProfileSkillsPage extends StatefulWidget {
  final bool isBoth;

  CoachProfileSkillsPage({required this.isBoth});

  @override
  _CoachProfileSkillsPageState createState() => _CoachProfileSkillsPageState();
}

class _CoachProfileSkillsPageState extends State<CoachProfileSkillsPage> {
  Map<String, int> _skills = {
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
        Text(skill, style: TextStyle(fontSize: 16)),
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Insert yout Skills'),
      ),
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
              }).toList(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<UserProfile>(context, listen: false).updateCoachSkills(_skills);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoachProfileWorldPage(isBoth: widget.isBoth),
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
    );
  }
}
