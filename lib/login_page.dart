import 'package:flutter/material.dart';
import 'athlete_profile_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AthleteProfilePage()),
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
