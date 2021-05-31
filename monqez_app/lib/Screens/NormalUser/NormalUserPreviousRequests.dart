import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/Model/User.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:http/http.dart' as http;
import 'package:rating_dialog/rating_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import '../rateDialog.dart';
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
  String helperUid;
  int bodyMap;
  BodyMap avatar;
  String address;
  String forMe;
  String info;
  bool isExpanded = false;
  String dateId ;

  _Request(String key) {
    this.date = key.split(" ")[0];
    this.dateId = key ;
  }

  setAvatar(int bodyMap) {
    this.bodyMap = bodyMap;
    avatar = BodyMap.init(bodyMap, 150);
  }

  getAvatar() {
    return (avatar == null) ? BodyMap.init(0, 150) : avatar;
  }

  getName(int size) {
    return helperUid.substring(0, size);
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
    return (date != null && helperUid != null);
  }

  show() {
    print("\n\n\n-------------------------------------------");
    print((date == null) ? "Null" : date.toString());
    print((helperUid == null) ? "Null" : helperUid);
    print((bodyMap == null) ? "Null" : bodyMap);
    print((address == null) ? "Null" : address);
    print((forMe == null) ? "Null" : forMe);
    print("\n\n\n-------------------------------------------");
  }
}

class _NormalPreviousRequestsState extends State<NormalPreviousRequests>
    with SingleTickerProviderStateMixin {
  var rate ;
  final _commentController = TextEditingController() ;
  final _subjectController = TextEditingController() ;
  final _messageController = TextEditingController() ;

  RatingDialogResponse rateResponse = RatingDialogResponse() ;
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
    print("Here: " + text);
    return AutoSizeText(text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontFamily: 'Cairo',
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        maxLines: 1);
  }

  Widget _getText(
      String text, double fontSize, Color color, FontWeight fontWeight) {
    return AutoSizeText(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: 'Cairo',
          fontWeight: fontWeight),
    );
  }

  Widget _showMaterialDialog(_Request req) {
    double width = MediaQuery.of(context).size.width / 100;
    double height =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) /
            100;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    height: height * 65,
                    width: width * 80,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 7.5 * height,
                            width: 60 * width,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(237, 237, 237, 1),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/users.png',
                                ),
                                SizedBox(
                                  width: 2.5 * width,
                                ),
                                _getText("Make a complaint", 18, Colors.black,
                                    FontWeight.w600),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: height * 2),
                        Container(
                          width: 60 * width,
                          height: 50 * height,
                          child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.bottomLeft,
                                          child: _getText("Subject", 16,
                                              Colors.black, FontWeight.w600)),
                                      TextField(
                                          //autofocus: true,
                                        controller: _subjectController,
                                          decoration: InputDecoration(
                                              hintText: "Subject",
                                              hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w300,
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.black)))),
                                      SizedBox(
                                        height: height * 2,
                                      ),
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: _getText("Message Details", 16,
                                              Colors.black, FontWeight.w600)),
                                      SizedBox(height: 2 * height),
                                      Container(
                                          height: height * 17,
                                          width: width * 80,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: Color.fromRGBO(
                                                  237, 237, 237, 1),
                                              shape: BoxShape.rectangle,
                                              border: new Border.all(
                                                  color: Colors.black,
                                                  width: 0.5)),
                                          child: TextField(
                                            controller: _messageController,
                                              decoration:
                                                  new InputDecoration.collapsed(
                                                      hintText:
                                                          ''))), //.horizontal
                                      SizedBox(
                                        height: height * 5,
                                      ),
                                      Container(
                                          height: 5 * height,
                                          width: 40 * width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              color: Colors.deepOrange),
                                          // ignore: deprecated_member_use
                                          child: FlatButton(
                                            color: Colors.transparent,
                                            splashColor: Colors.black26,
                                            onPressed: () {
                                              _complainRequest(_messageController.text,_subjectController.text,req) ;
                                            },
                                            child: _getText('Submit', 16,
                                                Colors.white, FontWeight.w600),
                                          ))
                                    ],
                                  ))),
                        )
                      ],
                    ),
                  )),
            );
          });
        });
  }
  Widget buildScreen2(_Request req){
    double width = MediaQuery.of(context).size.width / 100;
    double height =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) /
            100;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child:SingleChildScrollView(
                  scrollDirection: Axis.vertical ,
                  child :Container(
                    height: height*40,
                    width: width*80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height:5*height ,),
                        Container(
                          height: 5*height,
                          width: 50*width,
                          child:Center(child: _getText("Rate your Monqez", 20, Colors.black, FontWeight.w700)),
                        ),
                        SizedBox(height: 2*height,),
                        Center(
                            child:RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                rate = rating ;
                              },
                            )
                        ),
                        TextField(
                          controller: _commentController,
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.newline,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: "Tell us your comment",
                          ),

                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            onPressed: () {
                              rateResponse.rating = rate.toInt() ;
                              _rateRequest(rateResponse,req) ;

                            },
                          ),
                        ),

                      ],
                    ),

                  )),
            );
          });
        });

  }

  // void buildRatingScreen() {
  //   showDialog(
  //       context: context,
  //       builder: (context) => Dialog(
  //         backgroundColor: Colors.transparent,
  //               insetPadding: EdgeInsets.all(0), //this right here
  //               child: Container(
  //                 width: 450,
  //                 height: 500,
  //                 child: RatingDialog(
  //                   ratingColor: Colors.amber,
  //                   title: 'Rate your monqez',
  //                   message: 'Rating your monqez and tell us what you think.'
  //                       ' Add more description here if you want.',
  //                   submitButton: 'Submit',
  //                   onCancelled: () => print('cancelled'),
  //                   onSubmitted: (response) {
  //                     _rateRequest(response,req);
  //                   },
  //                   image: null,
  //                 ),
  //               ))
  //   );
  // }

  Future<void> _rateRequest(RatingDialogResponse dialogResponse,_Request req) async {
    String token = user.token;

    final http.Response response = await http.post(
      Uri.parse('$url/user/rate'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'rate': rateResponse.rating,
        'time' :req.dateId,
        'uid' : req.helperUid
      }),
    );
    if (response.statusCode == 200) {
      makeToast("Submitted");
    } else {
      makeToast('Failed to submit rating.');
    }
  }
  Future<void> _complainRequest(String subject,String message ,_Request req) async {
    print (req.dateId) ;
    print ("here") ;
    String token = user.token;
    final http.Response response = await http.post(
      Uri.parse('$url/user/complaint'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'subject': subject,
        'complaint': message,
        'time' :req.dateId,
        'uid' : req.helperUid

      }),
    );
    if (response.statusCode == 200) {
      makeToast("Submitted");
    } else {
      makeToast('Failed to submit rating.');
    }
  }

  void _iterateJson(String jsonStr) {
    Map<String, dynamic> requestsJson = json.decode(jsonStr);
    requestsJson.forEach((key, value) {
      print ("yarb n5ls");
      print (value["accepted"].toString());
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
                request.setAvatar(int.parse(infoValue));
              else if (infoKey == "Additional Notes") request.info = infoValue;
            });
          }
        });
        value["accepted"].forEach((key2, value2) {
          if (key2.toString().startsWith("uid"))
            request.helperUid = value2.toString();
        });

        //request.show();
        if (request.isValid()) requests.add(request);
      }
    });
  }

  getRequests() {
    // will be http request
    String token = user.token;
    Future.delayed(Duration.zero, () async {
      http.Response response = await http.get(
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
                              /*boxShadow: [
                                BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 3,
                                offset: Offset(0, 3), // changes position of shadow
                              )],*/
                            ),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 2,
                              child: ExpansionPanelList(
                                animationDuration: Duration(seconds: 1),
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
                                                  getText("Helper Name", 11,
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
                                            visible: req.forMe != null,
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
                                                          req.getForMe() ==
                                                                  'true'
                                                              ? 'For You'
                                                              : 'For another one',
                                                          11,
                                                          true,
                                                          Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: 110,
                                                // ignore: deprecated_member_use
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    _showMaterialDialog(req);
                                                  },
                                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                                  color: firstColor,
                                                  child: Text(
                                                    'Complain',
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      letterSpacing: 1,
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 110,
                                                // ignore: deprecated_member_use
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    buildScreen2(req);
                                                  },
                                                  color: firstColor,
                                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                                  child: Text(
                                                    'Rate',
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      letterSpacing: 1,
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
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
