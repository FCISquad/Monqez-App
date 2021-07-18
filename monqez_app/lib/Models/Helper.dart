import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart' as loc;
import 'package:background_location/background_location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User.dart';

class Helper extends User with ChangeNotifier  {
  static Timer timer ;
  static bool isTimerRunning = false ;
  final _samplingPeriod = 60;
  final loc.Location _location = loc.Location();
  String status;
  double longitude;
  double latitude;
  int callCount;
  double ratings;
  int myPoints = 0;
  String requestID;
  String requestPhone;
  double requestLongitude;
  double requestLatitude;

  loc.LocationData helperTracker ;

  Helper.empty ():super.empty();

  @override
  Future<bool> saveUser() async {
    bool ret = await super.saveUser();
    notifyListeners();
    return ret;
  }

  Future<void> setToken(String token) async {
    super.setToken(token);
    await getState();
    await getActiveRequest();
    print (this.status) ;
    print (status) ;
    if (status == "Available") {
        requestGps();
        startBackgroundProcess();
    }
  }

  Future<void> getState() async {
    await super.getUser();
    http.Response response2 = await http.get(
      Uri.parse('$url/helper/getstate/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response2.statusCode == 200) {
      var parsed = jsonDecode(response2.body).cast<String, dynamic>();
      // changeStatus( parsed['status']);
      this.status = parsed['status'];
      this.callCount = (parsed['calls'] == 0 || parsed['calls'] == null) ? 0 : parsed['calls'];
      this.ratings = (parsed['sum'] == 0 || parsed['sum'] == null) ? 0 : (parsed['sum'] / parsed['total']);
      this.myPoints = (parsed['points'] == 0 || parsed['points'] == null) ? 0 : parsed['points'];
    }
    notifyListeners();
  }

  startBackgroundProcess() async {
    await BackgroundLocation.setAndroidNotification(
      title: "Monqez is running",
      message: "Available",
      icon: "@mipmap/ic_launcher",
    );
    await BackgroundLocation.setAndroidConfiguration(1000);
    await BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((location) {
      latitude = location.latitude;
      longitude = location.longitude;
    });
    if (!isTimerRunning ){
      timer?.cancel();
      timer = Timer.periodic(
          Duration(seconds: _samplingPeriod), (Timer t) => sendPosition());
      isTimerRunning = true ;

    }
  }

  stopBackgroundProcess() {
    if (timer != null){
      timer.cancel();
      timer = null;
      isTimerRunning = false ;
    }
    BackgroundLocation.stopLocationService();
  }

  Future<void> changeStatus(newValue) async {
    status = newValue;
    if (newValue == "Available") {
      requestGps();
      startBackgroundProcess();
    } else {
      stopBackgroundProcess();
    }
    notifyListeners();
    final http.Response response = await http.post(
      Uri.parse('$url/helper/setstatus/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'status': newValue}),
    );
    if (response.statusCode == 200) {
      makeToast("Submitted");
    } else {
      makeToast('Failed to submit user.');
    }
  }

  Future requestGps() async {
    if (!await _location.serviceEnabled()) {
      stopBackgroundProcess();
      bool result = await _location.requestService();
      if (result == false) {
        changeStatus("Busy");
      }
    }
  }

  Future<void> sendPosition() async {
    if (!await _location.serviceEnabled()) {
      changeStatus("Busy");
    }
    if (longitude != null && latitude != null && status == "Available") {
      String tempToken = token;
      final http.Response response = await http.post(
        Uri.parse('$url/helper/update_location/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tempToken',
        },
        body: jsonEncode(<String, double>{
          'latitude':  latitude,
          'longitude': longitude
        }),
      );
      if (response.statusCode == 200) {
        print("Sampling");
      } else {
        makeToast('Failed to submit user.');
      }
    }
  }

  void saveRequest(String phone, String requestID, double reqLatitude, double reqLongitude) async {
    this.requestPhone = phone;
    this.requestID = requestID;
    this.requestLatitude = reqLatitude;
    this.requestLongitude = reqLongitude;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("requestPhone", phone);
    prefs.setString("requestID", requestID);
    prefs.setDouble("requestLatitude", reqLatitude);
    prefs.setDouble("requestLongitude", reqLongitude);
    notifyListeners();
  }

  getActiveRequest() async {
    var _prefs = await SharedPreferences.getInstance();
    requestPhone = _prefs.getString("requestPhone");
    requestID = _prefs.getString("requestID");
    requestLatitude = _prefs.getDouble("requestLatitude");
    requestLongitude = _prefs.getDouble("requestLongitude");
  }

  hasActiveRequest() {
    return requestID != null && requestID.isNotEmpty;
  }

  removeRequest() async {
    requestPhone = requestID = "";
    requestLongitude = requestLatitude = 0;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("requestPhone");
    prefs.remove("requestID");
    prefs.remove("requestLatitude");
    prefs.remove("requestLongitude");
    notifyListeners();
  }
  setHelperTracker (loc.LocationData newLocation){
    helperTracker = newLocation ;
    notifyListeners() ;
  }

}
