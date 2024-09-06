import 'package:flutter/material.dart';
import 'package:gym/Services/standardAppBar.dart';
import 'package:gym/SignUp/Coach/coach_profile_page.dart';
import 'package:gym/SignUp/Athlete/athlete_profile_page.dart';
import 'package:gym/Theme/responsive_button_style.dart'; // Importa il file per i bottoni

class RolePage extends StatelessWidget {
  const RolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: "Dimmi qualcosa di più"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResponsiveButtonStyle.largeButton(
              context: context,
              buttonText: 'Sono un atleta',
              icon: Icons.directions_run, // Icona per atleta
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AthleteProfilePage(isBoth: false)),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ResponsiveButtonStyle.largeButton(
              context: context,
              buttonText: 'Sono un preparatore',
              icon: Icons.fitness_center, // Icona per preparatore
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoachProfilePage(isBoth: false)),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ResponsiveButtonStyle.largeButton(
              context: context,
              buttonText: 'Sono entrambi',
              icon: Icons.people, // Icona per entrambi
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoachProfilePage(isBoth: true)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
