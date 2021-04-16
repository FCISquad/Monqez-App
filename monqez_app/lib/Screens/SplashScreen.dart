import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:monqez_app/Backend/FirebaseCloudMessaging.dart';
import 'dart:convert';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:monqez_app/Screens/LoginScreen.dart';
import '../Backend/Authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AdminUser/AdminHomeScreen.dart';
import 'HelperUser/HelperHomeScreen.dart';
import 'NormalUser/NormalHomeScreen.dart';
import 'SecondSignupScreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Widget map = LoginScreen();
  String uid;
  String token;
  int type;
  bool isDisabled;
  bool firstLogin;
  FirebaseCloudMessaging fcm;

  Future<void> checkUser(var token, var uid) async {
    final http.Response response2 = await http.get(
      Uri.parse('$url/user/get/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response2.statusCode == 200) {
      var parsed = jsonDecode(response2.body).cast<String, dynamic>();
      String sType = parsed['type'];
      String sDisabled = parsed['isDisabled'];
      String sFirst = parsed['firstLogin'];
      type = int.parse(sType);
      isDisabled = (sDisabled == 'true') ? true : false;
      firstLogin = (sFirst == 'true') ? true : false;
    } else {
      print(response2.statusCode);
      makeToast("Error!");
    }
  }

  Future<void> redirect() async {
    await Firebase.initializeApp();
    var _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString("userToken");
    uid = _prefs.getString("userID");
    Widget _navigate;
    if (token == null) {
      _navigate = LoginScreen();
    } else {
      await checkUser(token, uid);
      if (isDisabled) {
        if (type == 0)
          makeToast("Account is banned!");
        else if (type == 1)
          makeToast("Please wait while your application is reviewed");
      } else if (firstLogin) {
        saveUserToken(token, uid);
        _navigate = SecondSignupScreen();
      } else {
        saveUserToken(token, uid);
        makeToast("Logged in Successfully");
        fcm = new FirebaseCloudMessaging(token);
        if (type == 0) {
          _navigate = NormalHomeScreen(token);
        } else if (type == 1) {
          _navigate = HelperHomeScreen(token);
        } else if (type == 2) {
          _navigate = AdminHomeScreen();
        }
      }
    }
    map = _navigate;
    navigate(map, context, true);
  }

  @override
  Widget build(BuildContext context) {
    redirect();
    return Scaffold(
        backgroundColor: firstColor,
        body: Container(
            height: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text('Monqez',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                new Image(
                    image: new AssetImage('images/firstaid.png'),
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.width / 1.5),
                SizedBox(
                    height: 70,
                    width: 70,
                    child: CircularProgressIndicator(
                        backgroundColor: firstColor,
                        strokeWidth: 5,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(secondColor))),
              ],
            )));
  }
}
