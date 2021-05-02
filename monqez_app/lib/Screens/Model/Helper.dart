import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:background_location/background_location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monqez_app/Backend/Authentication.dart';

import 'User.dart';
import 'location_callback_handler.dart';

class Helper extends User with ChangeNotifier  {
  String status;
  Timer timer;
  final _samplingPeriod = 5;
  double longitude;
  double latitude;
  final loc.Location _location = loc.Location();
  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();

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
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen((dynamic data) {
      print("Khaled: " + data);
    });
    initPlatformState();
    BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                LocationCallbackHandler.notificationCallback)));
  }
  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

  _startBackgroundProcess() async {
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
    BackgroundLocator.unRegisterLocationUpdate();
    // timer.cancel();
    // BackgroundLocation.stopLocationService();
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
