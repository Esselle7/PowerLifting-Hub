import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:gym/SignUp/user_profile_state.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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

  
 Future<bool> authenticate(BuildContext context) async {
  final url = Uri.parse('http://192.168.1.17:8080/gym/authenticate');
  //final userProfile = Provider.of<UserProfile>(context, listen: false);
  Map<String, dynamic> profile;
  profile = {
        'username': 'simone',
        };


  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body:jsonEncode(profile),
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
    String url, String jsonString, Map<String, String> headers, int retryCount, BuildContext context) async {
  try {
    final response = await _makeRequest(url, 'POST', headers: headers, body: jsonString);

    if (response.statusCode == 201) {
      if (response.body.contains('token scaduto')) {
        if (retryCount > 0) {
          if (!await authenticate(context)) {
            return false;
          }
          headers['Authorization'] = 'Bearer $getToken()';
          return await _sendDataWithRetry(url, jsonString, headers, retryCount - 1, context);
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

Future<bool> sendData(Map<String, dynamic> json, String district, String port, BuildContext context) async {
  final url = 'http://192.168.1.17:$port/gym/$district';
  final jsonString = jsonEncode(json);
  while(await getToken() == null) {
    await authenticate(context);
  }
  final headers;
  if(district == "login")
  {
    headers = {
    'Content-Type': 'application/json',
    //'Authorization': 'Bearer $getToken()',
    };
  }
  else{
    headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $getToken()',
    };
  }
  

  return await _sendDataWithRetry(url, jsonString, headers, 3, context); 
}



}
