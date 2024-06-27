import 'package:flutter/material.dart';

class UserProfile with ChangeNotifier {
  String firstName = '';
  String lastName = '';
  DateTime dob = DateTime.now();
  String email = '';
  String password = '';

  String category = 'Standard';
  bool isMale = true;
  String weightClass = '53';
  bool isAlsoPrep = false;
  double squat = 0;
  double benchPress = 0;
  double deadlift = 0;
  double dips = 0;
  String level = 'Base';
  String crew = '';
  String preparatore = '';
  String federation = '';

  void updatePersonalInfo({
    required String firstName,
    required String lastName,
    required DateTime dob,
    required String email,
    required String password,
  }) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.dob = dob;
    this.email = email;
    this.password = password;
    notifyListeners();
  }

  void updateAthleteProfile({
    required String category,
    required bool isMale,
    required String weightClass,
    required bool isAlsoPrep,
    required double squat,
    required double benchPress,
    required double deadlift,
    required double dips,
    required String level,
    required String crew,
    required String preparatore,
    required String federation,
  }) {
    this.category = category;
    this.isMale = isMale;
    this.weightClass = weightClass;
    this.isAlsoPrep = isAlsoPrep;
    this.squat = squat;
    this.benchPress = benchPress;
    this.deadlift = deadlift;
    this.dips = dips;
    this.level = level;
    this.crew = crew;
    this.preparatore = preparatore;
    this.federation = federation;
    notifyListeners();
  }

  void reset() {
    firstName = '';
    lastName = '';
    dob = DateTime.now();
    email = '';
    password = '';
    category = 'Standard';
    isMale = true;
    weightClass = '53';
    isAlsoPrep = false;
    squat = 0;
    benchPress = 0;
    deadlift = 0;
    dips = 0;
    level = 'Base';
    crew = '';
    preparatore = '';
    federation = '';
    notifyListeners();
  }
}
