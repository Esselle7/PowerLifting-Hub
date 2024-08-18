import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final _encrypter = encrypt.Encrypter(encrypt.AES(
    encrypt.Key.fromLength(32),
  ));
  final _key = encrypt.Key.fromUtf8('32charsofkeylengthmustbe32!'); // Chiave simmetrica di 32 caratteri
  final _iv = encrypt.IV.fromLength(16); // IV di 16 byte per AES

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _unfocusAllTextFields() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: Theme.of(context).textTheme.headline1,),
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
          child: Center(
            child: Container(
              width: 350,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color:  Theme.of(context).primaryColor, // Colore di sfondo del contenitore
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login',
                     style: Theme.of(context).textTheme.innerbox,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    _emailController,
                    'Email',
                    Icons.email,
                    _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    _passwordController,
                    'Password',
                    Icons.lock,
                    _passwordFocusNode,
                    obscureText: true,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      Map<String, dynamic> json = {
                            'username': email,
                            'password': password,
                        };

                        sendData(json);

                      //final encryptedEmail = _encrypter.encrypt(email, key: _key, iv: _iv);
                      //final encryptedPassword = _encrypter.encrypt(password, key: _key, iv: _iv);
                      print('username: ${email}');
                      print('Password: ${password}');
                      //print('Encrypted Email: ${encryptedEmail.base64}');
                      //print('Encrypted Password: ${encryptedPassword.base64}');
                      
                    },
                    child: Text('Login', style: TextStyle(fontSize: 20)),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

   Future<String> sendData(Map<String, dynamic> json) async {
    final url = Uri.parse('http://192.168.1.17:8080/gym/login');
    

    String jsonString = jsonEncode(json);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to send data: ${response.statusCode} ${response.reasonPhrase}');
  }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    FocusNode focusNode, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor:  Theme.of(context).primaryColor,
        labelStyle: TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
