import 'package:flutter/material.dart';
import 'package:gym/SignUp/signup_page.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:gym/login_page.dart';
import 'package:gym/Theme/responsive_button_style.dart'; // Assicurati di importare il file

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Benvenuto!',
                style: ResponsiveTextStyles.headlineLarge(context),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Login',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ResponsiveButtonStyle.mediumButton(
                context: context,
                buttonText: 'Sign Up',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                icon: Icons.person_add, // Aggiunge un'icona opzionale
              ),
            ],
          ),
        ),
      ),
    );
  }
}
