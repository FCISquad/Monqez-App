import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/HomeScreenMap.dart';
import 'package:monqez_app/Screens/LoginScreen.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool loggedin = false;
  String email;
  String token;

  void redirect() async {
    await Firebase.initializeApp();

    var _prefs = await SharedPreferences.getInstance();
    email = _prefs.getString("email");
    token = _prefs.getString("userToken");
    var firebaseToken;
    if (FirebaseAuth.instance.currentUser != null)
      firebaseToken = await FirebaseAuth.instance.currentUser.getIdToken();
    //network-request-failed
    setState(() {
      loggedin = (firebaseToken == token) && (token != null);
    });

  }

  @override
  Widget build(BuildContext context) {
    redirect();
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: loggedin ? HomeScreenMap() : LoginScreen(),
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
