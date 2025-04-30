import 'package:flutter/material.dart';
import 'chat_bubble.dart';
import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';
import 'package:HalalCheck/database/models/products.dart';
import 'package:HalalCheck/database/models/ingredients.dart';
import 'bot_response_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ProductService _productService = ProductService();

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, {'text': text, 'isUserMessage': true});
    });

    _handleBotResponse(text);
  }

  void _handleBotResponse(String userInput) async {
    final response = await BotResponseHandler.getBotReply(userInput);
    setState(() {
      _messages.insert(0, {'text': response, 'isUserMessage': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halal Product Checker')),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                return ChatMessage(
                  text: _messages[index]['text'],
                  isUserMessage: _messages[index]['isUserMessage'],
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
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask about a product or ingredient...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (text) {
                      _sendMessage(text);
                      _controller.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text);
                    _controller.clear();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



