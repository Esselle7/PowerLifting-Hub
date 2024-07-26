import 'package:flutter/material.dart';

class CoachProfileWorldPage extends StatelessWidget {
  final bool isBoth;

  CoachProfileWorldPage({required this.isBoth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coach Profile World'),
      ),
      body: Center(
        child: Text(
          'Benvenuto nella Coach Profile World Page!\n'
          'isBoth: ${isBoth ? "Yes" : "No"}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
