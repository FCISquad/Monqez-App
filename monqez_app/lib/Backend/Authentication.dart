import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
var _prefs = SharedPreferences.getInstance();

Future<bool> saveUserToken(String token, String email, String userID) async {
  final SharedPreferences prefs = await _prefs;
  prefs.setString("email", email);
  prefs.setString("userID", userID);
  return prefs.setString("userToken", token);
}

void makeToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

Future<bool> signup( TextEditingController _emailController,
    TextEditingController _passwordController ) async {
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      if (result != null) {
        makeToast("Signup successful");
        return true;

      } else {
        makeToast('Please try later');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        makeToast('Email already exists!');
        return false;
      } else {
        makeToast(e.code);
        return false;
      }

  }
}




Future<bool> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  try {
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      var token = await FirebaseAuth.instance.currentUser.getIdToken();

      saveUserToken(token, authResult.user.email, authResult.user.uid);

      makeToast("Logged in successfully!");

      return true;
    }
  } on FirebaseAuthException catch (e) {
    makeToast(e.code);
    return false;
  }
  return false;
}

Future<bool> normalSignIn(TextEditingController _emailController,
    TextEditingController _passwordController) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

    var token = await FirebaseAuth.instance.currentUser.getIdToken();
    saveUserToken(token, userCredential.user.email, userCredential.user.uid);

    makeToast("Logged in Successfully");

    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      makeToast('Email not found!');
      return false;
    } else if (e.code == 'wrong-password') {
      makeToast('Wrong password!');
      return false;
    } else {
      makeToast(e.code);
      return false;
    }
  }
}
//not used
Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Signed Out");
}

void logout () async {
  var _prefs = await SharedPreferences.getInstance();
  _prefs.remove('email');
  _prefs.remove('userID');
  _prefs.remove('userToken');
  makeToast('Logged out!');
}

