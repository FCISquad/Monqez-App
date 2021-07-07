
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';

class ChatbotScreen extends StatefulWidget {

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}


class _ChatbotScreenState extends State<ChatbotScreen> with SingleTickerProviderStateMixin {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '1');
  final _bot = const types.User(id: '2');

  @override
  void initState() {
    super.initState();
    setState(() {
      _handleMessage("Hello, I am Monqez Chatbot. \nHow may I help you?", _bot);
      _handleMessage("1. Make request", _bot);
      _handleMessage("2. Call Monqez", _bot);
      _handleMessage("3. Show Instructions", _bot);
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  getMessageText(types.Message message) {
    return message.toJson()["text"];
  }
  void _handleMessageTap(types.Message message) async {
    String text = getMessageText(message);

    if (text == "1. Make request") {
      _handleMessage(text, _user);

    } else if (text == "2. Call Monqez") {
      _handleMessage(text, _user);
      _handleMessage("1. Voice", _bot);
      _handleMessage("2. Video", _bot);

    } else if (text == "3. Show Instructions") {
      _handleMessage(text, _user);

    } else if (text == "1. Voice") {
      _handleMessage(text, _user);
      _handleMessage("Okay, Making a voice call!", _bot);

    } else if (text == "2. Video") {
      _handleMessage(text, _user);
      _handleMessage("Okay, Making a voice call!", _bot);

    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleMessage(String text, dynamic user) {
    //String response = getResponse(text);
    final responseMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Uuid().v4(),
      text: text,
    );
    _addMessage(responseMessage);
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);
    //_handleBotMessage(message.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        messages: _messages,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user
      ),
    );
  }
}