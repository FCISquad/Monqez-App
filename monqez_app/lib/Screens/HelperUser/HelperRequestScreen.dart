import 'dart:async';
import 'package:android_intent/android_intent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';


// ignore: must_be_immutable
class HelperRequestScreen extends StatefulWidget {

  double reqLong;
  double reqLat;
  double helperLong ;
  double helperLat ;
  HelperRequestScreen(double latitude, double longitude , double helperLat , double helperLong ){
    this.reqLong = longitude;
    this.reqLat = latitude;
    this.helperLong = helperLong ;
    this.helperLat = helperLat ;
  }

  @override
  _HelperRequestScreenState createState() => _HelperRequestScreenState(reqLong, reqLat,helperLong,helperLat);
}
class _HelperRequestScreenState extends State<HelperRequestScreen>  with SingleTickerProviderStateMixin{

  double reqLong, reqLat,helperLong,helperLat;
   LatLng initialLatLng ;
   LatLng destinationLatLng ;

  _HelperRequestScreenState(double reqLong, double reqLat,double helperLong,double helperLat){
    this.reqLat = reqLat;
    this.reqLong = reqLong;
    this.helperLat = helperLat ;
    this.helperLong = helperLong ;



    // calcualteDistance() ;

  }
   // LatLng initialLatLng = LatLng(30.029585, 31.022356);
   // LatLng destinationLatLng = LatLng(30.060567, 30.962413);

  initializeSourceAndDestination(){
    setState(() {
       initialLatLng = LatLng(helperLat, helperLong);
       destinationLatLng = LatLng(reqLat, reqLong);
    });

  }
  double CAMERA_ZOOM = 16;
  double CAMERA_TILT = 40;
  double CAMERA_BEARING = 110;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();


  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  final Set<Marker> _markers = {};

  Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(30.029585, 31.022356),
    tilt: 59.440,
    zoom: 12.0,
  );

  @override
  void initState() {

    polylinePoints = PolylinePoints();
    initializeSourceAndDestination();
    super.initState();
  }
  void showPinsOnMap() {
    print ("--------------");
    print(initialLatLng.latitude);
    _markers.add(
      Marker(
        markerId: MarkerId(initialLatLng.toString()),
        position:
        LatLng(initialLatLng.latitude, initialLatLng.longitude),
        infoWindow: InfoWindow(
          title: 'This is a Title',
          snippet: 'This is a snippet',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    print (_markers) ;
    _markers.add(
      Marker(
        markerId: MarkerId(destinationLatLng.toString()),
        position:
        LatLng(destinationLatLng.latitude, destinationLatLng.longitude),
        infoWindow: InfoWindow(
          title: 'This is a Title',
          snippet: 'This is a snippet',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

  }
  // void calcualteDistance (){
  //   _placeDistance = GeolocatorPlatform.instance.distanceBetween(helperLat, helperLong, reqLat, reqLong).toStringAsFixed(2);
  // }

  void setUrl(){
    String url ='https://www.google.com/maps/dir/?api=1&origin=${initialLatLng.latitude},${initialLatLng.longitude} &destination=${destinationLatLng.latitude},${destinationLatLng.longitude}'
        '&travelmode=driving&dir_action=navigate';

  }
  Widget _getText(String text, double fontSize, FontWeight fontWeight , Color color,int lines) {
    return AutoSizeText(text,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontFamily: 'Cairo',
            fontWeight: fontWeight
        ),
        maxLines:lines
    );
  }

  void setPolylines() async  {
    print ("--------------");
    print (initialLatLng) ;
    print (destinationLatLng) ;
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBd1Dn-iC1y3-OeYcbdHv-gWUP883X5AMg",
      PointLatLng(
          initialLatLng.latitude,
          initialLatLng.longitude
      ),
      PointLatLng(
          destinationLatLng.latitude,
          destinationLatLng.longitude
      ),
    );
    print (result.status) ;
    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(
            Polyline(
                width: 3,
                polylineId: PolylineId('polyLine'),
                color: Color(0xFF08A5CB),
                points: polylineCoordinates
            )
        );
      });
    }
  }
  void _modalBottomSheetMenu(){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (builder){
          return new Container(
            height: 200,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
              decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),

              child: new Center(
                  child: new Text("This is a modal sheet"),
                )),
          );
        }
    );

  }
  _launch (){
    AndroidIntent intent = new AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('https://www.google.com/maps/dir/?api=1&origin=${initialLatLng.latitude},${initialLatLng.longitude} &destination=${destinationLatLng.latitude},${destinationLatLng.longitude}'
            '&travelmode=driving&dir_action=navigate'),
        package: 'com.google.android.apps.maps');
    intent.launch() ;
  }


  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: initialLatLng,
    );
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: _markers ,
              initialCameraPosition:_position1 ,
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
                width: width,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround ,
                  children: [
                    Container(
                      width:150 ,
                        height:50 ,
                        decoration: BoxDecoration(
                            color: Colors.deepOrange
                        ),
                      child: FlatButton(
                        color: Colors.transparent,
                        splashColor: Colors.black26,
                        onPressed: () {
                          _modalBottomSheetMenu();
                        },
                        child: _getText('Additional Information', 14, FontWeight.w700, Colors.white,2),
                      ),

                    ),
                    Container(
                        width:150 ,
                        height:50 ,
                        decoration: BoxDecoration(
                            color: Colors.deepOrange
                        ),
                      child: FlatButton(
                        color: Colors.transparent,
                        splashColor: Colors.black26,
                        onPressed: () {
                          _launch() ;
                        },
                        child: _getText('Navigate', 14, FontWeight.w700, Colors.white,1),
                    ),

                    ),
                  ],
                ),
              ),
            )
                        ],
                      ),
                    )
    );
  }
}
