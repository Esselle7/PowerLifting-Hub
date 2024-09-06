import 'package:flutter/material.dart';
import 'package:gym/Services/homeAppBar.dart';

class CrewPage extends StatelessWidget {
  const CrewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  HomeAppBar(title: "Crew"),
      body: const Center(
        child: Text(
          'Crew Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
