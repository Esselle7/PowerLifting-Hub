import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);
  @override
  ChatbotPageState createState() => ChatbotPageState();
}
class ChatbotPageState extends State<ChatbotPage> {
  final controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://cdn.botpress.cloud/webchat/v2/shareable.html?botId=c48d9f7c-41a3-47da-ba99-0305481603a1'));
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: WebViewWidget(controller: controller,));
  }
}