import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/FirebaseCloudMessaging.dart';
import 'package:monqez_app/Backend/NotificationRoutes/AdminUserNotification.dart';
import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';
import 'package:monqez_app/Screens/AdminUser/AddNewAdminScreen.dart';
import 'package:monqez_app/Screens/AdminUser/ApplicationsScreen.dart';
import 'package:monqez_app/Screens/AdminUser/ComplaintsScreen.dart';
import 'package:monqez_app/Screens/Model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:monqez_app/Screens/Utils/Profile.dart';

import '../LoginScreen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  AdminHomeScreenState createState() => AdminHomeScreenState();
}

class AdminHomeScreenState extends State<AdminHomeScreen> {
  User user;
  bool isLoading = true;
  int applicationNumber;
  int complaintsNumber;
  static String token;

  AdminHomeScreenState() {
    applicationNumber = 0;
    complaintsNumber = 0;
    checkNotification();
    getToken();
  }

  Future<void> getState() async {
    String token = AdminHomeScreenState.token;
    user = new User.empty();
    user.setToken(token);
    await user.getUser();
    final http.Response response = await http.post(
      Uri.parse('$url/admin/get_state/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body).cast<String, dynamic>();
      applicationNumber = parsed['snapshot'];
      complaintsNumber = parsed['complaints'];
      setState(() {
        isLoading = false;
      });
      return true;
    } else {
      print(response.statusCode);
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  Future<void> getToken() async {
    var _prefs = await SharedPreferences.getInstance();
    AdminHomeScreenState.token = _prefs.getString("userToken");
    //Provider.of<User>(context, listen: false).setToken(token);
    await getState();
  }

  void checkNotification() async {
    Builder(
      builder: (BuildContext context) {
        FirebaseMessaging.instance
            .getInitialMessage()
            .then((RemoteMessage message) {
          FirebaseCloudMessaging.route =
              new AdminUserNotification(message, true);
          navigate(NotificationRoute.selectNavigate, context, false);
        });
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              height: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 5,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.deepOrangeAccent)))));
    } else
      return Scaffold(
          appBar: AppBar(
              title: getTitle(
                  "Monqez - Admin", 22.0, secondColor, TextAlign.start, true),
              shadowColor: Colors.black,
              backgroundColor: firstColor,
              iconTheme: IconThemeData(color: secondColor),
              elevation: 5),
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
                            getTitle(user.name, 26, secondColor,
                                TextAlign.start, true),
                            Container(
                              width: 90,
                              height: 90,
                              child: CircularProfileAvatar(
                                null,
                                child: user.image == null
                                    ? Icon(Icons.account_circle_rounded,
                                        size: 90, color: secondColor)
                                    : Image.memory(user.image.decode()),
                                radius: 100,
                                backgroundColor: Colors.transparent,
                                borderColor: user.image == null
                                    ? firstColor
                                    : secondColor,
                                elevation: 5.0,
                                cacheImage: true,
                                onTap: () {
                                  print('Tabbed');
                                }, // sets on tap
                              ),
                            ),
                          ])),
                  decoration: BoxDecoration(
                    color: firstColor,
                  ),
                ),
                Container(
                  color: secondColor,
                  height: (MediaQuery.of(context).size.height) - 200,
                  child: Column(children: [
                    ListTile(
                      title: getTitle(
                          'My Profile', 18, firstColor, TextAlign.start, true),
                      leading: Icon(Icons.account_circle_rounded,
                          size: 30, color: firstColor),
                      onTap: () {
                        //Navigator.pop(context);
                        navigate(ProfileScreen(user), context, false);
                      },
                    ),
                    ListTile(
                        title: getTitle('View Applications', 18, firstColor,
                            TextAlign.start, true),
                        leading:
                            Icon(Icons.file_copy, size: 30, color: firstColor),
                        onTap: () {
                          //Navigator.pop(context);
                          navigate(ApplicationsScreen(), context, false);
                        }),
                    ListTile(
                        title: getTitle('View Complaints', 18, firstColor,
                            TextAlign.start, true),
                        leading: Icon(Icons.thumb_down_sharp,
                            size: 30, color: firstColor),
                        onTap: () {
                          //Navigator.pop(context);
                          navigate(ComplaintsScreen(), context, false);
                        }),
                    ListTile(
                        title: getTitle(
                            'Add Admin', 18, firstColor, TextAlign.start, true),
                        leading: Icon(Icons.person_add_sharp,
                            size: 30, color: firstColor),
                        onTap: () {
                          // Navigator.pop(context);
                          navigate(AddNewAdminScreen(), context, false);
                        }),
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
                              child: getTitle("Logout", 18, secondColor,
                                  TextAlign.start, true)),
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  color: Colors.white,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          _card(
                              applicationNumber.toString(),
                              "New Applications",
                              Icons.file_copy,
                              ApplicationsScreen()),
                          _card(complaintsNumber.toString(), "New Complaints",
                              Icons.thumb_down_sharp, ComplaintsScreen()),
                        ],
                      ), /*
                    TableRow(
                      children: [
                        _card("Add New Admin", "", Icons.person_add_sharp,
                            ApplicationsScreen()),
                        Text(""),
                      ],
                    ),*/
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  color: Colors.white,
                  child: Table(children: [
                    TableRow(children: [
                      _card("Add New Admin", "", Icons.person_add_sharp,
                          AddNewAdminScreen()),
                    ]),
                  ]),
                )
              ])));
  }

  Widget _card(String firstText, String secondText, IconData icon, Widget map) {
    return GestureDetector(
      onTap: () => navigateA(map),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        elevation: 5,
        color: Colors.deepOrangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 16,
            bottom: 24,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Icon(icon, size: 20, color: Colors.white70),
              ),
              Text(firstText,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  )),
              Text(secondText,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigateA(Widget map) async {
    await Navigator.push(
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
    getState();
  }
}
