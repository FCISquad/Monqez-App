import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/HomeScreenMap.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:monqez_app/Screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var _prefs;
  bool loggedin = false;
  String email;
  String token;

  void redirect() async {
    await Firebase.initializeApp();

    _prefs = await SharedPreferences.getInstance();
    email = _prefs.getString("email");
    token = _prefs.getString("userToken");
    var FirebaseToken;
    if (FirebaseAuth.instance.currentUser != null)
      FirebaseToken = await FirebaseAuth.instance.currentUser.getIdToken();
    loggedin = (FirebaseToken == token) && (token != null);
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, animationTime, child) {
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                    .animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.ease,
                )),
                child: child,
              );
            },
            pageBuilder: (context, animation, animationTime) {
              return loggedin ? HomeScreenMap() : HomeScreen();
            }));

  }

  @override
  Widget build(BuildContext context) {
    redirect();
    return SplashScreen(
      seconds: 3,
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
