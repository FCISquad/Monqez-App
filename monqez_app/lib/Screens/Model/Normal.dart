import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User.dart';

class Normal extends User with ChangeNotifier  {
  List<bool> visible = [true,false,false];
  String helperPhone = "";
  String helperName = "";


  Normal.empty() : super.empty();

  void setAccepted(String phone, String name) {
    this.helperPhone = phone;
    this.helperName = name;
    visible = [false,false,true];
    notifyListeners();
  }
  Future<void> setFinished() async {
    visible = [true, false, false];
    helperName = helperPhone = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("helperName");
    prefs.remove("helperPhone");
    notifyListeners();
  }
  void saveRequest(String phone,String helperName) async {
    this.helperName = helperName;
    this.helperPhone = phone;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("helperPhone", phone);
    prefs.setString("helperName", helperName);

    notifyListeners();
  }

  getActiveRequest() async {
    var _prefs = await SharedPreferences.getInstance();
    helperName = _prefs.getString("helperName");
    helperPhone = _prefs.getString("helperPhone");

  }
  hasActiveRequest() {
    return helperName != null && helperName.isNotEmpty;
  }

}