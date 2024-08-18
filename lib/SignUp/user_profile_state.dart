import 'package:flutter/material.dart';

class UserProfile with ChangeNotifier {
  String firstName = '';
  String lastName = '';
  DateTime dob = DateTime.now();
  String email = '';
  String password = '';
  String username = '';

  String category = '';
  bool isMale = true;
  String weightClass = '53';
  bool isAlsoPrep = false;
  double squat = 0;
  DateTime squatDate = DateTime.now();
  double benchPress = 0;
  DateTime bpDate = DateTime.now();
  double deadlift = 0;
  DateTime dlDate = DateTime.now();
  double dips = 0;
  DateTime dipsDate = DateTime.now();

  String level = 'Base';
  String crew = '';
  String preparatore = '';
  String federation = '';
  bool isBoth = false;
  bool isAthlete = false;
  
  String educationTitle = '';
  Map<String, int> coachSkills = {};

  void updatePersonalInfo({
    required String firstName,
    required String lastName,
    required DateTime dob,
    required String email,
    required String password,
    required bool isMale, 
    required String username,
  }) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.dob = dob;
    this.email = email;
    this.password = password;
    this.isMale = isMale;
    this.username = username;
    notifyListeners();
  }
void updateIsBoth({required bool isBoth,}){
  this.isBoth = isBoth;
}
void updateCoachProfile({
    required bool isMale,
    required String educationTitle,
    required bool isAlsoPrep,
  }) {
    this.isMale = isMale;
    this.educationTitle = educationTitle;
    this.isAlsoPrep = isAlsoPrep;
    notifyListeners();
  }
  

   void updateCoachSkills(Map<String, int> skills) {
    coachSkills = skills;
    notifyListeners();
  }

  void updateAthleteProfile({
    required String category,
    required bool isMale,
    required String weightClass,
    required bool isAlsoPrep,
    required double squat,
    required DateTime squatDate,
    required double benchPress,
    required DateTime bpDate,
    required double deadlift,
    required DateTime dlDate,
    required double dips,
    required String level,
    required String crew,
    required String preparatore,
    required String federation,
    required bool isAthlete,
  }) {
    this.category = category;
    this.isMale = isMale;
    this.weightClass = weightClass;
    this.isAlsoPrep = isAlsoPrep;
    this.squat = squat;
    this.squatDate = squatDate;
    this.benchPress = benchPress;
    this.bpDate = bpDate;
    this.deadlift = deadlift;
    this.dlDate = dlDate;
    this.dips = dips;
    this.level = level;
    this.crew = crew;
    this.preparatore = preparatore;
    this.federation = federation;
    this.isAthlete = isAthlete;
    notifyListeners();
  }

  void reset() {
    firstName = '';
    lastName = '';
    dob = DateTime.now();
    email = '';
    username = '';
    password = '';
    category = 'Standard';
    isMale = true;
    weightClass = '53';
    isAlsoPrep = false;
    squat = 0;
    squatDate = DateTime.now();
    benchPress = 0;
    bpDate = DateTime.now();
    deadlift = 0;
    dlDate = DateTime.now();
    dips = 0;
    level = 'Base';
    crew = '';
    preparatore = '';
    federation = '';
    notifyListeners();
  }
}
