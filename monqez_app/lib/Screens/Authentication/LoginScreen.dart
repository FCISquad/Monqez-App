import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'file:///C:/Users/Khaled-Predator/Desktop/FCI/GP/Monqez-App/monqez_app/lib/Screens/Authentication/AdditionalAdminInfoScreen.dart';
import 'file:///C:/Users/Khaled-Predator/Desktop/FCI/GP/Monqez-App/monqez_app/lib/Screens/Authentication/SecondSignupScreen.dart';
import 'package:monqez_app/Screens/NormalUser/NormalHomeScreen.dart';
import 'package:monqez_app/Screens/HelperUser/HelperHomeScreen.dart';
import 'package:monqez_app/Screens/AdminUser/AdminHomeScreen.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:progress_indicator_button/progress_button.dart';
import '../../Backend/Authentication.dart';
import '../Utils/UI.dart';
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
  var _nationalIDController = TextEditingController();
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
                    'Sign In',
                    style: TextStyle(
                      color: firstColor,
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
                  _buildOneTimeRequestBtn(),
                  SizedBox(
                    height: 10,
                  ),
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

      setState(() {
        type = int.parse(sType);
        isDisabled = (sDisabled == 'true') ? true : false;
        firstLogin = (sFirst == 'true') ? true : false;
      });
    } else {
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
            onChanged: validateLoginCredentials,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: firstColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: firstColor,
              ),
              hintText: 'Enter your Email',
              hintStyle: TextStyle(color: firstColor),
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
          child: TextField(
            controller: _passwordController,
            obscureText: !_showPassword,
            onChanged: validatePassword,
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
        Text(_passwordError,
            style: TextStyle(color: firstColor, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ProgressButton(
        onPressed: (AnimationController controller) async {
          controller.forward();
          if (!correctPassword && !correctEmail) {
            makeToast("Please enter all fields correctly");
            controller.reset();
            return;
          } else if (!correctPassword) {
            makeToast("Please enter your password correctly");
            controller.reset();
            return;
          } else if (!correctEmail) {
            makeToast("Please enter your email correctly");
            controller.reset();
            return;
          }
          //bool result = await normalSignIn(_emailController, _passwordController);
          bool result ;
          var token;
          UserCredential userCredential;
          try {
            userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text);

            token = await FirebaseAuth.instance.currentUser.getIdToken();
            result = true;
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              makeToast('Email not found!');
              result = false;
              print ("1") ;
            } else if (e.code == 'wrong-password') {
              makeToast('Wrong password!');
              result = false;
              print ("2") ;
            } else {
              makeToast(e.code);
              result = false;
              print ("3") ;
            }
          }

          if (result) {
            await checkUser(token, userCredential.user.uid);
            if (isDisabled) {
              if (type == 0)
                makeToast("Account is banned!");
              else if (type == 1)
                makeToast("Please wait while your application is reviewed");
            } else if (firstLogin) {
              saveUserToken(token, userCredential.user.uid);
              if (type == 2) {
                navigateReplacement(AdditionalAdminInfoScreen());
              } else {
                navigateReplacement(SecondSignupScreen());
              }
            } else {
              print ("here") ;
              print (type) ;
              saveUserToken(token, userCredential.user.uid);
              makeToast("Logged in Successfully");
              if (type == 0) {
                navigateReplacement(NormalHomeScreen(token));
              } else if (type == 1) {
                navigateReplacement(HelperHomeScreen(token));
              } else if (type == 2) {
                navigateReplacement(AdminHomeScreen());
              }
            }
          }
          controller.reset();
        },
        borderRadius: BorderRadius.circular(30.0),

        color: firstColor,
        child: Text(
          'LOGIN',
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

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: () async {
        bool result;
        final GoogleSignInAccount googleSignInAccount =
            await googleSignIn.signIn();
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
        if (result) {
          await checkUser(token, authResult.user.uid);
          if (isDisabled) {
            if (type == 0)
              makeToast("Account is banned!");
            else if (type == 1)
              makeToast("Please wait while your application is reviewed");
          } else if (firstLogin) {
            saveUserToken(token, authResult.user.uid);
            navigateReplacement(SecondSignupScreen());
          } else {
            print ("heere") ;
            saveUserToken(token, authResult.user.uid);
            makeToast("Logged in Successfully");
            if (type == 0) {
              navigateReplacement(NormalHomeScreen(token));
            } else if (type == 1) {
              navigateReplacement(HelperHomeScreen(token));
            } else if (type == 2) {
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
          color: firstColor,
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
                color: firstColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
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

  _showNationalIDDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 200,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        "National ID",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                      SizedBox(height: 20),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'National ID'),
                        controller: _nationalIDController,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 200,
                                child: RaisedButton(
                                  onPressed: () async {
                                    if (_nationalIDController.text.isEmpty) {
                                      makeToast(
                                          "Please enter your national ID");
                                    } else if (_nationalIDController
                                            .text.length !=
                                        14) {
                                      makeToast(
                                          "Your National ID is not correct");
                                    } else {
                                      UserCredential userCredential =
                                          await FirebaseAuth.instance
                                              .signInAnonymously();
                                      var user = userCredential.user;
                                      String uid = user.uid;
                                      String token = await FirebaseAuth
                                          .instance.currentUser
                                          .getIdToken();

                                      print("HEEEEE" + token);
                                      bool valid = await sendID(token);
                                      if (valid) {
                                        saveUserToken(token, FirebaseAuth.instance.currentUser.uid);
                                        navigateReplacement(
                                            NormalHomeScreen(token));
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  sendID(String token) async {
    final http.Response response = await http.post(
        Uri.parse('$url/user/check_national_ID/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'oneTimeRequest': "true"
        },
        body: jsonEncode(
            <String, String>{"nationalId": _nationalIDController.text}));

    if (response.statusCode == 200) {
      //var parsed = jsonDecode(response.body).cast<String, dynamic>();
      return true;
    } else if (response.statusCode == 503) {
      makeToast("Error, National ID already exists!");
      return false;
    } else {
      makeToast("An Error has occured");
      return false;
    }
  }

  Widget _buildOneTimeRequestBtn() {
    return GestureDetector(
      onTap: () async {
        _showNationalIDDialog();
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Emergency? ',
              style: TextStyle(
                color: firstColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'One Time Request!',
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

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: firstColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: TextStyle(
            color: firstColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
