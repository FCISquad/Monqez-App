import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User.dart';

class Normal extends User with ChangeNotifier  {
  List<bool> visible = [true,false,false];
  String helperPhone = "";
  String helperName = "";


  Normal.empty() : super.empty();

  Future<void> setAccepted(String phone, String name) async {
    this.helperPhone = phone;
    this.helperName = name;
    visible = [false,false,true];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("helperPhone", phone);
    prefs.setString("helperName", helperName);
    notifyListeners();
  }
  Future<void> setFinished() async {
    visible = [true, false, false];
    helperName = helperPhone = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("helperName") != null){
      print("Here");
      prefs.remove("helperName");
      prefs.remove("helperPhone");
      notifyListeners();
    }
  }


}