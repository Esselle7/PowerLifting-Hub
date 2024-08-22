import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym/Services/homeAppBar.dart';
import 'package:http/http.dart' as http;

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  final String messagingUrl = "https://messaging.botpress.cloud";
  final String clientToken = "b50c25d0-ccd1-40ee-a9be-9155913128a7.6IyyFYtqhyHL8JbdP+4poJxyrHvpTk2kCFg/fFoka5pTzL9QE1bdgqB2VqKFXoIi0lIYTKqvH1Ch7V8Rrxwmyefb";
  final String botId = "c48d9f7c-41a3-47da-ba99-0305481603a1";

  Future<void> _sendMessage() async {
    final message = _messageController.text;

    if (message.isEmpty) return;

    setState(() {
      _messages.add({'text': message, 'sender': 'user'});
      _messageController.clear();
    });

    final response = await _getBotResponse(message);

    setState(() {
      _messages.add({'text': response, 'sender': 'bot'});
    });
  }

  Future<String> _getBotResponse(String message) async {
    final response = await http.post(
      Uri.parse('$messagingUrl/api/v1/bots/$botId/converse'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $clientToken',
      },
      body: jsonEncode({
        'type': 'text',
        'text': message,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['responses'][0]['text'] ?? 'Errore nella risposta del bot';
    } else {
      return 'Errore nella comunicazione con il bot';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  HomeAppBar(title: "Chatbot"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message['sender'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message['sender'] == 'user' ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['text']!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type your message...',
                       hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
