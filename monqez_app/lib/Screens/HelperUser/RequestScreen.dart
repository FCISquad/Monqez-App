import 'dart:async';
import 'package:monqez_app/Screens/Model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Backend/Authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:monqez_app/Screens/Utils/Profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../LoginScreen.dart';



class RequestScreen extends StatefulWidget {

  @override
  _RequestScreenState createState() => _RequestScreenState();
}
class _RequestScreenState extends State<RequestScreen>  with SingleTickerProviderStateMixin{

  static User user;
  Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(45.531563, -122.677433),
    tilt: 59.440,
    zoom: 11.0,
  );
  MapType _currentMapType = MapType.normal;
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng _lastMapPosition = _center;
  _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    setState(() {
      _position1 = CameraPosition(
          bearing: 192.833,
          target: LatLng(37.0503, -95.7111),
          tilt: 59.440,
          zoom: 11.0);
    });
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
    print(_position1.target);
  }
  final Set<Marker> _markers = {};
  _onCameraMove(CameraPosition position) {
    _lastMapPosition = _position1.target;
  }
  PolylinePoints polylinePoints;

  List<LatLng> polylineCoordinates = [];


  Map<PolylineId, Polyline> polylines = {};
  _createPolylines(Position start, Position destination) async {

    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyD3bOWy1Uu61RerNF9Mam9Ieh-0z4PDYPo', // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title:
            getTitle("Monqez", 22.0, secondColor, TextAlign.start, true),
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
                          Icon(Icons.account_circle_rounded,
                              size: 90, color: secondColor),
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
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _position1,
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
              polylines: Set<Polyline>.of(polylines.values),

            ),/*
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SearchMapPlaceWidget(
                  hasClearButton: true,
                  placeType: PlaceType.address,
                  placeholder: "Enter the location",
                  apiKey: 'AIzaSyD3bOWy1Uu61RerNF9Mam9Ieh-0z4PDYPo',
                  onSelected: (Place place) async {
                    Geolocation geoLocation = await place.geolocation;
                  },
                ),
              ),*/
          ],
        ),
      ),
    );

  }

}