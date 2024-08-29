import 'package:flutter/material.dart';
import '../Athlete/athlete_profile_page.dart';

class ProfileType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
              child: Text('Crea Profilo Atleta'),
            ),
            ElevatedButton(
              onPressed: () {
                // preparatore 


              },
              child: Text('Crea Profilo Preparatore'),
            ),
          ],
        ),
      ),
    );
  }
}
