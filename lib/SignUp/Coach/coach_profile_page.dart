import 'package:flutter/material.dart';
import 'package:gym/Theme/responsive_button_style.dart';
import 'package:gym/Theme/responsive_text_box.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
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
  String? _selectedType = 'Certificazione';
  final TextEditingController _titleController = TextEditingController();
  final PageController _pageController = PageController(initialPage: 0);
  bool _showInitialMessage = true;
  final List<String> _carouselOptions = ['Certificazione', 'Laurea'];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final int page = _pageController.page?.round() ?? 0;
      setState(() {
        _selectedType = _carouselOptions[page];
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addTitle() {
    if (_titleController.text.isNotEmpty && _selectedType != null) {
      setState(() {
        _titles.add('$_selectedType ${_titleController.text}');
        _titleController.clear();
        _selectedType = "Certificazione";

        if (_titles.isNotEmpty) {
          _showInitialMessage = false;
        }
      });
    }
  }

  void _removeTitle(int index) {
    setState(() {
      _titles.removeAt(index);

      if (_titles.isEmpty) {
        _showInitialMessage = true;
      }
    });
  }

  void _clearAllTitles() {
    setState(() {
      _titles.clear();
      _showInitialMessage = true; // Mostra di nuovo il messaggio
    });
  }
  void _showAddTitleDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
            side: BorderSide(
              color: Colors.blueAccent,
              width: MediaQuery.of(context).size.width * 0.005,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCarouselSelection(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomTextField(
                  labelText: 'Nome del Titolo',
                  controller: _titleController,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ResponsiveButtonStyle.smallButton(
                      context: context,
                      buttonText: 'Aggiungi',
                      icon: Icons.add,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _addTitle();
                      },
                    ),
                    ResponsiveButtonStyle.smallButton(
                      context: context,
                      icon: Icons.delete,
                      buttonText: 'Annulla',
                      onPressed: () => Navigator.of(context).pop(),
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

  Widget _buildCarouselSelection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _carouselOptions.length,
        itemBuilder: (context, index) {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.10),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              decoration: BoxDecoration(
                color: Colors.transparent, 
                border: Border.all(
                  color: Colors.blueAccent, // Colore del bordo
                  width: MediaQuery.of(context).size.width * 0.005,
                ),
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _carouselOptions[index],
                  style: ResponsiveTextStyles.labelMedium(context, Colors.blueAccent)
                ),
              ),
            ),
          );
        },
        onPageChanged: (page) {
          setState(() {
            _selectedType = _carouselOptions[page];
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>();
    userProfile.updateIsBoth(isBoth: widget.isBoth);

    return Scaffold(
      appBar: AppBar(
  title: Text('Crea Profilo Coach', style: ResponsiveTextStyles.headlineLarge(context)),
  backgroundColor: Colors.transparent,
  foregroundColor: Colors.blueAccent,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () async {
      userProfile.reset();
      Navigator.of(context).pop();
    },
  ),
  bottom: PreferredSize(
    preferredSize: Size.fromHeight(1.0), // Altezza della linea di divisione
    child: Container(
      color: const Color.fromARGB(255, 60, 60, 60), // Colore della linea di divisione
      height: 1.0, // Altezza della linea di divisione
    ),
  ),
),
     
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                userProfile.isMale
                    ? 'assets/avatar_m_coach.png'
                    : 'assets/avatar_f_coach.png',
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Center(
              child: ResponsiveButtonStyle.mediumButton(onPressed: () => _showAddTitleDialog(),context: context, icon: Icons.add, buttonText: "Aggiungi"),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            if (_showInitialMessage)
              Container(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.blueAccent, // Bordi blu
                    width: MediaQuery.of(context).size.width * 0.005,
                  ),
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
                ),
                child: Text(
                  'Le certificazioni \nappariranno qui',
                  style: ResponsiveTextStyles.labelLarge(context, Colors.grey)
                ),
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.003),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_titles.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.blueAccent, // Colore del bordo
                            width: MediaQuery.of(context).size.width * 0.005,
                          ),
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                               alignment: Alignment.centerLeft,
                              child: ResponsiveButtonStyle.mediumButton(
                                context: context,
                                buttonText: 'Elimina Tutti',
                                icon: Icons.clear_all,
                                onPressed: _clearAllTitles,
                              ),
                            ),
                            ..._titles.asMap().entries.map((entry) {
                              int index = entry.key;
                              String title = entry.value;
                              return ListTile(
                                contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                                tileColor: Colors.transparent,
                                title: Text(
                                  title,
                                  style: ResponsiveTextStyles.labelSmall(context),
                                ),
                                leading: Icon(
                                  title.startsWith('Certificazione') ? Icons.insert_drive_file : Icons.school,
                                  color: Colors.blueAccent,
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _removeTitle(index),
                                ),
                              );
                            }),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            
                          ],
                        ),
                      ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ResponsiveButtonStyle.mediumButton(
              context: context,
              buttonText: 'Continua',
              icon: Icons.navigate_next,
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
