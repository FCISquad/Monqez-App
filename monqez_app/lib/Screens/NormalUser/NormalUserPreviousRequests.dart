import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/Model/User.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:http/http.dart' as http;

import 'BodyMap.dart';

// ignore: must_be_immutable
class NormalPreviousRequests extends StatefulWidget {
  User user;
  NormalPreviousRequests(this.user);

  @override
  _NormalPreviousRequestsState createState() =>
      _NormalPreviousRequestsState(this.user);
}

class _Request {
  String date;
  String helperName;
  int bodyMap;
  String address;
  String forMe;
  bool isExpanded = false;

  _Request(String key) {
    this.date = key.split(" ")[0];
  }

  getName(int size) {
    return helperName.substring(0, size);
  }

  isValid() {
    return (date != null &&
        helperName != null &&
        bodyMap != null &&
        address != null &&
        forMe != null);
  }

  show() {
    print("\n\n\n-------------------------------------------");
    print((date == null) ? "Null" : date.toString());
    print((helperName == null) ? "Null" : helperName);
    print((bodyMap == null) ? "Null" : bodyMap);
    print((address == null) ? "Null" : address);
    print((forMe == null) ? "Null" : forMe);
    print("\n\n\n-------------------------------------------");
  }
}

class _NormalPreviousRequestsState extends State<NormalPreviousRequests>
    with SingleTickerProviderStateMixin {
  bool isLoaded = false;
  User user;
  List requests = [];
  _NormalPreviousRequestsState(this.user);

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
    Map<String, dynamic> requestsJson = json.decode(jsonStr);
    requestsJson.forEach((key, value) {
      if (value["accepted"]["Counter"] != 0) {
        _Request request = _Request(key);
        value.forEach((requestKey, requestValue) {
          if (requestKey == "additionalInfo") {
            requestValue.forEach((infoKey, infoValue) {
              if (infoKey == "forMe")
                request.forMe = infoValue;
              else if (infoKey == "Address")
                request.address = infoValue;
              else if (infoKey == "avatarBody")
                request.bodyMap = int.parse(infoValue);
            });
          }
        });
        value["accepted"].forEach((key2, value2) {
          if (key2.toString().startsWith("uid"))
            request.helperName = value2.toString();
        });

        request.show();
        if (request.isValid()) requests.add(request);
      }
    });
  }

  getRequests() {
    // will be http request
    String token = user.token;
    Future.delayed(Duration.zero, () async {
      http.Response response = await http.post(
        Uri.parse('$url/user/get_requests'),
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
          elevation: 5,
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
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
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
                              child: ExpansionPanelList(
                                elevation: 0,
                                dividerColor: Color.fromRGBO(249, 249, 249, 1),
                                expansionCallback: (int i, bool isExpanded) {
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
                                                      false, Colors.black54),
                                                  getText(req.date, 11, true,
                                                      Colors.black54),
                                                ]),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  getText("Helper Name", 11,
                                                      false, Colors.black54),
                                                  getText(req.getName(10), 11,
                                                      true, Colors.black54),
                                                ]),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  getText("Address", 11, false,
                                                      Colors.black54),
                                                  getText(req.address, 11, true,
                                                      Colors.black54),
                                                ]),
                                          ],
                                        ),
                                      );
                                    },
                                    body: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          print("VISA!");
                                        },
                                        child: Container(
                                          color:
                                              Color.fromRGBO(249, 249, 249, 1),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  height: 200,
                                                  width: 200,
                                                  child:
                                                      BodyMap.init(req.bodyMap),
                                                ),
                                              ),
                                              SizedBox(height: height*2,),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      // ignore: deprecated_member_use
                                                      child: RaisedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          "Complain",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        color:
                                                            Colors.deepOrange,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                      // ignore: deprecated_member_use
                                                      child: RaisedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          "Rate",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        color:
                                                            Colors.deepOrange,
                                                      ),
                                                    )
                                                  ])
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    isExpanded: req.isExpanded,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
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
