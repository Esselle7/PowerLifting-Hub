import 'package:flutter/material.dart';
import '../Athlete/athlete_profile_page.dart';

class ProfileType extends StatelessWidget {
  const ProfileType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AthleteProfilePage(isBoth: false,)), // FIXME
                );
              },
              child: const Text('Crea Profilo Atleta'),
            ),
            ElevatedButton(
              onPressed: () {
                // preparatore 


              },
              child: const Text('Crea Profilo Preparatore'),
            ),
          ],
        ),
      ),
    );
  }
}
