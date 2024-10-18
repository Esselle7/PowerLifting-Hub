import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym/SignUp/signup_page.dart';
import 'package:gym/Theme/responsive_text_styles.dart';
import 'package:gym/login_page.dart';
import 'package:gym/Theme/responsive_button_style.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final int nextPage = (_pageController.page?.round() ?? 0) + 1;
        if (nextPage < 3) {
          _pageController.animateToPage(
            nextPage,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Titolo di benvenuto
            Text(
              'Benvenuto!',
              style: ResponsiveTextStyles.headlineLarge(context).copyWith(
                color: Theme.of(context).primaryColor == Colors.white? Colors.black : Colors.white, // Colore del testo per contrastare con lo sfondo
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // Carosello con informazioni
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: PageView(
                controller: _pageController,
                children: [
                  _buildInfoPage(
                    context,
                    title: 'Scopri le Funzionalità',
                    description: 'Accedi a una vasta gamma di funzionalità per gestire il tuo allenamento e il tuo benessere.',
                  ),
                  _buildInfoPage(
                    context,
                    title: 'Personalizza il Tuo Profilo',
                    description: 'Personalizza il tuo profilo per un’esperienza su misura per te.',
                  ),
                  _buildInfoPage(
                    context,
                    title: 'Segui le Tue Metriche',
                    description: 'Tieni traccia dei tuoi progressi e migliora le tue performance nel tempo.',
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // Indicatori del carosello
            _buildPageIndicators(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            // Descrizione aggiuntiva
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Text(
                'Inizia subito con il tuo percorso di fitness con noi. Scegli un\'opzione qui sotto per procedere.',
                textAlign: TextAlign.center,
                style: ResponsiveTextStyles.labelMedium(context).copyWith(
                  color: Theme.of(context).primaryColor == Colors.white? Colors.black : Colors.white, // Colore del testo per contrastare con lo sfondo
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // Bottone di Login
            ResponsiveButtonStyle.mediumButton(
              context: context,
              buttonText: 'Login',
              icon: Icons.login,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            // Bottone di Sign Up
            ResponsiveButtonStyle.mediumButton(
              context: context,
              buttonText: 'Sign Up',
              icon: Icons.person_add,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget per una pagina del carosello
  Widget _buildInfoPage(BuildContext context, {required String title, required String description}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ResponsiveTextStyles.headlineLarge(context).copyWith(
              color: Theme.of(context).primaryColor == Colors.white? Colors.black : Colors.white, // Colore del testo per contrastare con lo sfondo
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            description,
            style: ResponsiveTextStyles.labelMedium(context).copyWith(
              color: Theme.of(context).primaryColor == Colors.white? Colors.black45 : Colors.white70, // Colore del testo per contrastare con lo sfondo
            ),
          ),
        ],
      ),
    );
  }

  // Widget per gli indicatori del carosello
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: _pageController.hasClients
                ? (_pageController.page?.round() == index
                    ? Colors.blueAccent
                    : Colors.white70)
                : Colors.white70,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
