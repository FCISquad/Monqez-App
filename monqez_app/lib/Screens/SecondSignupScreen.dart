import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'UI.dart';
import 'HomeScreenMap.dart';


class SecondSignupScreen extends StatefulWidget {
  @override
  _SecondSignupScreenState createState() => _SecondSignupScreenState();
}

class _SecondSignupScreenState extends State<SecondSignupScreen> {
  var _prefs;
  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();
  var _idController = TextEditingController();
  var token;
  var uid;

  String _fileName= "File Path";
  List<String> _types = ["pdf", "jpg", "png"];
  List<PlatformFile> _paths;

  bool _isMonqez = false;

  void makeToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<String> intializeData() async {
    await Firebase.initializeApp();
    _prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser != null)
    {
      token = await FirebaseAuth.instance.currentUser.getIdToken();
      uid = _prefs.get("userID");
    }
  }
  Future<void> _submit() async {
    await intializeData();
    print("Token: " + token);
    print("Uid: " + uid);
    makeToast("Submitted");
    final http.Response response = await http.post(
      'https://lucky-crab-97.loca.lt/signup/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'uid': uid,
        'name': _nameController.text,
        'national_id': _idController.text,
        'phone': _phoneController.text
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, animationTime, child) {
                return SlideTransition(
                  position:
                  Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                      .animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.ease,
                  )),
                  child: child,
                );
              },
              pageBuilder: (context, animation, animationTime) {
                return HomeScreenMap();
              }));
      //return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        //allowedExtensions: _types
      ))
          ?.files;
    } on PlatformException catch (e) {
      makeToast("Unsupported operation" + e.toString());
    } catch (ex) {
      makeToast(ex);
    }
    if (!mounted) return;
    setState(() {
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  Widget _buildCheckBox(){
    return CheckboxListTile(
      title: Text("Signup as Monqez?",           style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      ),
      value: _isMonqez,
      onChanged: (newValue) {
        setState(() {
          _isMonqez = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
    );
  }


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
            controller: _nameController,
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
            controller: _phoneController,
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
            controller: _idController,
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

  Widget _buildCertificateTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "First-Aid Certificate",
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
            readOnly: true,
            style: TextStyle(
              color: Colors.deepOrange,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.book,
                color: Colors.deepOrange,
              ),
              suffixIcon: GestureDetector(
                onTap: _openFileExplorer,
                child: Icon(
                  Icons.file_copy,
                  color: Colors.deepOrange,
                ),
              ),
              hintText: _fileName,
              hintStyle: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildSubmitBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      height: 90,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _submit,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Submit',
          style: TextStyle(
            color: Colors.deepOrange,
            letterSpacing: 1,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    'Add additional information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _buildNameTF(),
                  SizedBox(height: 10.0),
                  _buildPhoneNumberTF(),
                  SizedBox(height: 10.0),
                  _buildIDNumberTF(),
                  SizedBox(height: 10.0),
                  _buildCheckBox(),
                  SizedBox(height: 10.0),
                  Visibility(
                      visible: _isMonqez,
                      child: _buildCertificateTF()),
                  SizedBox(height: 200.0),
                  _buildSubmitBtn()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}