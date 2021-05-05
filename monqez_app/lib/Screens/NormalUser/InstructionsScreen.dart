import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:monqez_app/Screens/Utils/Profile.dart';
import '../../Backend/Authentication.dart';
import '../LoginScreen.dart';
import 'package:monqez_app/Screens/Model/User.dart';


class InstructionsScreen extends StatefulWidget {
  String token;
  InstructionsScreen(String token) {
    this.token = token;
  }
  @override
  _InstructionsScreenState createState() => _InstructionsScreenState();
}
class _InstructionsScreenState extends State<InstructionsScreen> {



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title:
            getTitle("Instructions", 22.0, secondColor, TextAlign.start, true),
            shadowColor: Colors.black,
            backgroundColor: firstColor,
            iconTheme: IconThemeData(color: secondColor),
            elevation: 5),


    ),
    );


  }


}