import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym/Home/ProfileActions/edit_personal_info_page.dart';
import 'package:gym/Services/homeAppBar.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final bool testMode;

  ProfilePage({required this.testMode});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _profileData;

  @override
  void initState() {
    super.initState();
    _profileData = fetchProfileData();
  }

  Future<Map<String, dynamic>> fetchProfileData() async {
    if (widget.testMode) {
      return {
        "avatar": "avatar_w_pl",
        "badge": ["BADGE_ORO"],
        "storico": [
          {"alzata": "SQUAT", "data": "2023-10-10", "peso": 150.5},
          {"alzata": "PANCA_PIANA", "data": "2023-10-11", "peso": 100.0},
          {"alzata": "STACCO_DA_TERRA", "data": "2023-10-12", "peso": 180.0},
        ],
        "wod": [
          {"esercizio": "Spinte con manubri", "serie": 4, "rep": 10, "note": "Discesa lenta"},
          {"esercizio": "Stacchi da terra", "serie": 4, "rep": 8, "note": "Mantieni la schiena dritta"},
          {"esercizio": "Trazioni", "serie": 3, "rep": 12, "note": "Esegui lentamente"}
        ],
        "nome": "Mario",
        "cognome": "Rossi",
        "citta": "Roma",
        "followers": 120,
        "following": 150
      };
    } else {
      final url = Uri.parse('http://your-api-url/profile');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load profile data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar:  HomeAppBar(title: "Profilo"),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Nessun dato disponibile'));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar, Badge e Bottoni
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar e Informazioni Personali
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage('assets/${data['avatar']}.jpeg'),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${data['nome']} ${data['cognome']}',
                                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                            context,
                                           MaterialPageRoute(
                                                    builder: (context) => EditProfilePage(testMode: true,),
                                                    ),
                                              );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.blueAccent,
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            side: BorderSide(color: Colors.blueAccent),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, color: Colors.blueAccent),
                                              SizedBox(width: 4),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${data['citta']}',
                                      style: TextStyle(color: Colors.grey[400], fontSize: 18),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              '${data['followers']}',
                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Followers',
                                              style: TextStyle(color: Colors.grey[400], fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 20),
                                        Column(
                                          children: [
                                            Text(
                                              '${data['following']}',
                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Following',
                                              style: TextStyle(color: Colors.grey[400], fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Wrap(
                                          spacing: 10,
                                          children: data['badge'].map<Widget>((badge) {
                                            return Column(
                                              children: [
                                                //Image.asset('assets/${badge}.png', width: 40, height: 40),
                                                SizedBox(height: 4),
                                                Text(
                                                  badge.replaceAll('BADGE_', ''),
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                                SizedBox(height: 20),

                // Storico
                Text(
                  'Storico',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                SizedBox(height: 10),
                // Modifica della riga per lo storico
Container(
  width: MediaQuery.of(context).size.width / 2, // Larghezza metà pagina
  padding: EdgeInsets.all(8.0),
  decoration: BoxDecoration(
    color: Colors.grey[800],
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.blueAccent, width: 2),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ...data['storico'].map<Widget>((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item['alzata']}',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item['data']}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  Text(
                    '${item['peso']} kg',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    ],
  ),
),

                // WOD e Bottone Visualizza Workout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'WOD',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Naviga alla pagina dei workout precedenti
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Visualizza Workout'),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Slider WOD
                Container(
                  height: 160, // Altezza ridotta per adattarsi meglio alla pagina
                  child: PageView(
                    children: data['wod'].map<Widget>((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blueAccent, width: 2),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Esercizio ${data['wod'].indexOf(item) + 1}',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item['esercizio']}',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                    '${item['serie']} serie | ${item['rep']} rep',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Note: ${item['note']}',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),


                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
