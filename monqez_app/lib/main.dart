import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/HomeScreen.dart';
import 'package:splashscreen/splashscreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Colors.deepOrangeAccent,
      seconds: 3,
      navigateAfterSeconds: new HomeScreen(),
      title:                   Text(
          'Monqez', style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold)),
      image: new Image(
          image: new AssetImage('images/firstaid.png')
      ),
      loadingText: Text(""),
      photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }
}

