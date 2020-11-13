import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:monqez_app/Screens/HelperUser/HelperHomeScreen.dart';
import 'package:monqez_app/Screens/NormalUser/NormalHomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI.dart';
import 'LoginScreen.dart';
import '../Backend/Authentication.dart';

class SecondSignupScreen extends StatefulWidget {
  @override
  _SecondSignupScreenState createState() => _SecondSignupScreenState();
}

class _SecondSignupScreenState extends State<SecondSignupScreen> {
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
  String _countryError = '';
  String _cityError = '';
  String _buildNumberError = '';
  String _streetError = '';

  bool _correctFullName = false;
  bool _correctPhoneNumber = false;
  bool _correctNationalId = false;
  bool _correctStreet = false;
  bool _correctCity = false;
  bool _correctCountry = false;
  bool _correctBuildNumber = false;

  String gender;
  DateTime selectedDate = DateTime.now();
  File imageFile;
  String _fileName = "File Path", _imageName = "Image Path";
  //List<String> _types = ["pdf", "jpg", "png"];
  FilePickerResult _path;
  File certificateFile;

  bool _isMonqez = false;

  void makeToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
  bool _validateAllFields(){
    if(_correctFullName && _correctPhoneNumber
        && _correctNationalId &&_correctCountry && _correctCity && _correctStreet && _correctBuildNumber){
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
        _phoneNumberError = "You must enter your phone number";
        _correctPhoneNumber = false;
      } else if (text.length < 11) {
        _phoneNumberError = "your phone number must be 11 numbers";
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
            "please enter your national id number or upload an image of your national id";
        _correctNationalId = false;
      } else {
        _nationalIdError = "";
        _correctNationalId = true;
      }
    });
    return;
  }

  void _validateCountry(String text) {
    setState(() {
      if (text.isEmpty) {
        _countryError = "please enter your country";
        _correctCountry = false;
      } else {
        _countryError = "";
        _correctCountry = true;
      }
    });
    return;
  }

  void _validateCity(String text) {
    setState(() {
      if (text.isEmpty) {
        _cityError = "please enter your city";
        _correctCity = false;
      } else {
        _cityError = "";
        _correctCity = true;
      }
    });
    return;
  }

  void _validateStreet(String text) {
    setState(() {
      if (text.isEmpty) {
        _streetError = "please enter your street";
        _correctStreet = false;
      } else {
        _streetError = "";
        _correctStreet = true;
      }
    });
    return;
  }

  void validateBuildNumber(String text) {
    setState(() {
      if (text.isEmpty) {
        _buildNumberError = "please enter your build number";
        _correctBuildNumber = false;
      } else {
        _buildNumberError = "";
        _correctBuildNumber = true;
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
      if (_isMonqez) {
        _apply();
      } else {
        _submit();
      }
    } else {
      makeToast("Data is not correct");
    }
  }

  Future<void> _submit() async {
    await intializeData();
    print("Token: " + token);
    print("Uid: " + uid);

    final http.Response response = await http.post(
      '$url/signup/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
        'buildNumber': _buildNumberController.text
      }),
    );

    if (response.statusCode == 200) {
      makeToast("Submitted");
      navigateReplacement(_isMonqez ? HelperHomeScreen() : NormalHomeScreen());
    } else {
      makeToast('Failed to submit user.');
    }
  }

  Future<void> _apply() async {
    await intializeData();
    print("Token: " + token);
    print("Uid: " + uid);

    String base64Image = base64Encode(certificateFile.readAsBytesSync());
    final http.Response response = await http.post(
      '$url/apply/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
        'certificate': base64Image,
        'certificateName': _fileName
      }),
    );

    if (response.statusCode == 200) {
      makeToast("Please wait while your application is reviewed");
      logout();
      navigateReplacement(LoginScreen());
      //return Album.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception('Failed to create album.');
    }
  }

  void _uploadCertificate() async {
    try {
      _path = (await FilePicker.platform.pickFiles());
      /*
        type: FileType.any,
        allowMultiple: false,
        //allowedExtensions: _types
      ))
          ?.files;
         */
    } on PlatformException catch (e) {
      makeToast("Unsupported operation" + e.toString());
    } catch (ex) {
      makeToast(ex);
    }
    if (!mounted) return;
    setState(() {
      certificateFile = File(_path.files.single.path);
      _fileName = certificateFile.path.split("/").last;
    });
  }

  ///ERRORS HERE
  void _uploadID() async {
    try {
      _path = (await FilePicker.platform.pickFiles());
      /*
        type: FileType.any,
        allowMultiple: false,
        //allowedExtensions: _types
      ))
          ?.files;

       */
    } on PlatformException catch (e) {
      makeToast("Unsupported operation" + e.toString());
    } catch (ex) {
      makeToast(ex);
    }
    if (!mounted) return;
    setState(() {
      imageFile = File(_path.files.single.path);
      _imageName = imageFile.path.split("/").last;
    });
  }

  Widget _buildCheckBox() {
    return CheckboxListTile(
      title: Text(
        "Signup as Monqez?",
        style: TextStyle(
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
      controlAffinity:
          ListTileControlAffinity.trailing, //  <-- leading Checkbox
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
        Text(
          _fullNameError,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        Text(
          _phoneNumberError,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                suffixIcon: GestureDetector(
                  onTap: () {
                    _buildImagePicker(context);
                  },
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.deepOrange,
                  ),
                ),
                hintText: 'Enter your ID Number',
                hintStyle: TextStyle(
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            _nationalIdError,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Visibility(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageName = "Image Path";
                      imageFile = null;
                    });
                  },
                  child: Icon(
                    Icons.highlight_remove,
                    color: Colors.white,
                  ),
                ),
                hintText: _imageName,
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            visible: _imageName != "Image Path",
          )
        ]);
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
                onTap: _uploadCertificate,
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
        Text(
          "Date of birth",
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
        Text(
          "Address",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
                    controller: _countryController,
                    onChanged: _validateCountry,
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
              SizedBox(height: 5.0),
              Text(
                _countryError,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),


              Container(
                  width: MediaQuery.of(context).size.width / 2.55,
                  alignment: Alignment.centerRight,
                  decoration: kBoxDecorationStyle,
                  child: TextFormField(
                    controller: _cityController,
                    onChanged: _validateCity,
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
        /*SizedBox(height: 5.0),
        Text(
          _cityError,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

         */
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
                    onChanged: _validateStreet,
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
              /*SizedBox(height: 5.0),
              Text(
                _streetError,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

               */
              Container(
                  width: MediaQuery.of(context).size.width / 2.55,
                  alignment: Alignment.centerRight,
                  decoration: kBoxDecorationStyle,
                  child: TextFormField(
                    controller: _buildNumberController,
                    onChanged: validateBuildNumber,
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
              /*SizedBox(height: 5.0),
              Text(
                _buildNumberError,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),

               */

            ],
          ),
        )
      ],
    );
  }

  void _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    //Navigator.of(context).pop();
  }

  void _buildImagePicker(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _uploadID();
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
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
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildDatePicker(context),
                  SizedBox(height: 10.0),
                  _buildAddress(),
                  SizedBox(height: 10.0),
                  addRadioButton(1, "Male"),
                  addRadioButton(2, "Female"),
                  SizedBox(height: 10.0),
                  _buildCheckBox(),
                  SizedBox(height: 10.0),
                  Visibility(visible: _isMonqez, child: _buildCertificateTF()),
                  SizedBox(height: 20.0),
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
