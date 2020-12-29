import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/AdminUser/AddNewAdminScreen.dart';
import 'package:monqez_app/Screens/AdminUser/ApplicationsScreen.dart';
import 'package:monqez_app/Screens/AdminUser/ComplaintsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monqez_app/Backend/Authentication.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  AdminHomeScreenState createState() => AdminHomeScreenState();
}

class AdminHomeScreenState extends State<AdminHomeScreen> {
  bool isLoading = true;
  int applicationNumber;
  static String token;
  AdminHomeScreenState() {
    applicationNumber = 0;
    getToken();
  }

  Future<void> getState() async{
    String token = AdminHomeScreenState.token;
    final http.Response response = await http.post(
        '$url/admin/get_state/',
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
    );

    if (response.statusCode == 200){
      var parsed = jsonDecode(response.body).cast<String, dynamic>();
      applicationNumber = parsed['snapshot'];
      return true;
    }
    else{
      print(response.statusCode);
      return false;
    }
  }
  Future<void> getToken() async {
    var _prefs = await SharedPreferences.getInstance();
    AdminHomeScreenState.token = _prefs.getString("userToken");
    await getState();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold (
          backgroundColor: Colors.white,
          body: Container(
              height: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.white, strokeWidth: 5, valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent)
                  )
              )
          )
      );
    } else return Scaffold(
        appBar: AppBar(
          title: Text('Monqez - Admin'),
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
                        _card(applicationNumber.toString(), "New Applications", Icons.file_copy,
                            ApplicationsScreen()),
                        _card("100", "New Complaints", Icons.thumb_down_sharp,
                            ComplaintsScreen()),
                      ],
                    ),/*
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
            )])));
  }

  Widget _card(String firstText, String secondText, IconData icon, Widget map) {
    return GestureDetector(
      onTap: () => navigate(map),
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

  void navigate(Widget map) {
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
              return map;
            }));
  }
}
