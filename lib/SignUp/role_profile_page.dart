import 'package:flutter/material.dart';
import 'package:gym/SignUp/Coach/coach_profile_page.dart';
import 'Athlete/athlete_profile_page.dart';

class RolePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tell me about you')
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AthleteProfilePage(isBoth: false)), // FIXME
                );
              },
              child: Text(
                'I\'m Athlete',
                style: TextStyle(fontSize: 20), 
                
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Theme.of(context).mainColor,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: Colors.black45,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoachProfilePage(isBoth: false),
                  ),
                );
              },
              child: Text(
                'I\'m Preparator',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Theme.of(context).mainColor,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: Colors.black45,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoachProfilePage(isBoth: true),
                  ),
                );
              },
              child: Text(
                'I\'m both',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).mainColor,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
