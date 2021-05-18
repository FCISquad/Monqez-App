import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:monqez_app/Screens/Instructions/ImageController.dart';
import 'package:monqez_app/Screens/Model/Instructions/Injury.dart';
import '../../../main.dart';
import 'Pair.dart';

class InstructionsList with ChangeNotifier {
  List<Injury> _injuries = [];
  int selected;
  bool edit = false;

  InstructionsList() {
    _injuries = [];
    selected = -1;
    loadInjuries();
  }

  addInjury(Injury injury) {
    if (edit) {
      _injuries.removeAt(selected);
      selected = -1;
      edit = false;
    }
    _injuries.add(injury);
    notifyListeners();
  }

  loadInjuries() {
    // will be http request
      _injuries.add(new Injury(
          ImageController.fromAssets('images/ToBeRemoved/leg.png'),
          "Broken Leg"));
      _injuries.add(new Injury(
          ImageController.fromAssets('images/ToBeRemoved/burn.png'),
          "Burn Injuries"));
      _injuries.add(new Injury(
          ImageController.fromAssets('images/ToBeRemoved/leg.png'),
          "Broken Leg"));
      _injuries.add(new Injury(
          ImageController.fromAssets('images/ToBeRemoved/burn.png'),
          "Burn Injuries"));
      notifyListeners();
  }

  getInjuries() {
    return _injuries;
  }

  void select(int index, bool edit) {
    this.edit = edit;
    this.selected = index;
    _injuries[index].load();
  }

  Injury getSelected() {
    if (!edit) {
      if (selected == -1) return null;
      int temp = selected;
      selected = -1;
      return _injuries[temp];
    }
    return _injuries[selected];
  }

  void unSelect() {
    selected = -1;
    edit = false;
    notifyListeners();
  }
}
