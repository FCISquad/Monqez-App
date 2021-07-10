import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/AdminUser/AdminHomeScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monqez_app/Screens/AdminUser/ViewComplaintScreen.dart';

class ComplaintsScreen extends StatefulWidget {
  @override
  _ComplaintsScreenState createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  bool isLoading = true;
  List<ListTile> complaintsList = <ListTile>[];

  void iterateJson(String jsonStr) {
    complaintsList = <ListTile>[];
    List<dynamic> complaints = json.decode(jsonStr);
    int counter = 1;

    complaints.forEach((complaint) {
      //var singleComplaint = complaints as Map<String, dynamic>;
      String nuid = complaint['nuid'];
      String helperUid = complaint['huid'];
      String name = complaint['name'];
      String date = complaint['date'];
      complaintsList.add(ListTile(
          title: Text('Complaint from $name'),
          subtitle: Text("On $date"),
          leading: Text('$counter'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => navigate(ViewComplaintScreen(nuid, date, helperUid))));
      counter++;
    });
  }

  getAllComplaints() async {
    isLoading = true;
    String token = AdminHomeScreenState.token;
    final http.Response response = await http.post(
      Uri.parse('$url/admin/getComplaints/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      iterateJson(response.body);
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

  _ComplaintsScreenState() {
    getAllComplaints();
/*
    complaintsList.add(ListTile(
      title: Text('Complaint from "Hussien"'),
      subtitle: Text("On Today"),
      leading: Text('1'),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => navigate(ViewComplaintScreen("1")),
    ));
    */
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
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
    else
      return Scaffold(
          appBar: AppBar(
            title: Text('Monqez - Complaints'),
          ),
          body: Container(
            child: _myListView(context),
          ));
  }

  Widget _myListView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getAllComplaints();
        return true;
      },
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: complaintsList.length,
          itemBuilder: (BuildContext context, int index) {
            return complaintsList[index];
          }),
    );
    // return ListView.separated(
    //   itemCount: 100,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title: Text('Application from Name'),
    //       subtitle: Text('Name of the pdf'),
    //       leading: Text('$index'),
    //       trailing: Icon(Icons.keyboard_arrow_right),
    //       onTap: () => navigate(ViewApplicationScreen()),
    //     );
    //   },
    //   separatorBuilder: (context, index) {
    //     return Divider();
    //   },
    // );
  }

  void navigate(Widget map) async {
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
    getAllComplaints();
  }
}
