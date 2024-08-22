import 'package:flutter/material.dart';
import 'package:gym/Services/homeAppBar.dart';

class CrewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  HomeAppBar(title: "Crew"),
      body: Center(
        child: Text(
          'Crew Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
