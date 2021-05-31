import 'dart:convert';
import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/Model/User.dart';
import 'package:monqez_app/Screens/NormalUser/BodyMap.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class HelperPreviousRequests extends StatefulWidget {
  User user;
  HelperPreviousRequests(this.user);

  @override
  _HelperPreviousRequestsState createState() =>
      _HelperPreviousRequestsState(this.user);
}

class _Request {
  String date;
  String username;
  int bodyMap;
  BodyMap avatar;
  String address;
  String forMe;
  String info;
  String gender;
  bool isExpanded = false;

  setAvatar(int bodyMap) {
    this.bodyMap = bodyMap;
    avatar = BodyMap.init(bodyMap, 150);
  }

  getAvatar() {
    return (avatar == null) ? BodyMap.init(0, 150) : avatar;
  }

  getName(int size) {
    return username.substring(0, min(username.length, size));
  }

  getAddress() {
    return address == null ? "" : address;
  }

  getForMe() {
    return forMe == null ? "" : forMe;
  }

  getInfo() {
    return info == null ? "" : info;
  }

  isValid() {
    return (date != null && username != null);
  }

  setDate(String date) {
    this.date = date.split(" ")[0];
  }
  show() {
    print("\n\n\n-------------------------------------------");
    print((date == null) ? "Null" : date.toString());
    print((username == null) ? "Null" : username);
    print((bodyMap == null) ? "Null" : bodyMap);
    print((address == null) ? "Null" : address);
    print((forMe == null) ? "Null" : forMe);
    print("\n\n\n-------------------------------------------");
  }
}

class _HelperPreviousRequestsState extends State<HelperPreviousRequests>
    with SingleTickerProviderStateMixin {
  bool isLoaded = false;
  User user;
  List requests = [];
  _HelperPreviousRequestsState(this.user);

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  Widget getText(String text, double fontSize, bool isBold, Color color) {
    return AutoSizeText(text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontFamily: 'Cairo',
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        maxLines: 1);
  }

  void _iterateJson(String jsonStr) {
    _Request request = _Request();
    if (jsonStr.isNotEmpty) {
      List<dynamic> requestsJson = json.decode(jsonStr);
      requestsJson[0].forEach((key, value) {
        if (key == 'request') {
          value.forEach((reqKey, reqVal){
            if (reqKey == 'additionalInfo') {
              reqVal.forEach((infoKey, infoVal){
                if (infoKey == "Address")
                  request.address = infoVal;
                else if (infoKey == "forMe")
                  request.forMe = infoVal;
                else if (infoKey == "avatarBody")
                  request.setAvatar(int.parse(infoVal));
                else if (infoKey == "Additional Notes")
                  request.info = infoVal;
              });
            }
          });
        } else if (key == 'user') {
          request.username = value['name'];
          request.gender = value['gender'];
        } else if (key == 'time') {
          request.setDate(value);
        }

          request.show();
          if (request.isValid()) requests.add(request);
      }
      );
    }
  }

  getRequests() {
    // will be http request
    _iterateJson('[{"request":{"accepted":{"counter":1,"name":"helper","status":"Accepted","uid_1":"7ebzDMMcWzUpJpBJzqYsajHFelg2"},"additionalInfo":{"Additional Notes":"juuuuuu","Address":"hggghh","avatarBody":"2184","forMe":"true"},"isFirst":true,"latitude":30.0101056,"longitude":31.1760987,"monqezCounter":1,"rejected":{"counter":0}},"user":{"birthdate":"2021-05-10 00:00:00.000","buildNumber":"b","chronicDiseases":"cgsjk","city":"vbj","country":"hh","gender":"Male","name":"normal","national_id":"56466469619499","phone":"67669400496","street":"nkn","token":"ei9g-LWmSz6MDulQx0teWG:APA91bEsD8Bo3d2IL4j165TFlM3b43WFnEJcsd3ZDgAVH7L9gbfJYxXguvhazFOqzfPCuoE5GC02jRpYw77NIqlvaf3a0H7WQnYDd8u0Fd9BqhuAdMIER8yzVQIFjBQ6zlPk1AftNBzf","type":"0"},"time":"2021-05-31 03:58:38"}]');
    setState(() {
      isLoaded = true;
    });
    return;
    String token = user.token;
    Future.delayed(Duration.zero, () async {
      http.Response response = await http.get(
        Uri.parse('$url/helper/get_requests'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',

          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        _iterateJson(response.body);
        setState(() {
          isLoaded = true;
        });
      } else {
        print(response.statusCode);
        makeToast("Error!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 100;
    double height =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) /
            100;
    if (width > height) {
      double temp = width;
      width = height;
      height = temp;
    }

    if (!isLoaded) {
      return Scaffold(
          backgroundColor: secondColor,
          body: Container(
              height: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                      backgroundColor: secondColor,
                      strokeWidth: 5,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(firstColor)))));
    } else
      return Scaffold(
        appBar: AppBar(
          title:
              getTitle("My Requests", 22.0, secondColor, TextAlign.start, true),
          shadowColor: Colors.black,
          backgroundColor: firstColor,
          iconTheme: IconThemeData(color: secondColor),
          elevation: 4,
        ),
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  width: width * 96,
                  height: height * 94,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              border: Border.all(
                                  color: Color.fromRGBO(249, 249, 249, 1),
                                  width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 2,
                              child: ExpansionPanelList(
                                animationDuration: Duration(seconds: 1),
                                dividerColor: Color.fromRGBO(249, 249, 249, 1),
                                expansionCallback: (int i, bool isExpanded) {
                                  print(requests.length);
                                  requests[i].isExpanded = !isExpanded;
                                  setState(() {
                                    print(i.toString() +
                                        ": " +
                                        requests[0].isExpanded.toString());
                                  });
                                },
                                children: requests.map((req) {
                                  return ExpansionPanel(
                                    canTapOnHeader: true,
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  getText("Request Date", 11,
                                                      false, Colors.black87),
                                                  getText(req.date, 11, true,
                                                      Colors.black87),
                                                ]),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  getText("User Name", 11,
                                                      false, Colors.black87),
                                                  getText(req.getName(10), 11,
                                                      true, Colors.black87),
                                                ]),
                                            Visibility(
                                              visible: req.address != null,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    getText("Address", 11,
                                                        false, Colors.black87),
                                                    getText(
                                                        req.getAddress(),
                                                        11,
                                                        true,
                                                        Colors.black87),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    body: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 150,
                                              child: req.getAvatar()),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Visibility(
                                            visible: req.info != null,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 25,
                                                    width: 115,
                                                    decoration: BoxDecoration(
                                                      color: Colors.deepOrange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: Center(
                                                      child: getText(
                                                          'Additional Notes',
                                                          11,
                                                          true,
                                                          Colors.black),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  getText(req.getInfo(), 11,
                                                      true, Colors.black)
                                                ],
                                              ),
                                            ),
                                          ),
                                          //SizedBox(height: 4,),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Visibility(
                                            visible: req.address != null,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 25,
                                                    width: 115,
                                                    decoration: BoxDecoration(
                                                      color: Colors.deepOrange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: Center(
                                                      child: getText(
                                                          'Injury Type',
                                                          11,
                                                          true,
                                                          Colors.black),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  getText(req.getAddress(), 11,
                                                      true, Colors.black)
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Visibility(
                                            visible: req.address != null,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 25,
                                                    width: 115,
                                                    decoration: BoxDecoration(
                                                      color: Colors.deepOrange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: Center(
                                                      child: getText(
                                                          'Gender',
                                                          11,
                                                          true,
                                                          Colors.black),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  getText(req.gender, 11,
                                                      true, Colors.black)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    isExpanded: req.isExpanded,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
