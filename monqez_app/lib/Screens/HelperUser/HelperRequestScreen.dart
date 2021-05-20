import 'dart:async';
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
  HelperRequestScreen(double longitude, double latitude , double helperLong , double helperLat ){
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

  _HelperRequestScreenState(double reqLong, double reqLat,double helperLong,double helperLat){
    this.reqLat = reqLat;
    this.reqLong = reqLong;
    this.helperLat = helperLat ;
    this.helperLong = helperLong ;


    calcualteDistance() ;

  }
  final LatLng initialLatLng = LatLng(30.029585, 31.022356);
  final LatLng destinationLatLng = LatLng(30.060567, 30.962413);
  
  Position _currentPosition;
  String _currentAddress;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  final Set<Marker> _markers = {};

  Completer<GoogleMapController> _controller = Completer();
  static CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(30.029585, 31.022356),
    tilt: 59.440,
    zoom: 11.0,
  );

  @override
  void initState() {

    polylinePoints = PolylinePoints();

    super.initState();
  }

  void showPinsOnMap() {
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
  void calcualteDistance (){
    _placeDistance = GeolocatorPlatform.instance.distanceBetween(helperLat, helperLong, reqLat, reqLong).toStringAsFixed(2);
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

  Widget _textField({
    TextEditingController controller,
    String label,
    String hint,
    String initialValue,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        // initialValue: initialValue,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
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
            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          // onTap: () {
                          //   _controller.animateCamera(
                          //     CameraUpdate.zoomIn(),
                          //   );
                          // },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          // onTap: () {
                          //   mapController.animateCamera(
                          //     CameraUpdate.zoomOut(),
                          //   );
                          // },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Places',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Start',
                              hint: 'Choose starting point',
                              initialValue: _currentAddress,
                              prefixIcon: Icon(Icons.looks_one),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.my_location),
                                onPressed: () {
                                  startAddressController.text = _currentAddress;
                                  _startAddress = _currentAddress;
                                },
                              ),
                              controller: startAddressController,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _startAddress = value;
                                });
                              }),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Destination',
                              hint: 'Choose destination',
                              initialValue: '',
                              prefixIcon: Icon(Icons.looks_two),
                              controller: destinationAddressController,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _destinationAddress = value;
                                });
                              }),
                          SizedBox(height: 10),
                          Visibility(
                            visible: _placeDistance == null ? false : true,
                            child: Text(
                              'DISTANCE: $_placeDistance m',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          // RaisedButton(
                          //   onPressed: (_startAddress != '' &&
                          //       _destinationAddress != '')
                          //       ? () async {
                          //     setState(() {
                          //       if (_markers.isNotEmpty) _markers.clear();
                          //       if (polylines.isNotEmpty)
                          //         polylines.clear();
                          //       if (polylineCoordinates.isNotEmpty)
                          //         polylineCoordinates.clear();
                          //       _placeDistance = null;
                          //     });
                          //
                          //     _calculateDistance().then((isCalculated) {
                          //       if (isCalculated) {
                          //         _scaffoldKey.currentState.showSnackBar(
                          //           SnackBar(
                          //             content: Text(
                          //                 'Distance Calculated Sucessfully'),
                          //           ),
                          //         );
                          //       } else {
                          //         _scaffoldKey.currentState.showSnackBar(
                          //           SnackBar(
                          //             content: Text(
                          //                 'Error Calculating Distance'),
                          //           ),
                          //         );
                          //       }
                          //     });
                          //   }
                          //       : null,
                          //   color: Colors.red,
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(20.0),
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Text(
                          //       'Show Route'.toUpperCase(),
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 20.0,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange[100], // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        // onTap: () {
                        //   mapController.animateCamera(
                        //     CameraUpdate.newCameraPosition(
                        //       CameraPosition(
                        //         target: LatLng(
                        //           _currentPosition.latitude,
                        //           _currentPosition.longitude,
                        //         ),
                        //         zoom: 18.0,
                        //       ),
                        //     ),
                        //   );
                        // },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
