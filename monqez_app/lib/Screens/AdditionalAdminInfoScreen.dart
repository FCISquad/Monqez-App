import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:monqez_app/Screens/AdminUser/AdminHomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI.dart';
import '../Backend/Authentication.dart';

class AdditionalAdminInfoScreen extends StatefulWidget {
  @override
  _AdditionalAdminInfoScreenState createState() => _AdditionalAdminInfoScreenState();
}

class _AdditionalAdminInfoScreenState extends State<AdditionalAdminInfoScreen> {
  var _prefs;
  var _nameController = TextEditingController();
  var _phoneController = TextEditingController();
  var _idController = TextEditingController();
  var _countryController = TextEditingController();
  var _cityController = TextEditingController();
  var _streetController = TextEditingController();
  var _buildNumberController = TextEditingController();
  var token;
  var uid;
  String _fullNameError = '';
  String _phoneNumberError = '';
  String _nationalIdError = '';
  String _addressError = '';

  bool _correctFullName = false;
  bool _correctPhoneNumber = false;
  bool _correctNationalId = false;
  bool _correctAddress = false;

  String gender;
  DateTime selectedDate = DateTime.now();

  void makeToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
  bool _validateAllFields(){
    if(_correctFullName && _correctPhoneNumber && _correctNationalId && _correctAddress){
      return true ;
    }
    else{
      return false ;
    }
  }

  void _validateFullName(String text) {
    setState(() {
      if (text.isEmpty) {
        _fullNameError = "You must enter your full name";
        _correctFullName = false;
      } else {
        _fullNameError = "";
        _correctFullName = true;
      }
    });
    return;
  }

  void _validatePhoneNumber(String text) {
    setState(() {
      if (text.isEmpty) {
        _phoneNumberError = "Phone number is required";
        _correctPhoneNumber = false;
      } else if (text.length != 11) {
        _phoneNumberError = "Phone number is incorrect";
        _correctPhoneNumber = false;
      } else {
        _phoneNumberError = "";
        _correctPhoneNumber = true;
      }
    });
    return;
  }

  void _validateNationalId(String text) {
    setState(() {
      if (text.isEmpty) {
        _nationalIdError =
            "National ID number is required";
        _correctNationalId = false;
      }
      else if (text.length != 14 ){
        _nationalIdError =
        "National ID number is incorrect";
        _correctNationalId = false;
      }
      else {
        _nationalIdError = "";
        _correctNationalId = true;
      }
    });
    return;
  }
  Widget getTitle(String text) {
    return  Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  void _validateAddress(String text) {
    setState(() {
      if (_cityController.text.isEmpty || _streetController.text.isEmpty || _buildNumberController.text.isEmpty || _countryController.text.isEmpty) {
        _addressError = "Please enter your address correctly";
        _correctAddress = false;
      } else {
        _addressError = "";
        _correctAddress = true;
      }
    });
    return;
  }


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

  Future<void> intializeData() async {
    _prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser != null) {
      token = await FirebaseAuth.instance.currentUser.getIdToken();
      uid = _prefs.get("userID");
    }
  }

  void _click() {
    if (_validateAllFields()){
      _adminData();
    } else {
      makeToast("Data is incomplete");
    }
  }

  Future<void> _adminData() async {
    await intializeData();
    print("Token: " + token);
    print("Uid: " + uid);

    final http.Response response = await http.post(
        '$url/admin/addAdditionalInformation/',
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      body: jsonEncode(<String, String>{
        'token': token,
        'uid': uid,
        'name': _nameController.text,
        'national_id': _idController.text,
        'phone': _phoneController.text,
        'birthdate': selectedDate.toString(),
        'gender': gender,
        'country': _countryController.text,
        'city': _cityController.text,
        'street': _streetController.text,
        'buildNumber': _buildNumberController.text,
      }),
    );
    if (response.statusCode == 200){
      makeToast("Information Added Successfully!");
      navigateReplacement(AdminHomeScreen());
      return true;
    }
    else {
      print(response.statusCode);
      throw Exception('Failed to create user.');
    }
  }

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getTitle("Full Name"),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            keyboardType: TextInputType.name,
            controller: _nameController,
            onChanged: _validateFullName,
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
        SizedBox(height: 5.0),
        Visibility(
          child: Text(
            _fullNameError,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          visible:  _fullNameError.isNotEmpty,
        ),
      ],
    );
  }

  Widget _buildPhoneNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getTitle("Phone Number"),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            onChanged: _validatePhoneNumber,
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
        SizedBox(height: 5.0),
        Visibility(
          child: Text(
            _phoneNumberError,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          visible: _phoneNumberError.isNotEmpty,
        ),
      ],
    );
  }

  Widget _buildIDNumberTF() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getTitle("ID Number"),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 50.0,
            child: TextField(
              controller: _idController,
              onChanged: _validateNationalId,
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
          Visibility(
            child: Text(
              _nationalIdError,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            visible: _nationalIdError.isNotEmpty,
          ),
        ]);
  }

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getTitle("Date of Birth"),
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
            onTap: _selectDate,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: GestureDetector(
                onTap: _selectDate,
                child: Icon(
                  Icons.date_range,
                  color: Colors.deepOrange,
                ),
              ),
              hintText: "${selectedDate.toLocal()}".split(' ')[0],
              hintStyle: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getTitle("Address"),
        SizedBox(height: 10.0),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 2.55,
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle,
                  child: TextFormField(
                    controller: _countryController,
                    onChanged: _validateAddress,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 14.0),
                      hintText: "Country",
                      hintStyle: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                  )),
              Container(
                  width: MediaQuery.of(context).size.width / 2.55,
                  alignment: Alignment.centerRight,
                  decoration: kBoxDecorationStyle,
                  child: TextFormField(
                    controller: _cityController,
                    onChanged: _validateAddress,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 14.0),
                      hintText: "City",
                      hintStyle: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                  ))
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 2.55,
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle,
                  child: TextFormField(
                    controller: _streetController,
                    onChanged: _validateAddress,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 14.0),
                      hintText: "Street",
                      hintStyle: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                  )),

              Container(
                  width: MediaQuery.of(context).size.width / 2.55,
                  alignment: Alignment.centerRight,
                  decoration: kBoxDecorationStyle,
                  child: TextFormField(
                    controller: _buildNumberController,
                    onChanged: _validateAddress,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontFamily: 'OpenSans',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 14.0),
                      hintText: "Build Number",
                      hintStyle: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Visibility(
          child: Text(
          _addressError,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
          ),
          visible: !_addressError.isEmpty,
        )
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
        onPressed: _click,
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

  Widget addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Colors.white,
          focusColor: Colors.blue,
          value: title,
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = value;
            });
          },
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
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
                horizontal: MediaQuery.of(context).size.width*0.1,
                vertical: 60.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Add Additional Admin Information',
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
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildDatePicker(context),
                  SizedBox(height: 10.0),
                  _buildAddress(),
                  SizedBox(height: 20.0),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 20,
                    child: getTitle("Gender")
                  ),
                  Row(
                    children: <Widget>[
                      addRadioButton(1, "Male"),
                      addRadioButton(2, "Female"),
                    ]
                  ),
                  SizedBox(height: 10.0),
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
