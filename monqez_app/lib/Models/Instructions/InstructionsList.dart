import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/InstructionsScreens/ImageController.dart';
import 'package:monqez_app/Models/Instructions/Injury.dart';
import 'package:http/http.dart' as http;

class InstructionsList with ChangeNotifier {
  List<Injury> _injuries = [];
  int selected;
  bool edit = false;

  InstructionsList() {
    _injuries = [];
    selected = -1;
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


  void _iterateJson(String jsonStr) {
    Map<String, dynamic> applications = json.decode(jsonStr);

    applications["injuries"].forEach((key, value) {
      Injury i = Injury(new ImageController.fromBase64(value["Thumbnail"]), value["Title"]);
      value["instructions"].forEach((key2, value2) {
        i.addStep(new ImageController.fromBase64(value2["Thumbnail"]), value2["Step Text"]);
      });
      _injuries.add(i);
    });
  }
  loadInjuries(token) {
    // will be http request
    Future.delayed(Duration.zero, () async {
      http.Response response = await http.get(
        Uri.parse('$url/user/get_instructions/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        _iterateJson(response.body);
      } else {
        print(response.statusCode);
        makeToast("Error!");
      }
      // _injuries.add(new Injury(
      //     await getImage('images/ToBeRemoved/leg.png'), "Broken Leg"));
      // _injuries.add(new Injury(
      //     await getImage('images/ToBeRemoved/burn.png'), "Burn Injuries"));
      // _injuries.add(new Injury(
      //     await getImage('images/ToBeRemoved/leg.png'), "Broken Leg"));
      // _injuries.add(new Injury(
      //     await getImage('images/ToBeRemoved/burn.png'), "Burn Injuries"));
      notifyListeners();
    });
  }

  Future<void> saveInjuries(String token) async {
    List<Map<String, dynamic>> injuriesJson = [];
    for(Injury i in _injuries) {
      injuriesJson.add(i.getJson());
    }

    String body = json.encode(injuriesJson);
    print("here");
    print(body);
    print(body.length);
    final http.Response response = await http.post(
      Uri.parse('$url/admin/save_instructions/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      makeToast("Saved");
    } else {
      print(response.statusCode);
      makeToast('Failed to save changes');
    }
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
