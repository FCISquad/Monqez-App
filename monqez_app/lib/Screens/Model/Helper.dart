import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart' as loc;
import 'package:background_location/background_location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monqez_app/Backend/Authentication.dart';

import 'User.dart';

class Helper extends User with ChangeNotifier  {
  String status;
  Timer timer;
  final _samplingPeriod = 5;
  double longitude;
  double latitude;
  final loc.Location _location = loc.Location();

  Helper.empty ():super.empty();


  Future<void> setToken(String token) async {
    super.setToken(token);
    await getState();
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
      this.status = parsed['status'];
    } else {
      print(response2.statusCode);
    }
    print("Helper: " + name + ", " + status);
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
    timer = Timer.periodic(
        Duration(seconds: _samplingPeriod), (Timer t) => sendPosition());
  }

  stopBackgroundProcess() {
    timer.cancel();
    BackgroundLocation.stopLocationService();
  }

  Future<void> changeStatus(newValue) async {
    status = newValue;
    if (newValue == "Available") {
      requestGps();
      startBackgroundProcess();
    } else {
      if (timer != null) {
        stopBackgroundProcess();
      }
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
        makeToast("Submitted");
      } else {
        makeToast('Failed to submit user.');
      }
    }
  }
}
