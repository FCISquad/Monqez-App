import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:monqez_app/Screens/SecondSignupScreen.dart';
import 'package:monqez_app/Screens/NormalUser/NormalHomeScreen.dart';
import 'package:monqez_app/Screens/HelperUser/HelperHomeScreen.dart';
import 'package:monqez_app/Screens/AdminUser/AdminHomeScreen.dart';
import '../Backend/Authentication.dart';
import 'UI.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'SignupScreen.dart';
import 'package:http/http.dart' as http;


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int type = -1;
  bool isDisabled;
  bool firstLogin;


  bool _showPassword = false;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  String _emailError = '';
  String _passwordError = '';
  bool correctPassword = false;
  bool correctEmail = false;

  void navigateReplacement(Widget map) {
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
              return map;
            }));
  }
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
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _buildEmailTF(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _buildPasswordTF(),
                  _buildLoginBtn(),
                  _buildSignInWithText(),
                  _buildSocialBtnRow(),
                  _buildSignupBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validateLoginCredentials(String text) {
    setState(() {
      if (text.isEmpty) {
        _emailError = "Enter your email";
        correctEmail = false;
      } else if (EmailValidator.validate(text)) {
        _emailError = '';
        correctEmail = true;
      } else {
        _emailError = "Email is not correct";
        correctEmail = false;
      }
    });
    return;
  }

  void validatePassword(String text) {
    setState(() {
      if (text.isEmpty) {
        _passwordError = "Enter your password";
        correctPassword = false;
      } else if (text.length < 8) {
        _passwordError = "Your password must be at least 8 characters";
        correctPassword = false;
      } else {
        _passwordError = "";
        correctPassword = true;
      }
    });
    return;
  }

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

      setState(() {
        type = int.parse(sType);
        isDisabled = (sDisabled == 'true') ? true: false;
        firstLogin = (sFirst == 'true') ? true: false;
      });

    }
    else{
      print(response2.statusCode);
      makeToast("Error!");
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
            onChanged: validateLoginCredentials,
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
              hintText: 'Enter your Email',
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
          child: TextField(
            controller: _passwordController,
            obscureText: !_showPassword,
            onChanged: validatePassword,
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
              hintText: 'Enter your Password',
              hintStyle: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(_passwordError,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (!correctPassword && !correctEmail) {
            makeToast("Please enter all fields correctly");
            return;
          } else if (!correctPassword) {
            makeToast("Please enter your password correctly");
            return;
          } else if (!correctEmail) {
            makeToast("Please enter your email correctly");
            return;
          }
          //bool result = await normalSignIn(_emailController, _passwordController);
          bool result;
          var token;
          UserCredential userCredential;
          try {
            userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                email: _emailController.text, password: _passwordController.text);

            token = await FirebaseAuth.instance.currentUser.getIdToken();
            result =  true;
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              makeToast('Email not found!');
              result = false;
            } else if (e.code == 'wrong-password') {
              makeToast('Wrong password!');
              result = false;
            } else {
              makeToast(e.code);
              result = false;
            }
          }

          if (result) {
            await checkUser(token, userCredential.user.uid);
            if (isDisabled){
              if (type == 0)
                makeToast("Account is banned!");
              else if (type == 1)
                makeToast("Please wait while your application is reviewed");
            }
            else if (firstLogin){
              saveUserToken(token, userCredential.user.uid);
              navigateReplacement(SecondSignupScreen());
            }
            else{
              saveUserToken(token, userCredential.user.uid);
              makeToast("Logged in Successfully");
              if (type == 0){
                navigateReplacement(NormalHomeScreen());
              }
              else if (type == 1){
                navigateReplacement(HelperHomeScreen());
              }
              else if (type == 2){
                navigateReplacement(AdminHomeScreen());
              }
            }
          }
        },

        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
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

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: () async {
        bool result;
        final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        var token;
        UserCredential authResult;
        try {
          authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
          final User user = authResult.user;

          if (user != null) {
            assert(!user.isAnonymous);
            assert(await user.getIdToken() != null);

            final User currentUser = FirebaseAuth.instance.currentUser;
            assert(user.uid == currentUser.uid);
            token = await FirebaseAuth.instance.currentUser.getIdToken();
            result = true;
          }
        } on FirebaseAuthException catch (e) {
          makeToast(e.code);
          result = false;
        }
        if (result){
          await checkUser(token, authResult.user.uid);
          if (isDisabled){
            if (type == 0)
              makeToast("Account is banned!");
            else if (type == 1)
              makeToast("Please wait while your application is reviewed");
          }
          else if (firstLogin){
            saveUserToken(token, authResult.user.uid);
            navigateReplacement(SecondSignupScreen());

          }
          else{
            saveUserToken(token, authResult.user.uid);
            makeToast("Logged in Successfully");
            if (type == 0){
              navigateReplacement(NormalHomeScreen());
            }
            else if (type == 1){
              navigateReplacement(HelperHomeScreen());
            }
            else if (type == 2){
              navigateReplacement(AdminHomeScreen());
            }
          }

        }
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            signInWithGoogle,
            AssetImage(
              'images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        navigateReplacement(SignupScreen());
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
