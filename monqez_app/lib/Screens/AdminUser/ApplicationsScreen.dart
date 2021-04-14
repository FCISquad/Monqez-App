import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/AdminUser/AdminHomeScreen.dart';
import 'package:monqez_app/Screens/AdminUser/ViewApplicationScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApplicationsScreen extends StatefulWidget {
  @override
  _ApplicationsScreenState createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  bool isLoading = true;
  List<ListTile> applicationsList;

  void iterateJson(String jsonStr) {
    applicationsList = <ListTile>[];
    List<dynamic> applications = json.decode(jsonStr);
    int counter = 1;

    applications.forEach((application) {
      var singleApplication = application as Map<String, dynamic>;
      String uid = singleApplication['uid'];
      String name = singleApplication['name'];
      String date = singleApplication['date'];
      applicationsList.add(ListTile(
        title: Text('Application from $name'),
        subtitle: Text("On $date"),
        leading: Text('$counter'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => navigate(ViewApplicationScreen(uid)),
      ));
      counter++;
    });
  }

  getAllApplications() async {
    isLoading = true;
    String token = AdminHomeScreenState.token;
    final http.Response response = await http.post(
      Uri.parse('$url/admin/get_application_queue/'),
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

  _ApplicationsScreenState() {
    getAllApplications();
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
            title: Text('Monqez - Applications'),
          ),
          body: Container(
            child: _myListView(context),
          ));
  }

  Widget _myListView(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: applicationsList.length,
        itemBuilder: (BuildContext context, int index) {
          return applicationsList[index];
        });
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
    getAllApplications();
  }
}
