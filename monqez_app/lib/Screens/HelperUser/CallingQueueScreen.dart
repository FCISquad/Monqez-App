import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/CallPage.dart';
import 'package:monqez_app/Screens/Model/Helper.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CallingQueueScreen extends StatefulWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ratings',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: CallingQueueScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  _CallingQueueScreenState createState() => _CallingQueueScreenState();
}

class _CallingQueueScreenState extends State<CallingQueueScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> _calls = <Widget>[];
  bool _isLoading = true;

  void iterateJson(String jsonStr) {
    _calls = <ListTile>[];
    List<dynamic> calls = json.decode(jsonStr);
    int counter = 1;

    calls.forEach((call) {
      var singleCall = call as Map<String, dynamic>;
      String channelID = singleCall['channelID'];
      String type = singleCall['type'];
      String data = singleCall['data'];
      String severity = singleCall['severity'];
      String name = singleCall['name'];
      //String date = singleCall['date'];
      IconData icon;
      if (type == "video") {
        icon = Icons.video_call;
      } else {
        icon = Icons.call;
      }

      _calls.add(getCard(name, data, icon, double.parse(severity),
          MediaQuery.of(context).size.width, channelID));
    });
  }

  getAllApplications() async {
    _isLoading = true;
    var token = Provider.of<Helper>(context, listen: false).token;

    final http.Response response = await http.post(
      Uri.parse('$url/helper/get_call_queue/'),
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
        _isLoading = false;
      });
      return true;
    } else {
      print(response.statusCode);
      setState(() {
        _isLoading = false;
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    //callController.addListener();
  }

  Widget getCard(String name, String comment, IconData icon, double rating,
      double width, String channelID) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallPage(channelName: channelID),
              ))
        },
        child: Container(
          width: width,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: firstColor,
            elevation: 6,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  title: getTitle(name, 24, secondColor, TextAlign.start, true),
                  trailing: Icon(
                    icon,
                    size: 45,
                    color: secondColor,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  title: getTitle(
                      comment, 16, secondColor, TextAlign.start, false),
                  trailing: getTitle("Severity: " + rating.toString(), 16,
                      secondColor, TextAlign.end, true),
                ),
                //ListT
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    } else
      return Scaffold(
        backgroundColor: secondColor,
        appBar: AppBar(
          title:
              getTitle("Call Queue", 22.0, secondColor, TextAlign.start, true),
          shadowColor: Colors.black,
          backgroundColor: firstColor,
          iconTheme: IconThemeData(color: secondColor),
          elevation: 4,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: Center(
                  child: getTitle(_calls.length.toString(), 22, secondColor,
                      TextAlign.center, true)),
            ),
          ],
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
                  vertical: 20.0,
                ),
                child: Column(children: [
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _calls.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _calls[index];
                      })
                ]),
              ),
            ),
          ),
        ),
      );
  }
}
