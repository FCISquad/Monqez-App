// import 'dart:async';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:circular_profile_avatar/circular_profile_avatar.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:monqez_app/Backend/FirebaseCloudMessaging.dart';
// import 'package:monqez_app/Backend/NotificationRoutes/NormalUserNotification.dart';
// import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';
// import 'package:flutter/material.dart';
// import 'package:monqez_app/Screens/Model/User.dart';
// import 'package:monqez_app/Screens/NormalUser/BodyMap.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../Backend/Authentication.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
// import 'package:monqez_app/Screens/Utils/Profile.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../Instructions/InstructionsScreen.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../CallPage.dart';
// import '../LoginScreen.dart';
// import '../VoicePage.dart';
// import 'Chatbot.dart';
// import 'NormalUserPreviousRequests.dart';
// import 'package:provider/provider.dart';
// import 'package:monqez_app/Screens/Model/Normal.dart';
//
// class TestMap extends StatefulWidget {
//
//
//   @override
//   _TestMapState createState() =>
//       _TestMapState();
// }
// class _TestMapState extends State<TestMap> {
//   GoogleMapController mapController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//           children: <Widget>[
//       Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: GoogleMap(
//         initialCameraPosition: CameraPosition(
//             target: LatLng(30.01116, 31.0005), zoom: 20.0),
//         onMapCreated: (GoogleMapController controller) {
//           mapController = controller;
//           },
//       ),
//       )
//           ],
//     ),
//     floatingActionButton: FloatingActionButton(onPressed: () {
//     mapController.animateCamera(
//     CameraUpdate.newCameraPosition(
//     CameraPosition(
//     target: LatLng(37.4219999, -122.0862462), zoom: 20.0),
//     ),
//     );
//     }),
//
//     );
//
//   }
//
// }
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();


      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              // bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              // tilt: 0,
              zoom: 15.0)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        markers: Set.of((marker != null) ? [marker] : []),
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },

      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            getAddressFromLatLng(context,37.42796133580664, -122.085749655962) ;
            getCurrentLocation();
          }),
    );
  }
  getAddressFromLatLng(context, double lat, double lng) async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=AIzaSyBd1Dn-iC1y3-OeYcbdHv-gWUP883X5AMg&language=en&latlng=$lat,$lng';
    if(lat != null && lng != null){
      var response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data["results"][0]["formatted_address"];
        print("response ==== $_formattedAddress");
        return _formattedAddress;
      } else return null;
    } else return null;
  }
  Widget _getText(String text, double fontSize, FontWeight fontWeight,
      Color color, int lines) {
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
