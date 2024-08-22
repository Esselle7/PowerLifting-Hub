import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {

  NetworkService();

  Future<String> sendData(Map<String, dynamic> json) async {
    final url = Uri.parse('http://192.168.1.17:8090/gym/registrazione');

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
      throw Exception('Failed to send data');
    }
  }

   Future<bool> sendDataLogin(Map<String, dynamic> json) async {
    final url = Uri.parse('http://192.168.1.17:8080/gym/login');

    String jsonString = jsonEncode(json);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonString,
      );

      if (response.statusCode == 200) {
        if (response.body.contains('non autorizzato')) {
          return false;
        } else {
          return true;
        }
      } else {
        throw Exception('Failed to send data: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      return false;
    }
  }
}
