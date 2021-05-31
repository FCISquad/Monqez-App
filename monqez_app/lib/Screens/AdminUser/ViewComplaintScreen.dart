import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'AdminHomeScreen.dart';

// ignore: must_be_immutable
class ViewComplaintScreen extends StatefulWidget {
  String complainerID;
  String date;
  String complainedID;
  ViewComplaintScreen(String complainerID, String date, String complainedID) {
    this.complainerID = complainerID;
    this.date = date;
    this.complainedID = complainedID;
  }
  @override
  _ViewComplaintScreenState createState() =>
      _ViewComplaintScreenState(complainerID, complainedID, date);
}

class _ViewComplaintScreenState extends State<ViewComplaintScreen> {
  bool isLoading = true;
  String complaintID;
  Color color = Colors.white;
  String path;

  String complainerName;
  String complainedName;
  String complainerUID;
  String complainedUID;
  String complaint;
  String date;
  String subject;

  parseJson(var json) {
    var singleComplaint = jsonDecode(json).cast<String, dynamic>();

    complainerName = singleComplaint['complainerName'];
    complainedName = singleComplaint['complainedName'];
    complainerUID = singleComplaint['complainerUID'];
    complainedUID = singleComplaint['complainedUID'];
    complaint = singleComplaint['complaint'];
    subject = singleComplaint['subject'];
  }

  Future<void> getComplaint() async {
    String token = AdminHomeScreenState.token;

    final http.Response response = await http.post(
      Uri.parse('$url/admin/getComplaint/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'nuid': complainerUID,
        'huid': complainedUID,
        'date': date
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      parseJson(response.body);
      setState(() {
        isLoading = false;
      });
      return true;
    } else {
      makeToast("An error has occured");
      print(response.statusCode);
      Navigator.pop(context);
      return false;
    }
  }

  _ViewComplaintScreenState(
      String complainerID, String complainedID, String date) {
    this.complainerUID = complainerID;
    this.date = date;
    this.complainedUID = complainedID;
    getComplaint();

/*
    this.complainerName = "Hussien";
    this.complainedName = "Ehab";
    this.complaint =
        "This is a really huge complaint that i wrote coz i am bored and i want to see how it looks and how will it be divided";
  */
  }

  archieve() async {
    String token = AdminHomeScreenState.token;
    final http.Response response = await http.post(
      Uri.parse('$url/admin/archieve_complaint/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'complaintID': complaintID,
        'date': DateTime.now().toString(),
      }),
    );
    if (response.statusCode == 200) {
      makeToast("Archieved Successfully");
    } else if (response.statusCode == 503) {
      makeToast("An admin has already reviewed this complaint!");
    } else {
      print(response.statusCode);
    }
  }

  mail() async {
    String token = AdminHomeScreenState.token;
    final http.Response response = await http.post(
      Uri.parse('$url/admin/mail_complaint_warning/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'complaintID': complaintID,
        'complainedUID': complainedUID,
      }),
    );
    if (response.statusCode == 200) {
      makeToast("Warning Sent");
    } else if (response.statusCode == 503) {
      makeToast("An admin has already reviewed this complaint!");
    } else {
      print(response.statusCode);
    }
  }

  ban() async {
    String token = AdminHomeScreenState.token;
    final http.Response response = await http.post(
      Uri.parse('$url/admin/ban/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'uid': complainedUID,
      }),
    );
    if (response.statusCode == 200) {
      makeToast("User Banned");
    } else if (response.statusCode == 503) {
      makeToast("An admin has already reviewed this complaint!");
    } else {
      print(response.statusCode);
    }
  }

  @override
  initState() {
    super.initState();
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
          title: Text('Monqez - View Complaint'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    AutoSizeText(
                      "Complainer Name: ",
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: 20.0,
                      ),
                    ),
                    AutoSizeText(complainerName,
                        maxLines: 1,
                        style: TextStyle(
                            color: firstColor,
                            letterSpacing: 1,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    AutoSizeText(
                      "Complained Name: ",
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: 20.0,
                      ),
                    ),
                    AutoSizeText(
                      complainedName,
                      maxLines: 1,
                      style: TextStyle(
                        color: firstColor,
                        letterSpacing: 1,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    AutoSizeText(
                      "Subject: ",
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: 20.0,
                      ),
                    ),
                    AutoSizeText(subject,
                        maxLines: 1,
                        style: TextStyle(
                            color: firstColor,
                            letterSpacing: 1,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Complaint:",
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    border: Border.all(color: firstColor),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: secondColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      complaint,
                      style: TextStyle(fontSize: 30.0),
                      maxLines: 6,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                              elevation: 5.0,
                              onPressed: () {
                                archieve();
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.green,
                              child: AutoSizeText("Archieve",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: secondColor,
                                    letterSpacing: 1,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                      ),
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                              elevation: 5.0,
                              onPressed: () {
                                mail();
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: firstColor,
                              child: AutoSizeText("Mail",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: secondColor,
                                    letterSpacing: 1,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ),
                      ),
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              ban();
                              Navigator.pop(context);
                              //navigate(LoginScreen(), context, true);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.red,
                            child: AutoSizeText("Ban",
                                maxLines: 1,
                                style: TextStyle(
                                  color: secondColor,
                                  letterSpacing: 1,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }
}
