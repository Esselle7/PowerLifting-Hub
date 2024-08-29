import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt_token', token);
}

Future<void> deleteToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
}

class NetworkService {

  NetworkService();

  
 Future<bool> authenticate() async {
  final url = Uri.parse('http://192.168.1.17:8080/gym/authenticate');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      saveToken(data['token']);
      return true;
    } else {
      throw Exception('Failed to authenticate: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error during authentication: $e');
    return false;
  }
}


// Funzione per fare una richiesta HTTP generica
Future<http.Response> _makeRequest(
    String url, String method, {Map<String, String>? headers, Object? body}) async {
  final uri = Uri.parse(url);

  try {
    switch (method.toUpperCase()) {
      case 'POST':
        return await http.post(uri, headers: headers, body: body);
      case 'GET':
        return await http.get(uri, headers: headers);
      // Aggiungi altre operazioni HTTP se necessario
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  } catch (e) {
    print('Error during HTTP request: $e');
    rethrow;
  }
}

Future<bool> _sendDataWithRetry(
    String url, String jsonString, Map<String, String> headers, int retryCount) async {
  try {
    final response = await _makeRequest(url, 'POST', headers: headers, body: jsonString);

    if (response.statusCode == 200) {
      if (response.body.contains('token scaduto')) {
        if (retryCount > 0) {
          if (!await authenticate()) {
            return false;
          }
          headers['Authorization'] = 'Bearer $getToken()';
          return await _sendDataWithRetry(url, jsonString, headers, retryCount - 1);
        } else {
          return false;
        }
      }
      return response.body.contains('non autorizzato') ? false : true;
    } else {
      throw Exception('Failed to send data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error during data sending: $e');
    return false;
  }
}

Future<bool> sendData(Map<String, dynamic> json, String district) async {
  final url = 'http://192.168.1.17:8080/gym/$district';
  final jsonString = jsonEncode(json);
  while(await getToken() == null) {
    await authenticate();
  }

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $getToken()',
  };

  return await _sendDataWithRetry(url, jsonString, headers, 3); 
}



}
