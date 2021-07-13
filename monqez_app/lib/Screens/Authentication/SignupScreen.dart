import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import '../Utils/UI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email_validator/email_validator.dart';
import 'file:///C:/Users/Khaled-Predator/Desktop/FCI/GP/Monqez-App/monqez_app/lib/Screens/Authentication/SecondSignupScreen.dart';
import 'LoginScreen.dart';
import '../../Backend/Authentication.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
      backgroundColor: secondColor,
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
                    'Sign Up',
                    style: TextStyle(
                      color: firstColor,
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
                  _buildSigninBtn(),
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
            color: firstColor,
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
              color: firstColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.email, color: firstColor),
              hintText: 'Enter your Email',
              hintStyle: TextStyle(
                color: firstColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          _emailError,
          style: TextStyle(
            color: firstColor,
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
            color: firstColor,
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
            onChanged: (String val) => {
              _validatePassword(val),
              _validateconfirmPassword(_confirmPasswordController.text)
            },
            style: TextStyle(
              color: firstColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: firstColor,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                child: Icon(
                  Icons.remove_red_eye,
                  color: firstColor,
                ),
              ),
              hintText: 'Enter your Password',
              hintStyle: TextStyle(
                color: firstColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          _passwordError,
          style: TextStyle(
            color: firstColor,
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
            color: firstColor,
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
              color: firstColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: firstColor,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
                child: Icon(
                  Icons.remove_red_eye,
                  color: firstColor,
                ),
              ),
              hintText: 'Re-enter your Password',
              hintStyle: TextStyle(
                color: firstColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          _confirmPasswordError,
          style: TextStyle(
            color: firstColor,
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
            bool result = await signup(_emailController, _passwordController);
            if (result) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SecondSignupScreen()),
              );
            }
          } else {
            makeToast("Enter all fields correctly");
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: firstColor,
        child: Text(
          'SIGNUP',
          style: TextStyle(
            color: secondColor,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSigninBtn() {
    return GestureDetector(
      onTap: () {
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
                  return LoginScreen();
                }));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Have an Account? ',
              style: TextStyle(
                color: firstColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign in',
              style: TextStyle(
                color: firstColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
