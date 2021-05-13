import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:monqez_app/Screens/Model/Instructions/Injury.dart';
import '../../../main.dart';
import 'Pair.dart';

class InstructionsList with ChangeNotifier {
  List<Injury> _injuries;
  int selected ;
  InstructionsList() {
    _injuries = [];
    selected = -1;
    loadInjuries();
  }

  loadInjuries() async { // will be http request
      _injuries.add(new Injury(File('images/ToBeRemoved/leg.png'), "Broken Leg"));
      _injuries.add(new Injury(File('images/ToBeRemoved/burn.png'), "Burn Injuries"));
      _injuries.add(new Injury(File('images/ToBeRemoved/leg.png'), "Broken Leg"));
      _injuries.add(new Injury(File('images/ToBeRemoved/burn.png'), "Burn Injuries"));
      notifyListeners();
  }
  getInjuries() {
    return _injuries;
  }

  void select(int index) {
    this.selected = index;
    _injuries[index].load();
    navigatorKey.currentState.pushNamed('injury');
  }
  Injury getSelected() {
    return _injuries[selected];
  }
}