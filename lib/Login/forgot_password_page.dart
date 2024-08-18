import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Dimenticata'),
        backgroundColor: Colors.blueAccent,
      ),
      body: GestureDetector(
        onTap: () {
          // Chiudi la tastiera quando si tocca fuori dai campi di testo
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Container(
            width: 350,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent.shade100, // Colore di sfondo del contenitore
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
                  'Password Dimenticata',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 20),
                // Aggiungi qui i campi di input e le altre informazioni
                Text(
                  'Inserisci il tuo indirizzo email per ricevere le istruzioni su come reimpostare la tua password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                    filled: true,
                    fillColor:  Theme.of(context).primaryColor,
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Aggiungi la logica per inviare le istruzioni di recupero della password
                    print('Invia Istruzioni di Recupero');
                  },
                  child: Text('Invia Istruzioni'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Colore del pulsante
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Torna al Login'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Colore del testo del pulsante
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
