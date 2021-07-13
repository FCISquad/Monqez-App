import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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
  bool once = true;

  Future<void> checkUser(var uid) async {
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
    } else if (response2.statusCode == 403) {
      if (once) {
        once = false;
        token = await FirebaseAuth.instance.currentUser.getIdToken(true);
        print("HERE");
        saveUserToken(token, uid);
        setState(() {});
      } else {
        logout();
        token = null;
        makeToast("Error!");
        makeToast(response2.statusCode.toString());
        setState(() {});
      }
    } else {
      logout();
      token = null;
      print(response2.statusCode);
      makeToast("Error!");
      makeToast(response2.statusCode.toString());
    }
  }

  Future<void> redirect() async {
    await Firebase.initializeApp();
    var _prefs = await SharedPreferences.getInstance();
    token = _prefs.getString("userToken");
    uid = _prefs.getString("userID");
    Widget _navigate = LoginScreen();

    bool enter = true;
    /*await FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage message) {

        if (message != null) {
          enter = false;
          var data = message.data;

          if (data['type'] == "helper") {
            FirebaseCloudMessaging.route = new HelperUserNotification(message);
            HelperRequestNotificationScreen.hideBackButton = true;
          } else if (data['type'] == "normal") {
            _navigate = NormalHomeScreen(token);
          } else if (data['type'] == "admin"){
            _navigate = AdminHomeScreen();
          } else {
            makeToast("Invalid notification received");
          }
          _navigate = NotificationRoute.selectNavigate;
        }
    });*/

    if (enter) {
      if (token == null) {
        _navigate = LoginScreen();
      } else {
        await checkUser(uid);
        if (isDisabled != null && isDisabled ) {
          if (type == 0) {
            makeToast("Account is banned!");
            logout();
          } else if (type == 1) {
            makeToast("Please wait while your application is reviewed");
            logout();
          }
        } else if (firstLogin) {
          saveUserToken(token, uid);
          _navigate = SecondSignupScreen();
        } else {
          saveUserToken(token, uid);
          makeToast("Logged in Successfully");
          if (type == 0) {
            _navigate = NormalHomeScreen(token);
          } else if (type == 1) {
            _navigate = HelperHomeScreen(token);
          } else if (type == 2) {
            _navigate = AdminHomeScreen();
          }
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
