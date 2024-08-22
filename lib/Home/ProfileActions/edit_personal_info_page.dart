import 'package:flutter/material.dart';
import 'package:gym/Services/confirmAppBar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; // Aggiungi la dipendenza http per fare richieste API
import 'dart:convert'; // Per gestire i dati JSON
import 'package:provider/provider.dart';
import 'package:gym/SignUp/user_profile_state.dart'; // Importa il file UserProfile

class EditProfilePage extends StatefulWidget {
  final bool testMode; // Aggiungi un parametro per la modalità di test

  EditProfilePage({required this.testMode}); // Modifica il costruttore per accettare il parametro

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _usernameController;

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    final userProfile = Provider.of<UserProfile>(context, listen: false);

    _firstNameController = TextEditingController(text: userProfile.firstName);
    _lastNameController = TextEditingController(text: userProfile.lastName);
    _emailController = TextEditingController(text: userProfile.email);
    _dobController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(userProfile.dob));
    _usernameController = TextEditingController(text: userProfile.username);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _usernameController.dispose();

    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _dobFocusNode.dispose();
    _usernameFocusNode.dispose();

    super.dispose();
  }

  Future<void> _updateProfile() async {
    final url = 'https://yourapiendpoint.com/updateProfile'; // Sostituisci con il tuo endpoint API

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'dob': _dobController.text,
        'email': _emailController.text,
        'username': _usernameController.text,
        // Aggiungi altri campi se necessario
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context); // Torna alla pagina di profilo se la risposta è positiva
    } else {
      // Gestisci l'errore qui
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante l\'aggiornamento del profilo')),
      );
    }
  }

  void _confirm() {
    if (widget.testMode) {
      Navigator.pop(context); // Torna alla pagina di profilo senza fare chiamata API
    } else {
      if (_formKey.currentState!.validate()) {
        _updateProfile();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: ConfirmAppBar(
        title: 'Modifica Profilo',
        onConfirm: () {
           _confirm();
        },
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping outside
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(_firstNameController, 'Nome', Icons.person, _firstNameFocusNode),
                SizedBox(height: 20),
                _buildTextField(_lastNameController, 'Cognome', Icons.person, _lastNameFocusNode),
                SizedBox(height: 20),
                _buildDateField(_dobController, 'Data di Nascita', Icons.calendar_today, _dobFocusNode),
                SizedBox(height: 20),
                _buildTextField(_emailController, 'Email', Icons.email, _emailFocusNode),
                SizedBox(height: 20),
                _buildTextField(_usernameController, 'Username', Icons.person, _usernameFocusNode),
                SizedBox(height: 40),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    FocusNode focusNode, {
    bool obscureText = false,
    String? errorText,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(color: Colors.blueAccent),
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
      obscureText: obscureText,
      validator: (value) {
        return null; // Aggiungi la validazione necessaria
      },
    );
  }

  Widget _buildDateField(TextEditingController controller, String label, IconData icon, FocusNode focusNode) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
          });
        }
      },
      validator: (value) {
        return null; // Aggiungi la validazione necessaria
      },
    );
  }
}
