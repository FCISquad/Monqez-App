import 'package:flutter/cupertino.dart';
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
  void setFinished() {
    visible = [true, false, false];
    notifyListeners();
  }
}