import 'dart:convert';

import 'package:monqez_app/Screens/LoginScreen.dart';

import '../Backend/Authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'AdminUser/AdminHomeScreen.dart';
import 'HelperUser/HelperHomeScreen.dart';
import 'NormalUser/NormalHomeScreen.dart';
import 'SecondSignupScreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool loggedin = false;
  String uid;
  String token;
  int type;
  bool isDisabled;
  bool firstLogin;


  Future <void> checkUser(var token, var uid) async{
    final http.Response response2 = await http.post(
      '$url/checkUser/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'uid': uid,
        'request': "check"
      }),
    );
    if (response2.statusCode == 200){
      var parsed = jsonDecode(response2.body).cast<String, dynamic>();
      String sType = parsed['type'];
      String sDisabled = parsed['isDisabled'];
      String sFirst = parsed['firstLogin'];
      type = int.parse(sType);
      isDisabled = (sDisabled == 'true') ? true: false;
      firstLogin = (sFirst == 'true') ? true: false;

    }
    else{
      print(response2.statusCode);
      makeToast("Error!");
    }
  }
  Future<Widget> redirect() async {
    await Firebase.initializeApp();
    var _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString("userToken");
    uid = _prefs.getString("userID");

    if (token == null)
      return LoginScreen();

    await checkUser(token, uid);
    if (isDisabled){
      if (type == 0)
        makeToast("Account is banned!");
      else if (type == 1)
        makeToast("Please wait while your application is reviewed");
    }
    else if (firstLogin){
      saveUserToken(token, uid);
      return SecondSignupScreen();
    }
    else{
      saveUserToken(token, uid);
      makeToast("Logged in Successfully");
      if (type == 0){
        return NormalHomeScreen();
      }
      else if (type == 1){
        return HelperHomeScreen();
      }
      else if (type == 2){
        return AdminHomeScreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    redirect();
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: redirect(),
      backgroundColor: Colors.deepOrangeAccent,
      title: Text('Monqez',
          style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold)),
      image: new Image(image: new AssetImage('images/firstaid.png')),
      loadingText: Text(""),
      photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }
}
