import 'package:flutter/material.dart';
import 'package:gym/SignUp/role_profile_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
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

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  bool isMale = true;
  bool _passwordsMatch = true;
  bool _isPasswordEmpty = true;

  @override
  void initState() {
    super.initState();
    _confirmPasswordController.addListener(_checkPasswordsMatch);
    _passwordController.addListener(_checkPasswordsMatch);
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

    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _dobFocusNode.dispose();
    _usernameFocusNode.dispose();

    super.dispose();
  }

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch = _passwordController.text == _confirmPasswordController.text;
      _isPasswordEmpty = _passwordController.text.isEmpty && _confirmPasswordController.text.isEmpty;
    });
  }

  void _unfocusAllTextFields() {
    _firstNameFocusNode.unfocus();
    _lastNameFocusNode.unfocus();
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _confirmPasswordFocusNode.unfocus();
    _dobFocusNode.unfocus();
    _usernameFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueAccent,
      ),
      body: GestureDetector(
        onTap: () {
          _unfocusAllTextFields();
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
                _buildTextField(_firstNameController, 'Nome', Icons.person, _firstNameFocusNode),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                _buildTextField(_lastNameController, 'Cognome', Icons.person, _lastNameFocusNode),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                _buildDateField(_dobController, 'Data di Nascita', Icons.calendar_today, _dobFocusNode),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                _buildTextField(_emailController, 'Email', Icons.email, _emailFocusNode),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                _buildTextField(_usernameController, 'Username', Icons.person_2_sharp, _usernameFocusNode),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                _buildTextField(_passwordController, 'Password', Icons.lock, _passwordFocusNode, obscureText: true),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                _buildTextField(
                  _confirmPasswordController,
                  'Ripeti Password',
                  Icons.lock,
                  _confirmPasswordFocusNode,
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
      style: ResponsiveTextStyles.labelMedium(context),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Theme.of(context).primaryColor,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
      obscureText: obscureText,
      validator: (value) {
        return null;
      },
    );
  }

  Widget _buildDateField(TextEditingController controller, String label, IconData icon, FocusNode focusNode) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: ResponsiveTextStyles.labelMedium(context),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Theme.of(context).primaryColor,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
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
        return null;
      },
    );
  }
}
