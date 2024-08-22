import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'coach_profile_skills_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';

class CoachProfilePage extends StatefulWidget {
  final bool isBoth;

  CoachProfilePage({required this.isBoth});

  @override
  _CoachProfilePageState createState() => _CoachProfilePageState();
}

class _CoachProfilePageState extends State<CoachProfilePage> {
  final List<String> _titles = [];
  String? _selectedType = null;
  TextEditingController _titleController = TextEditingController();
  

  void _addTitle() {
    if (_titleController.text.isNotEmpty && _selectedType != null) {
      setState(() {
        _titles.add('$_selectedType ${_titleController.text}');
        _titleController.clear();
        _selectedType = null;
      });
    }
  }

  void _removeTitle(int index) {
    setState(() {
      _titles.removeAt(index);
    });
  }

  void _clearAllTitles() {
    setState(() {
      _titles.clear();
    });
  }


void _showAddTitleDialog() {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5), // Colore di sfondo grigiastro
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Theme.of(context).primaryColor, // Colore principale del tema
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.blueAccent,
            width: 2, // Bordo più spesso
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sezione per i bottoni di selezione
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSelectionButton('Certificazione'),
                  _buildSelectionButton('Laurea'),
                ],
              ),
              SizedBox(height: 16),
              // Campo di testo per il nome del titolo
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Nome del Titolo',
                  filled: true,
                  fillColor: Colors.blueAccent,
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2, // Bordo più spesso
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2, // Bordo più spesso
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2, // Bordo più spesso
                    ),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addTitle();
                    },
                    child: Text('Aggiungi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Annulla'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
Widget _buildSelectionButton(String type) { // FIXME
  bool isSelected = _selectedType == type;
  return ElevatedButton(
    onPressed: () {
      setState(() {
        if (isSelected) {
          _selectedType = null;
        } else {
          _selectedType = type;
        }
      });
    },
    child: Text(
      type,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.blueAccent,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[800], // Colore di sfondo
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blueAccent,
          width: 2,
        ),
      ),
    ),
  );
}
Widget _buildSccelectionButton(String type) {
  bool isSelected = _selectedType == type;
  return ElevatedButton(
    onPressed: () {
      setState(() {
        if (!isSelected) {
          _selectedType = type;
        } else {
          // Deseleziona se è già selezionato
         // _selectedType = null;
        }
      });
    },
    child: Text(
      type,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.blueAccent,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[800], // Colore di sfondo
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blueAccent,
          width: 2,
        ),
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>();
    userProfile.updateIsBoth(isBoth: widget.isBoth);

    return Scaffold(
      appBar: AppBar(
        title: Text('Crea Profilo Coach'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            userProfile.reset();
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor, // Sfondo della pagina
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        userProfile.isMale
                            ? 'assets/avatar_m_coach.png'
                            : 'assets/avatar_f_coach.png',
                        height: 200,
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_titles.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._titles.asMap().entries.map((entry) {
                              int index = entry.key;
                              String title = entry.value;
                              return ListTile(
                                contentPadding: EdgeInsets.all(8.0),
                                tileColor: Colors.blueAccent,
                                title: Text(
                                  title,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                leading: Icon(
                                  title.startsWith('Certificazione') ? Icons.insert_drive_file : Icons.school,
                                  color: Colors.white,
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _removeTitle(index),
                                ),
                              );
                            }).toList(),
                            SizedBox(height: 8),
                            Center(
                              child: IconButton(
                                icon: Icon(Icons.clear_all, color: Colors.red, size: 30),
                                onPressed: _clearAllTitles,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 20),
                    Center(
                      child: FloatingActionButton(
                        onPressed: _showAddTitleDialog,
                        child: Icon(Icons.add, color: Colors.white),
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _unfocusAllTextFields();
                Provider.of<UserProfile>(context, listen: false).updateCoachProfile(
                  isMale: userProfile.isMale,
                  educationTitles: _titles,
                  isAlsoPrep: userProfile.isAlsoPrep,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoachProfileSkillsPage(
                      isBoth: widget.isBoth,
                    ),
                  ),
                );
              },
              child: Text('Continua'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _unfocusAllTextFields() {
    FocusScope.of(context).unfocus();
  }
}
