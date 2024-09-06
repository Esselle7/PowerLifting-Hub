import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'coach_profile_skills_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';

class CoachProfilePage extends StatefulWidget {
  final bool isBoth;

  const CoachProfilePage({super.key, required this.isBoth});

  @override
  _CoachProfilePageState createState() => _CoachProfilePageState();
}

class _CoachProfilePageState extends State<CoachProfilePage> {
  final List<String> _titles = [];
  String? _selectedType;
  final TextEditingController _titleController = TextEditingController();
  

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
          side: const BorderSide(
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
              const SizedBox(height: 16),
              // Campo di testo per il nome del titolo
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Nome del Titolo',
                  filled: true,
                  fillColor: Colors.blueAccent,
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2, // Bordo più spesso
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2, // Bordo più spesso
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2, // Bordo più spesso
                    ),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addTitle();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text('Aggiungi'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text('Annulla'),
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
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[800], // Colore di sfondo
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Colors.blueAccent,
          width: 2,
        ),
      ),
    ),
    child: Text(
      type,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.blueAccent,
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
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[800], // Colore di sfondo
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Colors.blueAccent,
          width: 2,
        ),
      ),
    ),
    child: Text(
      type,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.blueAccent,
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
        title: const Text('Crea Profilo Coach'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                    const SizedBox(height: 20),
                    if (_titles.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8.0),
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
                                contentPadding: const EdgeInsets.all(8.0),
                                tileColor: Colors.blueAccent,
                                title: Text(
                                  title,
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                leading: Icon(
                                  title.startsWith('Certificazione') ? Icons.insert_drive_file : Icons.school,
                                  color: Colors.white,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _removeTitle(index),
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            Center(
                              child: IconButton(
                                icon: const Icon(Icons.clear_all, color: Colors.red, size: 30),
                                onPressed: _clearAllTitles,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Center(
                      child: FloatingActionButton(
                        onPressed: _showAddTitleDialog,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Continua'),
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
