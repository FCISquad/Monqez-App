
import 'dart:convert';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:uuid/uuid.dart';

class ChatbotScreen extends StatefulWidget {
  String token;
  ChatbotScreen(this.token);
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}


class _ChatbotScreenState extends State<ChatbotScreen> with SingleTickerProviderStateMixin {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '1');
  final _bot = const types.User(id: '2');
  String _sessionID;


  List splitString(String text, String delimeter) {
    int idx = text.indexOf(delimeter);
    if (idx == -1) {
      return [text];
    }
    List parts = [text.substring(0,idx).trim(), text.substring(idx+delimeter.length).trim()];
    return parts;
  }
  void response(query) async {

    DialogAuthCredentials credentials = await DialogAuthCredentials.fromFile("images/service.json");
    DialogFlowtter instance = DialogFlowtter(
      credentials: credentials,
      sessionId: _sessionID,
    );
    DetectIntentResponse response = await instance.detectIntent(
      queryInput: QueryInput(
        text: TextInput(
          text: query,
          languageCode: "en",
        ),
      ),
    );

    List splitted = splitString(response.text, "action::");
    _handleMessage(splitted[0], _bot);
    Future.delayed(Duration(seconds: 1));
    if (splitted.length == 2) {
      String temp = splitted[1];
      List newSplitted = splitString(temp, ",");
      print("KKKKKK: " + newSplitted.toString());
      Navigator.pop(context, newSplitted);
    }
  }

  @override
  void initState() {
    super.initState();
    _sessionID = widget.token + DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _handleMessage("Hello, I am Monqez Chatbot. \nHow may I help you? \nHere are some sample requests.", _bot);
      _handleMessage("Make a voice call", _bot);
      _handleMessage("Get a nearby Monqez", _bot);
      _handleMessage("View instructions about burns", _bot);
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

  void makeVoiceCall() {
    Navigator.pop(context, ["voice"]);
  }
  void makeVideoCall() {
    Navigator.pop(context, ["video", "KK"]);
  }
  void makeRequest(){
    Navigator.pop(context, ["request"]);
  }
  void showInstructions() {
    Navigator.pop(context, ["instructions"]);
  }

  void _handleMessageTap(types.Message message) async {
    String text = getMessageText(message);

    if (text == "1. Make request") {
      _handleMessage(text, _user);
      makeRequest();

    } else if (text == "2. Call Monqez") {
      _handleMessage(text, _user);
      _handleMessage("1. Voice", _bot);
      _handleMessage("2. Video", _bot);

    } else if (text == "3. Show Instructions") {
      _handleMessage(text, _user);
      showInstructions();

    } else if (text == "1. Voice") {
      _handleMessage(text, _user);
      _handleMessage("Okay, Making a voice call!", _bot);
      makeVoiceCall();

    } else if (text == "2. Video") {
      _handleMessage(text, _user);
      _handleMessage("Okay, Making a video call!", _bot);
      makeVideoCall();

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
    response(message.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: getTitle("Monqez - Chatbot", 22.0, secondColor, TextAlign.start, true),
        shadowColor: Colors.black,
        backgroundColor: firstColor,
        iconTheme: IconThemeData(color: secondColor),
        elevation: 5,
      ),
      body: Chat(
        messages: _messages,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: DarkChatTheme(
          primaryColor: firstColor,
          secondaryColor: secondColor,
          receivedMessageBodyTextStyle: TextStyle(color: firstColor, fontWeight: FontWeight.bold),
          sentMessageBodyTextStyle: TextStyle(color: secondColor, fontWeight: FontWeight.bold),
          inputBackgroundColor: secondColor,
          inputTextColor: firstColor,
        )
      ),
    );
  }
}