import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/HelperUser/HelperHomeScreen.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Backend/Authentication.dart';

import 'package:http/http.dart' as http;

class HelperRequestNotificationScreen extends StatefulWidget {
  @override
  HelperRequestNotificationScreenState createState() =>
      HelperRequestNotificationScreenState();
}

class HelperRequestNotificationScreenState
    extends State<HelperRequestNotificationScreen> {

  var _prefs;
  String token;

  void setResult(bool isAccepted) async {
    print(isAccepted.toString());
    _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString("userToken");

    final http.Response response = await http.post(
      Uri.parse('$url/monqez/request'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'result': isAccepted.toString()}),
    );
    if (response.statusCode == 200) {
      makeToast("Successful");
    } else {
      print(response.statusCode);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: getTitle(
                "Monqez - Helper", 22.0, secondColor, TextAlign.start, true),
            shadowColor: Colors.black,
            backgroundColor: firstColor,
            iconTheme: IconThemeData(color: secondColor),
            elevation: 5),
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  color: Colors.white,
                  child: Text('SOS',
                      style: TextStyle(
                        color: primary,
                        fontSize: 48,
                        letterSpacing: 1.75,
                        fontWeight: FontWeight.bold,
                      ))),
              Container(
                  padding: const EdgeInsets.only(top: 20),
                  color: Colors.white,
                  child: Text('A nearby person needs your help on-site!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ))),
              new Container(
                padding: const EdgeInsets.only(top: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new ElevatedButton(
                      child: Icon(Icons.check, size: 60.0),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green, shape: CircleBorder()),
                      onPressed: () => {
                        setResult(true),
                        navigate(HelperHomeScreen(token), context, true)
                      },
                    ),
                    new ElevatedButton(
                      child: Icon(Icons.close, size: 60.0),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red, shape: CircleBorder()),
                      onPressed: () => {
                        setResult(false),
                        navigate(HelperHomeScreen(token), context, true) ///Momkn y error hena w token tb2a b null lw m3mlsh await
                      },
                    ),
                  ],
                ),
              ),
            ])));
  }
}
