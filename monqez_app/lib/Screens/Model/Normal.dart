import 'package:flutter/cupertino.dart';
import 'User.dart';

class Normal extends User with ChangeNotifier  {
  List<bool> visible = [true,false,false];
  String phone ;
  Normal.empty() : super.empty();

  void setAccepted(String phone) {
    this.phone = phone;
    visible = [false,false,true];
    notifyListeners();
  }
  void setFinished() {
    visible = [true, false, false];
    notifyListeners();
  }
}