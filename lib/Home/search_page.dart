import 'package:flutter/material.dart';
import 'package:gym/Services/homeAppBar.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  HomeAppBar(title: "Search"),
      body: Center(
        child: Text(
          'Search Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
