import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Backend/Authentication.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:search_map_place/search_map_place.dart';


import '../LoginScreen.dart';

class NormalHomeScreen extends StatefulWidget {
  @override
  _NormalHomeScreenState createState() => _NormalHomeScreenState();
}
class Item {
  const Item(this.name);
  final String name;

}
class _NormalHomeScreenState extends State<NormalHomeScreen> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  /*
  void logout () async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.remove('email');
    _prefs.remove('userID');
    _prefs.remove('userToken');
    makeToast('Logged out!');
  }
   */
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  Position _newUserPosition;
  Item _selectedSeviirty;
  String _radioValue  ;
  var _nameController = TextEditingController();

  List<Item> users = <Item>[
    const Item('Very dangerous'),
    const Item('Dangerous'),
    const Item('Normal'),
  ];

    static CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(45.531563, -122.677433),
    tilt: 59.440,
    zoom: 11.0,
  );

  Future<void> _goToPosition1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }
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
    print(_position1.target) ;
  }
  _onCameraMove(CameraPosition position) {
    _lastMapPosition = _position1.target;
  }
  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState){
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20.0)), //this right here
                  child: Container(
                    height: 400,
                    child:
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Text("Additional details",
                            style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),
                          )) ,
                          SizedBox(height: 20),
                          // Container(
                          //   child :Row(
                          //     children: [
                          //       Text("Severity  ") ,
                          //       DropdownButton<Item>(
                          //         hint: Text("Select item"),
                          //         value: _selectedSeviirty,
                          //         onChanged: (Item value) {
                          //           setState(() {
                          //             _selectedSeviirty = value;
                          //             print(_selectedSeviirty.name) ;
                          //           });
                          //         },
                          //         items: users.map((Item user) {
                          //           return  DropdownMenuItem<Item>(
                          //             value: user,
                          //             child: Row(
                          //               children: <Widget>[
                          //                 SizedBox(width: 10,),
                          //                 Text(
                          //                   user.name,
                          //                   style:  TextStyle(color: Colors.black),
                          //                 ),
                          //               ],
                          //             ),
                          //           );
                          //         }).toList(),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          Container(
                            child: Row(
                              children: [
                                Text("For Me"),
                                Radio(
                                  value: 'For Me',
                                  groupValue: _radioValue,
                                  onChanged: (value)  {
                                    setState(() {
                                      _radioValue = value;
                                      print(_radioValue);
                                    });
                                  },
                                ),
                                Text("For Other"),
                                Radio(
                                  value: 'For Other',
                                  groupValue: _radioValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _radioValue = value;
                                      print(_radioValue);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Your detailed address ?'),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Notes for your coming monqez ?'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 200,
                                child: RaisedButton(
                                  onPressed: () {
                                    print(_selectedSeviirty) ;
                                    print(_radioValue) ;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                    ),
                  ),
                );
              }
          );


        });
  }
  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
  _getCurrentUserLocation() async {
    Position _newPosition;
    _newPosition = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _newUserPosition = _newPosition;
      _position1 = CameraPosition(
          bearing: 192.833,
          target: LatLng( _newUserPosition.latitude, _newUserPosition.longitude),
          tilt: 59.440,
          zoom: 11.0);
    });

  }
  _onAddMarkerButtonPressed() async {
    await _getCurrentUserLocation();
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_newUserPosition.toString()),
          position: LatLng(
              _newUserPosition.latitude, _newUserPosition.longitude),
          infoWindow: InfoWindow(
            title: 'This is a Title',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  Widget button(Function function, IconData icon, String hero) {
    return FloatingActionButton(
      heroTag: hero,
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.deepOrangeAccent,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }
  Widget _buildBtn(String text){

    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: ()
        {
          logout();
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, animationTime, child) {
                    return SlideTransition(
                      position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.ease,
                      )),
                      child: child,
                    );
                  },
                  pageBuilder: (context, animation, animationTime) {
                    return LoginScreen();
                  }));
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(text, style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 16,
            fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    animation = new Tween(begin: 0.0, end: 200.0).animate(controller);
    animation.addListener(() {
      setState(() {
        //The state of the animation has changed
      });
    });

    controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _position1,
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: SearchMapPlaceWidget(
                hasClearButton: true,
                placeType: PlaceType.address,
                placeholder: "Enter the location",
                apiKey: 'AIzaSyD3bOWy1Uu61RerNF9Mam9Ieh-0z4PDYPo',
                onSelected: (Place place) async {
                  Geolocation geoLocation = await place.geolocation;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      _showMaterialDialog();
                    },
                    child: Text('Get Help!'),
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    button(_onMapTypeButtonPressed, Icons.map, 'map'),
                    SizedBox(
                      height: 16.0,
                    ),
                    button(_onAddMarkerButtonPressed, Icons.add_location, 'marker'),
                    SizedBox(
                      height: 16.0,
                    ),
                    button(_goToPosition1, Icons.location_searching, 'position'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}