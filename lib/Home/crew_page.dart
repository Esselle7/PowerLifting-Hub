import 'package:flutter/material.dart';

class CrewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crew'),
      ),
      body: Center(
        child: Text(
          'Crew Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
