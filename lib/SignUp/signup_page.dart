import 'package:flutter/material.dart';
import 'package:gym/SignUp/role_profile_page.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController(); // Aggiunto per conferma password
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode(); // Aggiunto per conferma password
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  bool isMale = true;
  bool _passwordsMatch = true; // Variabile per controllare se le password combaciano
  bool _isPasswordEmpty = true; // Variabile per controllare se i campi sono vuoti

  @override
  void initState() {
    super.initState();

    // Aggiungi listener solo al campo di conferma della password
    _confirmPasswordController.addListener(_checkPasswordsMatch);
    _passwordController.addListener(_checkPasswordsMatch);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Aggiunto per conferma password
    _dobController.dispose();
    _usernameController.dispose();

    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose(); // Aggiunto per conferma password
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
        title: Text('Sign Up'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueAccent,
      ),
      body: GestureDetector(
        onTap: () {
          _unfocusAllTextFields();
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Sesso: ', style: TextStyle(fontSize: 18, color: Colors.blueAccent)),
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
                    Text(isMale ? 'M' : 'F', style: TextStyle(fontSize: 18, color: Colors.blueAccent)),
                  ],
                ),
                _buildTextField(_firstNameController, 'Nome', Icons.person, _firstNameFocusNode),
                SizedBox(height: 20),
                _buildTextField(_lastNameController, 'Cognome', Icons.person, _lastNameFocusNode),
                SizedBox(height: 20),
                _buildDateField(_dobController, 'Data di Nascita', Icons.calendar_today, _dobFocusNode),
                SizedBox(height: 20),
                _buildTextField(_emailController, 'Email', Icons.email, _emailFocusNode),
                SizedBox(height: 20),
                _buildTextField(_usernameController, 'Username', Icons.person_2_sharp, _usernameFocusNode),
                SizedBox(height: 20),
                _buildTextField(_passwordController, 'Password', Icons.lock, _passwordFocusNode, obscureText: true),
                SizedBox(height: 20),
                _buildTextField(
                  _confirmPasswordController,
                  'Ripeti Password',
                  Icons.lock,
                  _confirmPasswordFocusNode,
                  obscureText: true,
                  errorText: _isPasswordEmpty ? null : (_passwordsMatch ? null : 'Le password non combaciano'),
                ),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Aggiorna il profilo utente
                        Provider.of<UserProfile>(context, listen: false).updatePersonalInfo(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          dob: _dobController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_dobController.text) : DateTime.now(),
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                          isMale: isMale,
                        );
                        // Naviga alla pagina successiva
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RolePage()),
                        );
                      }
                    },
                    child: Text('Prosegui', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black45,
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
      style: Theme.of(context).textTheme.innerbox,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor:  Theme.of(context).primaryColor,
        labelStyle: TextStyle(color: Colors.blueAccent),
        errorText: errorText,
        // Definizione dei bordi
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.blueAccent, // Colore del bordo
            width: 2.0,              // Spessore del bordo
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.blueAccent, // Colore del bordo quando il campo è in focus
            width: 3.0,          // Spessore del bordo quando il campo è in focus
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.grey,  // Colore del bordo quando il campo è abilitato
            width: 2.0,          // Spessore del bordo quando il campo è abilitato
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.red,   // Colore del bordo quando c'è un errore
            width: 2.0,          // Spessore del bordo in caso di errore
          ),
        ),
      ),
      obscureText: obscureText,
      validator: (value) {
        /*if (value == null || value.isEmpty) {
          return 'Per favore inserisci $label';
        }*/
        return null;
      },
    );
  }

  Widget _buildDateField(TextEditingController controller, String label, IconData icon, FocusNode focusNode) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: Theme.of(context).textTheme.innerbox,
      decoration: InputDecoration(
        labelText: label,
        
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor:  Theme.of(context).primaryColor,
        labelStyle: TextStyle(color: Colors.blueAccent),
        // Definizione dei bordi
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.blueAccent, // Colore del bordo
            width: 2.0,              // Spessore del bordo
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.blueAccent, // Colore del bordo quando il campo è in focus
            width: 3.0,         // Spessore del bordo quando il campo è in focus
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.grey,  // Colore del bordo quando il campo è abilitato
            width: 2.0,          // Spessore del bordo quando il campo è abilitato
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.red,   // Colore del bordo quando c'è un errore
            width: 2.0,          // Spessore del bordo in caso di errore
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
        /*if (value == null || value.isEmpty) {
          return 'Per favore inserisci $label';
        }*/
        return null;
      },
    );
  }
}
