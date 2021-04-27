import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/HelperUser/HelperHomeScreen.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Backend/Authentication.dart';
import 'package:monqez_app/Screens/HelperUser/RequestScreen.dart';
import 'package:http/http.dart' as http;

class HelperRequestNotificationScreen extends StatefulWidget {
  @override
  HelperRequestNotificationScreenState createState() =>
      HelperRequestNotificationScreenState();
}

class HelperRequestNotificationScreenState
    extends State<HelperRequestNotificationScreen> {

  static String requestID;
  static double longitude;
  static double latitude;
  var _prefs;
  String token;

  void decline() async {
    _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString("userToken");

    final http.Response response = await http.post(
      Uri.parse('$url/helper/decline_request'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
        body: jsonEncode(<String, String>{
          "uid": requestID
        })
    );
    if (response.statusCode == 200) {
      makeToast("Successful");
    } else {
      print(response.statusCode);
    }
    setState(() {});
  }

  Future<int> accept() async {
    _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString("userToken");
    int returned = 0;
    final http.Response response = await http.post(
      Uri.parse('$url/helper/accept_request'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
        body: jsonEncode(<String, String>{
      "uid": requestID
    })
    );
    if (response.statusCode == 200) {
      makeToast("Successful");
    } else if (response.statusCode == 444){
      makeToast("Someone already accepted the request!");
      returned = 444;
    }
    else {
      print(response.statusCode);
    }
    setState(() {});
    return returned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: (){
                  decline();
                  Navigator.pop(context,true);
                }
            ),
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
                      onPressed: () async {
                        int result = await accept();
                        if (result == 0){
                        navigate(RequestScreen(longitude, latitude), context, true);}
                        else{
                          navigate(HelperHomeScreen(token), context, true); ///nfs error l t7t?
                        }
                      },
                    ),
                    new ElevatedButton(
                      child: Icon(Icons.close, size: 60.0),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red, shape: CircleBorder()),
                      onPressed: () => {
                        decline(),
                        navigate(HelperHomeScreen(token), context, true) ///Momkn y error hena w token tb2a b null lw m3mlsh await
                      },
                    ),
                  ],
                ),
              ),
            ])));
  }
}
