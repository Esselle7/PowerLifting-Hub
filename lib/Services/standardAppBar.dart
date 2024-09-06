import 'package:flutter/material.dart';

class StandardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Campo per il titolo

  const StandardAppBar({super.key, 
    required this.title, // Costruttore che accetta il titolo
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontSize: 25,
            ),
          ),
          elevation: 0, // Rimuove l'ombra
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Torna indietro alla schermata precedente
            },
          ),
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
