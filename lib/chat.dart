import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _chatMessages = [];
  final ScrollController _scrollController = ScrollController();

  // final String apiKey = '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';

  Future<void> _sendMessage() async {
    String message = _messageController.text;
    _messageController.clear();

    String url = 'https://6e50-112-215-145-74.ngrok-free.app/get?msg=$message';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _chatMessages.add('User: $message');
          _chatMessages.add('Chatbot: ${response.body}');
        });

        // Scroll to the bottom after adding a new message
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        // Handle error response
        print('Failed to get response from the chatbot.');
      }
    } catch (e) {
      // Handle exception
      print('Failed to communicate with the chatbot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_chatMessages[index]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ChatbotScreen(),
  ));
}
