import 'dart:async';
import 'dart:convert';
import 'package:android_intent/android_intent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/HelperUser/HelperHomeScreen.dart';
import 'package:monqez_app/Models/Helper.dart';
import 'package:monqez_app/Screens/NormalUser/BodyMap.dart';

import 'package:http/http.dart' as http;
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:location/location.dart' ;


// ignore: must_be_immutable
class HelperRequestScreen extends StatefulWidget {
  String requestID ;
  double reqLong;
  double reqLat;
  double helperLong;
  double helperLat;
  String phone ;

  HelperRequestScreen(String phone ,String requestID,double latitude, double longitude, double helperLat, double helperLong) {
    this.reqLong = longitude;
    this.reqLat = latitude;
    this.helperLong = helperLong;
    this.helperLat = helperLat;
    this.requestID =requestID ;
    this.phone = phone ;

  }

  @override
  _HelperRequestScreenState createState() =>
      _HelperRequestScreenState(phone,requestID,reqLong, reqLat, helperLong, helperLat);
}

class _HelperRequestScreenState extends State<HelperRequestScreen>
    with SingleTickerProviderStateMixin {
  double reqLong, reqLat, helperLong, helperLat;
  String phone ;
  String requestID ;
  LatLng initialLatLng;
  LatLng destinationLatLng;
  TextEditingController _detailedAddressController;
  TextEditingController _additionalNotesController;
  TextEditingController _forMeController;

  Location _locationTracker = Location();
  StreamSubscription _locationSubscription;



  geo.Position helperLocation;
  var _prefs;

  int bodyMapValue;
  bool forMe;
  Widget avatar;

  _HelperRequestScreenState(String phone ,String requestID , double reqLong, double reqLat, double helperLong, double helperLat) {
    this.reqLat = reqLat;
    this.reqLong = reqLong;
    this.helperLat = helperLat;
    this.helperLong = helperLong;
    this.requestID = requestID ;
    this.phone = phone;
  }


  initializeSourceAndDestination() {
    setState(() {
      initialLatLng = LatLng(helperLat, helperLong);
      destinationLatLng = LatLng(reqLat, reqLong);
    });
  }

  double cameraZoom = 16;
  double cameraTitl = 40;
  double cameraBearing = 110;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  final Set<Marker> _markers = {};

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    _detailedAddressController = TextEditingController(text: "Detailed Address");
    _additionalNotesController = TextEditingController(text: 'Additional Notes');
    _forMeController = TextEditingController(text: ' ');
    polylinePoints = PolylinePoints();

    initializeSourceAndDestination();
    super.initState();
  }

  void showPinsOnMap() {
    _markers.add(
      Marker(
        markerId: MarkerId(initialLatLng.toString()),
        position: LatLng(initialLatLng.latitude, initialLatLng.longitude),
        infoWindow: InfoWindow(

        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId(destinationLatLng.toString()),
        position:
            LatLng(destinationLatLng.latitude, destinationLatLng.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  // ignore: missing_return
  Future<bool> getAdditionalInformation() async {
    if (_additionalNotesController.text == "Additional Notes" &&
        _detailedAddressController.text == "Detailed Address" && _forMeController.text== ' ') {
      String token = Provider
          .of<Helper>(context, listen: false)
          .token;
      final http.Response response = await http.post(
          Uri.parse('$url/helper/get_additional_information/'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(
              <String, String>{'uid': requestID}));
      if (response.statusCode == 200) {
        if (response.body.length == 0) {
          return false;
        }
        Map mp = jsonDecode(response.body);

        _additionalNotesController.text = mp["Additional Notes"];
        _detailedAddressController.text = mp["Address"];
        if(mp["forMe"] == true)
          _forMeController.text = "Yes";
        else
          _forMeController.text = "No";

        bodyMapValue = int.parse(mp["avatarBody"]);
        avatar = BodyMap.init(bodyMapValue, 200);
        return true;
      } else {
        return false;
      }
    }
  }

  Widget _getText(String text, double fontSize, FontWeight fontWeight,
      Color color, int lines,bool launch) {
    if (launch){
    return AutoSizeText(text,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: TextStyle(
          decoration: TextDecoration.underline,
            color: color,
            fontSize: fontSize,
            fontFamily: 'Cairo',
            fontWeight: fontWeight),
        maxLines: lines);
    }
    else{
      return AutoSizeText(text,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontFamily: 'Cairo',
              fontWeight: fontWeight),
          maxLines: lines);

    }
  }

  void setPolylines() async {

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBd1Dn-iC1y3-OeYcbdHv-gWUP883X5AMg",
      PointLatLng(initialLatLng.latitude, initialLatLng.longitude),
      PointLatLng(destinationLatLng.latitude, destinationLatLng.longitude),
    );
    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            width: 3,
            polylineId: PolylineId('polyLine'),
            color: Color(0xFF08A5CB),
            points: polylineCoordinates));
      });
    }
  }

  Widget getTextField(TextEditingController controller) {
    return Container(
        height: 50,
        child: TextField(
          controller: controller,
          style: TextStyle(
            color: Colors.deepOrange,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
          ),
        ));
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (builder) {
          return new Container(
            height: 300,
            color: Colors.transparent,
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: ListView(shrinkWrap: true, children: [
                  SizedBox(height: 200, child: avatar),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceEvenly,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 6,),
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
                                    child: _getText(
                                        'Detailed Address ',
                                        13,
                                        FontWeight.bold,
                                        Colors.black,1,false),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  height: 25,
                                  width: 125,
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius:
                                    BorderRadius.circular(
                                        5.0),

                                  ),
                                  child: Center(
                                    child: _getText(_detailedAddressController.text, 15,
                                        FontWeight.normal, Colors.black, 1,false),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceEvenly,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 6,),
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
                                    child: _getText(
                                       'Additional Notes' ,
                                        13,
                                        FontWeight.bold,
                                        Colors.black,1,false),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  height: 30,
                                  width: 125,
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius:
                                    BorderRadius.circular(
                                        5.0),
                                  ),
                                  child: Center(
                                    child: _getText(_additionalNotesController.text, 15,
                                        FontWeight.normal, Colors.black, 1,false),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceEvenly,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 6,),
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
                                    child: _getText(
                                        'For Me ',
                                        13,
                                        FontWeight.bold,
                                        Colors.black,1,false),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  height: 30,
                                  width: 125,
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius:
                                    BorderRadius.circular(
                                        5.0),
                                  ),
                                  child: Center(
                                    child: _getText(_forMeController.text, 15,
                                        FontWeight.normal, Colors.black, 1,false),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceEvenly,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 6,),
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
                                    child: _getText(
                                        'Phone Number',
                                        13,
                                        FontWeight.bold,
                                        Colors.black,1,false),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                     height: 30,
                                     width: 125,
                                     decoration: BoxDecoration(
                                       color: Colors.white24,
                                       borderRadius:
                                       BorderRadius.circular(
                                           5.0),
                                     ),
                                     child:  Center(
                                       child: GestureDetector(
                                         onTap:(){ _launchCaller(phone);},
                                         child: _getText(phone, 15,
                                             FontWeight.normal, Colors.blue, 1,true),
                                       ),
                                     ),
                                   ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6,)
                        ],
                      )

                ])),
          );
        });
  }
  _launch() {
    AndroidIntent intent = new AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull(
            'https://www.google.com/maps/dir/?api=1&origin=${initialLatLng.latitude},${initialLatLng.longitude} &destination=${destinationLatLng.latitude},${destinationLatLng.longitude}'
            '&travelmode=driving&dir_action=navigate'),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  _getCurrentUserLocation() async {
    helperLocation = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);
  }

  Future<void> _completeRequest() async {
    await _getCurrentUserLocation();
    _prefs = await SharedPreferences.getInstance();
    String tempToken = _prefs.getString("userToken");

    final http.Response response = await http.post(
      Uri.parse('$url/helper/complete_request/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $tempToken',
      },
      body: jsonEncode(<String, dynamic>{
        'latitude': helperLocation.latitude,
        'longitude': helperLocation.longitude,
        'uid': requestID
      }),
    );
    if (response.statusCode == 200) {
      makeToast("Submitted");
      Provider.of<Helper>(context, listen: false).changeStatus("Available");
      navigate(HelperHomeScreen(Provider.of<Helper>(context, listen: false).token), context, true) ;


    }else if (response.statusCode == 503){
      makeToast("You are not near the location!") ;
    }
    else {
      makeToast('Failed to submit user.');
    }
  }

  Future<void> _cancelRequest() async {
    _prefs = await SharedPreferences.getInstance();
    String tempToken = _prefs.getString("userToken");

    final http.Response response = await http.post(
      Uri.parse('$url/helper/cancel_request/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $tempToken',
      },
        body: jsonEncode(
            <String, String>{'uid': requestID}));
    if (response.statusCode == 200) {
      makeToast("Submitted");
      Provider.of<Helper>(context, listen: false).changeStatus("Available");
      navigate(HelperHomeScreen(Provider.of<Helper>(context, listen: false).token), context, true) ;

    } else {
      makeToast('Failed to submit user.');
    }
  }

  @override
  Widget build(BuildContext context) {

    CameraPosition initialCameraPosition = CameraPosition(
      zoom: cameraZoom,
      tilt: cameraTitl,
      bearing: cameraBearing,
      target: initialLatLng,
    );
    double width = MediaQuery.of(context).size.width / 100;
    double height =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) /
            100;
    return Container(
        height: height*100,
        width: width*100,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              // Map View
              GoogleMap(
                markers: _markers,
                initialCameraPosition: initialCameraPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                polylines: _polylines,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  showPinsOnMap();
                  setPolylines();
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width*100,
                  height: height*15,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 19*width,
                        height: 8*height,
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(30.0)),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          color: Colors.transparent,
                          splashColor: Colors.black26,
                          onPressed: () {
                            _launch();
                          },
                          child: _getText(
                              'Navigate', 14, FontWeight.w700, Colors.white, 1,false),
                        ),
                      ),
                      Container(
                        width: 19*width,
                        height: 8*height,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30.0)),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          color: Colors.transparent,
                          splashColor: Colors.black26,
                          onPressed: () async {
                            Provider.of<Helper>(context, listen: false).removeRequest();
                            _completeRequest();
                          },
                          child: _getText(
                              'Complete', 14, FontWeight.w700, Colors.white, 1,false),
                        ),
                      ),
                      Container(
                        width: 19*width,
                        height: 8*height,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30.0)),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          color: Colors.transparent,
                          splashColor: Colors.black26,
                          onPressed: () {
                            Provider.of<Helper>(context, listen: false).removeRequest();
                            _cancelRequest();
                          },
                          child: _getText(
                              'Cancel', 14, FontWeight.w700, Colors.white, 1,false),
                        ),
                      ),
                      Container(
                        width: 19*width,
                        height: 8*height,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30.0)),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          color: Colors.transparent,
                          splashColor: Colors.black26,
                          onPressed: () {
                            _trackMonqez();
                          },
                          child: _getText(
                              'Track me', 14, FontWeight.w700, Colors.white, 1,false),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 14*width,
                          height: 8*height,
                          // ignore: deprecated_member_use
                          child: FlatButton(
                              color: Colors.transparent,
                              splashColor: Colors.black26,
                              onPressed: () async {

                                await getAdditionalInformation();
                                _modalBottomSheetMenu();
                              },
                              child:
                                  Icon(Icons.info, color: Colors.blueAccent)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
  _trackMonqez() async{
     await _locationTracker.getLocation();

    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }

    _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
      Provider.of<Helper>(context, listen: false).setHelperTracker(newLocalData);

    });
  }
  _launchCaller(String number) async {
    String url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
