import 'package:flutter/material.dart';
import 'package:gym/role_profile_page.dart';
import 'package:gym/user_profile_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'athlete_profile_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();

    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _dobFocusNode.dispose();

    super.dispose();
  }

  void _unfocusAllTextFields() {
    _firstNameFocusNode.unfocus();
    _lastNameFocusNode.unfocus();
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _dobFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.blueAccent,
      ),
      body: GestureDetector(
        onTap: () {
          _unfocusAllTextFields();
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
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
                _buildTextField(_passwordController, 'Password', Icons.lock, _passwordFocusNode, obscureText: true),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Aggiorna il profilo utente
                        Provider.of<UserProfile>(context, listen: false).updatePersonalInfo(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          dob: DateFormat('dd/MM/yyyy').parse(_dobController.text),
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        // Naviga alla pagina successiva
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RolePage()),
                        );
                      }
                    },
                    child: Text('Prosegui'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, FocusNode focusNode, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Per favore inserisci $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(TextEditingController controller, String label, IconData icon, FocusNode focusNode) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
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
        if (value == null || value.isEmpty) {
          return 'Per favore inserisci $label';
        }
        return null;
      },
    );
  }
}
