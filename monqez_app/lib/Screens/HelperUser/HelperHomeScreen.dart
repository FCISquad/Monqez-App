import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:monqez_app/Screens/HelperUser/CallingQueueScreen.dart';
import 'package:monqez_app/Screens/HelperUser/ChatQueue.dart';
import 'package:monqez_app/Screens/HelperUser/RatingsScreen.dart';
import 'file:///F:/FlutterApps/GP/monqez_app/lib/Screens/Utils/Profile.dart';
import 'package:monqez_app/Screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/Model/User.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monqez',
      theme: ThemeData(
        primarySwatch: primary,
      ),
      home: HelperHomeScreen(""),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ignore: must_be_immutable
class HelperHomeScreen extends StatefulWidget {
  String token;
  HelperHomeScreen(String token) {
    this.token = token;
  }
  @override
  HelperHomeScreenState createState() => HelperHomeScreenState(token);
}

class HelperHomeScreenState extends State<HelperHomeScreen> with SingleTickerProviderStateMixin {
  static User user;
  String _status;
  List<String> _statusDropDown;
  List<Icon> icons ;
  bool _isLoading = true;

  HelperHomeScreenState(String token) {
    Future.delayed(Duration.zero, ()
    async {
      user = new User(token);
      await user.getHelper();
      _isLoading = false;
      _status = user.status;
    });
  }


  @override
  void initState()  {
    _statusDropDown = <String> ["Available", "Contacting only", "Busy"];
    _status = _statusDropDown[0];
    super.initState();
  }

  Widget getCard(String title, String trail, Widget nextScreen, IconData icon, double width) {
    return Card (
      elevation: 0,
      color: Colors.transparent,
      child: Container(

        width: width,
        child: Card(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: firstColor,
          elevation: 4,
          child: Column(

            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              ListTile(
                onTap : () => navigate(nextScreen, context, false),
                contentPadding: EdgeInsets.fromLTRB(10,10,10,0),
                title: Icon(icon, size: 70, color: secondColor,),
              ),
              ListTile(
                onTap: () => navigate(nextScreen, context, false),
                leading: getTitle(title, 16, secondColor, TextAlign.center, true),
                trailing: getTitle(trail, 16, secondColor, TextAlign.center, true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> _getCurrentUserLocation() async {
    Position position;
    position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<void> changeStatus(newValue) async {
    if (newValue == "Available") {
      Position p = await _getCurrentUserLocation();
      print("Position" + p.longitude.toString() + ", " + p.latitude.toString() + "\n");
    }
    var _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString("userToken");
    final http.Response response = await http.post(
      '$url/helper/setstatus/',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'status': newValue
      }),
    );



    if (response.statusCode == 200) {
      makeToast("Submitted");
    } else {
      makeToast('Failed to submit user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold (
        backgroundColor: secondColor,
        body: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
                backgroundColor: secondColor, strokeWidth: 5, valueColor: new AlwaysStoppedAnimation<Color>(firstColor)
            )
          )
        )
      );
    } else return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
        title: getTitle("Monqez", 22.0, secondColor, TextAlign.start, true),
        shadowColor: Colors.black,
        backgroundColor: firstColor,
        iconTheme: IconThemeData(color: secondColor),
        elevation: 5,
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0,0,0,0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: firstColor,
                //hint: Text('Status'), // Not necessary for Option 1
                value: _status,
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue;
                    changeStatus(newValue);
                  });
                },
                items: _statusDropDown.map((location) {
                  return DropdownMenuItem(
                    child: SizedBox(
                      width: 140,
                      child: getTitle(location, 16, secondColor, TextAlign.end, true),
                    ),
                    value: location
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,

          children: <Widget>[
            DrawerHeader(
              child: Container(
                alignment: Alignment.centerLeft,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        getTitle(user.name, 26, secondColor, TextAlign.start, true),
                        Icon(Icons.account_circle_rounded, size: 90, color: secondColor),
                      ]
                  )
              ),
              decoration: BoxDecoration(
                color: firstColor,
              ),
            ),

            Container(
              color: secondColor,
              height: (MediaQuery.of(context).size.height)-200,
              child: Column(
                children: [
                  ListTile(
                    title: getTitle('My Profile', 18, firstColor, TextAlign.start, true),
                    leading: Icon(Icons.account_circle_rounded, size: 30, color: firstColor),
                    onTap: () {
                      Navigator.pop(context);
                      navigate(ProfileScreen(user), context, false);
                    },
                  ),
                  ListTile(
                    title: getTitle('Call Queue', 18, firstColor, TextAlign.start, true),
                    leading: Icon(Icons.call, size: 30, color: firstColor),
                    onTap: () {
                      Navigator.pop(context);
                      navigate(CallingQueueScreen(), context, false);
                    },
                  ),
                  ListTile(
                    title: getTitle('Chat Queue', 18, firstColor, TextAlign.start, true),
                    leading: Icon(Icons.chat, size: 30, color: firstColor),
                      onTap: () {
                        Navigator.pop(context);
                        navigate(ChatQueueScreen(), context, false);
                      },
                  ),
                  ListTile(
                    title: getTitle('My Ratings', 18, firstColor, TextAlign.start, true),
                    leading: Icon(Icons.star_rate, size: 30, color: firstColor),
                    onTap: () {
                      Navigator.pop(context);
                      navigate(HelperRatingsScreen(), context, false);
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 40,
                        width: 120,
                        child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            logout();
                            navigate(LoginScreen(), context, true);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: firstColor,
                          child: getTitle("Logout", 18, secondColor, TextAlign.start, true)
                        ),
                      ),
                    ),
                  )
                ]
              ),
            ),
          ],
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      getCard("Call Queue", "4", CallingQueueScreen(), Icons.call, (MediaQuery.of(context).size.width-40) / 2),
                      getCard("Chat Queue", "3", ChatQueueScreen(), Icons.chat, (MediaQuery.of(context).size.width-40) / 2),
                    ],
                  ),
                  getCard("Request Queue", "6", null, Icons.local_hospital, MediaQuery.of(context).size.width ),
                  getCard("My Ratings", "4.4", HelperRatingsScreen(), Icons.star_rate, MediaQuery.of(context).size.width),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}