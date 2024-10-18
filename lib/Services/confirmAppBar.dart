import 'package:flutter/material.dart';
import 'package:gym/Theme/responsive_text_styles.dart';

class ConfirmAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Campo per il titolo
  final VoidCallback onConfirm; // Evento callback per il pulsante di conferma

  const ConfirmAppBar({super.key, 
    required this.title, // Costruttore che accetta il titolo
    required this.onConfirm, // Costruttore che accetta la funzione di conferma
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.blueAccent,
          title: Text(
            title, // Usa il titolo passato come parametro
            style:  ResponsiveTextStyles.headlineLarge(context),
          ),
          elevation: 0, // Rimuove l'ombra
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Torna indietro alla schermata precedente
            },
          ),
          actions: [
            TextButton(
              onPressed: onConfirm, // Chiama la funzione di conferma quando premuto
              child: const Text(
                'Conferma',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Container(
          color: const Color.fromARGB(255, 60, 60, 60), // Colore della linea di demarcazione
          height: 1.0, // Altezza della linea
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0); // Altezza totale dell'AppBar
}
