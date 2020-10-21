import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:monqez_app/Screens/SecondSignupScreen.dart';
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

  Future<void> _signup() async {
    var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    /*print("HUSIEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEN");
    print(result); ///TO DELETE
     */
    if (result != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SecondSignupScreen()),
      );
    } else {
      print('please try later');
    }
  }

  void _validateEmail(String text) {
    setState(() {
      _emailError =
          (EmailValidator.validate(text)) ? '' : "Email is not correct";
    });
    return;
  }

  void _validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    setState(() {
      _emailError =
      (!regex.hasMatch(value)) ? '' : "Password is not correct";
    });

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
              hintText: 'Enter your Password',
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
              hintText: 'Re-enter your Password',
              hintStyle: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
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
        onPressed: _signup,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'SIGNUP',
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

  Widget _buildSigninBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
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
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign in',
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
                    'Sign Up',
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
                  _buildSigninBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
