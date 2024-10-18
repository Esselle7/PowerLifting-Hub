import 'package:flutter/material.dart';

class ItemBox extends StatelessWidget {
  final String title; // Titolo, es. nome dell'elemento
  final String description; // Descrizione, es. info extra (es: specializzazione o traguardi)
  final IconData icon; // Icona dinamica basata sul tipo (coach, atleta, crew)
  final Color iconColor; // Colore dell'icona in base al tipo
  final String label; // Etichetta che mostra il tipo (es: Coach, Atleta, Crew)
  final VoidCallback onTap; // Azione da eseguire quando l'utente clicca

  const ItemBox({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icona dinamica con colore basato sul tipo
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withOpacity(0.2), // Sfondo leggero per l'icona
              ),
              child: Icon(
                icon,
                size: 30,
                color: iconColor, // Colore dell'icona dinamico
              ),
            ),
            const SizedBox(width: 16.0),
            // Dettagli (titolo, descrizione, etichetta)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titolo (nome)
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Descrizione breve
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Etichetta (tipo: Coach, Atleta, Crew)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      label, // Mostra il tipo (Coach, Atleta, Crew)
                      style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
