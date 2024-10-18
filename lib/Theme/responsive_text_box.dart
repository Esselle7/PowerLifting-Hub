import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final IconData? icon; // Icona opzionale
  final TextEditingController? controller; // Controller opzionale
  final void Function(String)? onChanged;
  
  CustomTextField({required this.labelText, this.icon, this.controller, this.onChanged});
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final borderRadius = screenWidth * 0.05; // Percentuale della larghezza dello schermo per il borderRadius
    final borderWidth = screenWidth * 0.005; // Percentuale della larghezza dello schermo per il bordo

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02), // Percentuale della larghezza dello schermo
      child: TextField(
        controller: controller, // Aggiungi il controller qui
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.blueAccent), // Colore del titolo
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null, // Mostra l'icona solo se non è null
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.grey, width: borderWidth), // Colore e larghezza del bordo
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: Colors.blueAccent, width: borderWidth * 1.5), // Colore e larghezza del bordo quando selezionato
          ),
          filled: true,
          fillColor: Colors.transparent, // Sfondo trasparente
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // Percentuale della larghezza dello schermo
            vertical: screenWidth * 0.05, // Aumentato per rendere la text box più alta
          ),
        ),
        style: TextStyle(
          color: Colors.blueAccent, // Colore del testo quando si scrive
        ),
      ),
    );
  }
}

class CustomPasswordTextField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final bool obscureText;
  final String? errorText;
  final TextEditingController? controller; // Controller opzionale

  CustomPasswordTextField({
    required this.labelText,
    this.icon,
    this.obscureText = false,
    this.errorText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final borderRadius = screenWidth * 0.05; // Percentuale della larghezza dello schermo per il borderRadius
    final borderWidth = screenWidth * 0.005; // Percentuale della larghezza dello schermo per il bordo

    return TextFormField(
      controller: controller, // Aggiungi il controller qui
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.blueAccent), // Colore del titolo
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null, // Mostra l'icona solo se non è null
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey, width: borderWidth), // Colore e larghezza del bordo
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.blueAccent, width: borderWidth * 1.5), // Colore e larghezza del bordo quando selezionato
        ),
        filled: true,
        fillColor: Colors.transparent, // Sfondo trasparente
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // Percentuale della larghezza dello schermo
          vertical: screenWidth * 0.05, // Aumentato per rendere la text box più alta
        ),
        errorText: errorText,
      ),
      style: TextStyle(
        color: Colors.blueAccent, // Colore del testo quando si scrive
      ),
    );
  }
}

class CustomDateField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? icon;

  CustomDateField({
    required this.controller,
    required this.labelText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final borderRadius = screenWidth * 0.05; // Percentuale della larghezza dello schermo per il borderRadius
    final borderWidth = screenWidth * 0.005; // Percentuale della larghezza dello schermo per il bordo

    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.blueAccent), // Colore del titolo
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null, // Mostra l'icona solo se non è null
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.grey, width: borderWidth), // Colore e larghezza del bordo
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.blueAccent, width: borderWidth * 1.5), // Colore e larghezza del bordo quando selezionato
        ),
        filled: true,
        fillColor: Colors.transparent, // Sfondo trasparente
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // Percentuale della larghezza dello schermo
          vertical: screenWidth * 0.05, // Aumentato per rendere la text box più alta
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        }
      },
    );
  }
}

class NumberTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final String labelText;
  final ValueChanged<String> onChanged;

  const NumberTextField({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.labelText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller, // Aggiungi il controller qui
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blue, 
            width: 3.0, 
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).primaryColor,
        labelText: labelText,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      onChanged: onChanged,
    );
  }
}

class CustomCarousel extends StatefulWidget {
  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  final PageController _pageController = PageController();
  String? _selectedType;
  final List<String> options = ['Certificazione', 'Laurea']; // Aggiungi qui altre opzioni

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 60,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: options.length,
              onPageChanged: (index) {
                setState(() {
                  _selectedType = options[index];
                });
              },
              itemBuilder: (context, index) {
                final option = options[index];
                return Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Sfondo trasparente
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _selectedType == option ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: _selectedType == option ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              options.length,
              (index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _pageController.hasClients && _pageController.page == index
                    ? 24
                    : 8,
                decoration: BoxDecoration(
                  color: _pageController.hasClients && _pageController.page == index
                      ? Colors.blue
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
