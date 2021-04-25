import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Screens/AdminUser/AdminHomeScreen.dart';
import '../UI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email_validator/email_validator.dart';
import '../../Backend/Authentication.dart';
import 'package:http/http.dart' as http;


class AddNewAdminScreen extends StatefulWidget {
  @override
  _AddNewAdminScreenState createState() => _AddNewAdminScreenState();
}

class _AddNewAdminScreenState extends State<AddNewAdminScreen> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();
  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';
  bool _correctEmail = false;
  bool _correctPassword = false;
  bool _correctConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 60.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Add New Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _buildEmailTF(),
                  SizedBox(height: 30.0),
                  _buildPasswordTF(),
                  SizedBox(height: 30.0),
                  _buildConfirmPasswordTF(),
                  _buildSignupBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validateEmail(String text) {
    setState(() {
      if (text.isEmpty) {
        _emailError = "";
        _correctEmail = false;
      } else if (EmailValidator.validate(text)) {
        _emailError = "";
        _correctEmail = true;
      } else {
        _emailError = "Email is not correct";
        _correctEmail = false;
      }
    });
    return;
  }

  void _validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      setState(() {
        _passwordError = '';
        _correctPassword = false;
      });
    } else if (value.length < 8) {
      setState(() {
        _passwordError = 'Password is too short';
        _correctPassword = false;
      });
    } else {
      setState(() {
        if (!regex.hasMatch(value)) {
          _passwordError = 'Password is week';
          _correctPassword = false;
        } else {
          _passwordError = '';
          _correctPassword = true;
        }
      });
    }
  }

  void _validateconfirmPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _confirmPasswordError = '';
        _correctConfirmPassword = false;
      });
    } else if (value != _passwordController.text) {
      setState(() {
        _confirmPasswordError = "Password doesn\'t match";
        _correctConfirmPassword = false;
      });
    } else {
      setState(() {
        _confirmPasswordError = '';
        _correctConfirmPassword = true;
      });
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
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
          child: TextFormField(
            controller: _emailController,
            onChanged: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.deepOrange,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.deepOrange,
              ),
              enabledBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: new BorderSide(
                    color: _emailError.isEmpty ? Colors.white : Colors.blue,
                    width: 3),
              ),
              focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(
                      color: _emailError.isEmpty ? Colors.white : Colors.blue,
                      width: 3)),
              hintText: 'Enter the Email',
              hintStyle: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          _emailError,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
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
          child: TextFormField(
            controller: _passwordController,
            obscureText: !_showPassword,
            onChanged: _validatePassword,
            style: TextStyle(
              color: Colors.deepOrange,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.deepOrange,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                child: Icon(
                  Icons.remove_red_eye,
                  color: Colors.deepOrange,
                ),
              ),
              hintText: 'Enter the Password',
              hintStyle: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          _passwordError,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
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
          child: TextFormField(
            obscureText: !_showConfirmPassword,
            controller: _confirmPasswordController,
            onChanged: _validateconfirmPassword,
            style: TextStyle(
              color: Colors.deepOrange,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.deepOrange,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
                child: Icon(
                  Icons.remove_red_eye,
                  color: Colors.deepOrange,
                ),
              ),
              hintText: 'Re-enter the Password',
              hintStyle: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          _confirmPasswordError,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_correctEmail && _correctPassword && _correctConfirmPassword) {
            UserCredential result = await newAdmin(_emailController, _passwordController);
            //there could be an error here!!
            if (result != null) {
              bool isAdmin = await makeAdmin(result);
              if (isAdmin) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                );
              }
              else{
                makeToast("Error making admin");
              }
            }
          }
          else {
            makeToast("Enter all fields correctly");
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Add New Admin',
          style: TextStyle(
            color: Colors.deepOrange,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<bool> makeAdmin(UserCredential newAdmin) async{
    String token = AdminHomeScreenState.token;
    final http.Response response = await http.post(
        Uri.parse('$url/admin/add/'),
        headers: <String, String> {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
        body: jsonEncode(<String, String>{
          'newUserID': newAdmin.user.uid}
        ));
    if (response.statusCode == 200){
      makeToast("Admin Created Successfully!");
      return true;
    }
    else{
      print(response.statusCode);
      return false;
    }
  }
}
