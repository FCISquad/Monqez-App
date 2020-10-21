import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Screens/LoginScreen.dart';

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

Widget _buildNameTF() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Full Name',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 50.0,
        child: TextField(
          keyboardType: TextInputType.name,
          style: TextStyle(
            color: Colors.deepOrange,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.account_circle_sharp,
              color: Colors.deepOrange,
            ),
            hintText: 'Enter your Name',
            hintStyle: TextStyle(
              color: Colors.deepOrange,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildPhoneNumberTF() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Phone Number',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 50.0,
        child: TextField(
          keyboardType: TextInputType.phone,
          style: TextStyle(
            color: Colors.deepOrange,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.deepOrange,
            ),
            hintText: 'Enter your Phone Number',
            hintStyle: TextStyle(
              color: Colors.deepOrange,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildIDNumberTF() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'ID Number',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 50.0,
        child: TextField(
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: Colors.deepOrange,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.assignment_ind_outlined,
              color: Colors.deepOrange,
            ),
            hintText: 'Enter your ID Number',
            hintStyle: TextStyle(
              color: Colors.deepOrange,
            ),
          ),
        ),
      ),
    ],
  );
}


class SecondSignupScreen extends StatefulWidget {
  @override
  _SecondSignupScreenState createState() => _SecondSignupScreenState();
}

class _SecondSignupScreenState extends State<SecondSignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepOrangeAccent,
      body: Text("Second Screen"),
    );
  }
}