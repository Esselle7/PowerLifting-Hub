import 'package:flutter/material.dart';
import 'package:gym/Services/standardAppBar.dart';
import 'package:gym/SignUp/role_profile_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:gym/Theme/responsive_text_box.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gym/Theme/responsive_button_style.dart'; // Importa il file per i bottoni

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  FocusNode _globalFocusNode = FocusNode();

  bool isMale = true;
  bool _passwordsMatch = true;
  bool _isPasswordEmpty = true;

  @override
  void initState() {
    super.initState();
    _confirmPasswordController.addListener(_checkPasswordsMatch);
    _passwordController.addListener(_checkPasswordsMatch);

    // Rimuove il focus da tutti i campi di testo quando la pagina viene costruita
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _usernameController.dispose();
    _globalFocusNode.dispose();
    super.dispose();
  }

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch = _passwordController.text == _confirmPasswordController.text;
      _isPasswordEmpty = _passwordController.text.isEmpty && _confirmPasswordController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: "SignUp"),
      body: GestureDetector(
        onTap: () {
          // Quando si tocca fuori dai campi di testo, rimuove il focus
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Sesso: ', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045, color: Colors.blueAccent)),
                    Switch(
                      value: isMale,
                      onChanged: (value) {
                        setState(() {
                          isMale = value;
                        });
                      },
                      activeColor: Colors.blue,
                      inactiveThumbColor: Colors.pink,
                      inactiveTrackColor: Colors.pink.shade100,
                    ),
                    Text(isMale ? 'M' : 'F', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045, color: Colors.blueAccent)),
                  ],
                ),
                CustomTextField(
                  labelText: 'Nome',
                  icon: Icons.person,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomTextField(
                  labelText: 'Cognome',
                  icon: Icons.person,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomDateField(
                  controller: _dobController,
                  labelText: 'Data di Nascita',
                  icon: Icons.calendar_today,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomTextField(
                  labelText: 'Email',
                  icon: Icons.email,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomTextField(
                  labelText: 'Username',
                  icon: Icons.person_2_sharp,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomPasswordTextField(
                  labelText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomPasswordTextField(
                  labelText: 'Ripeti Password',
                  icon: Icons.lock,
                  obscureText: true,
                  errorText: _isPasswordEmpty ? null : (_passwordsMatch ? null : 'Le password non combaciano'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Center(
                  child: ResponsiveButtonStyle.mediumButton(
                    context: context,
                    buttonText: 'Prosegui',
                    icon: Icons.navigate_next,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<UserProfile>(context, listen: false).updatePersonalInfo(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          dob: _dobController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_dobController.text) : DateTime.now(),
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                          isMale: isMale,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RolePage()),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
