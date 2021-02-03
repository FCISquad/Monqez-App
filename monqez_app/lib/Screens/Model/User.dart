import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monqez_app/Backend/Authentication.dart';

class User {
  String name;
  String nationaID;
  String phone;
  String birthdate;
  String country;
  String city;
  String street;
  String buildNumber;
  String gender;
  String _token;
  String status;

  User(String token) {
    this._token = token;
  }
  getUser() async{
     http.Response response2 = await http.get(
      '$url/user/getprofile/',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response2.statusCode == 200){
      var parsed = jsonDecode(response2.body).cast<String, dynamic>();
      this.name = parsed['name'];
      this.nationaID = parsed['national_id'];
      this.phone = parsed['phone'];
      this.birthdate = parsed['birthdate'];
      this.country = parsed['country'];
      this.city = parsed['city'];
      this.street = parsed['street'];
      this.buildNumber = parsed['buildNumber'];
      this.gender = parsed['gender'];
    }
    else{
      print(response2.statusCode);
      //makeToast("Error!");
    }
  }

  getHelper() async{
    await getUser();
    await getState();
  }

  getState() async {
    http.Response response2 = await http.get(
      '$url/helper/getstate/',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response2.statusCode == 200){
      var parsed = jsonDecode(response2.body).cast<String, dynamic>();
      this.status = parsed['status'];
    }
    else{
      print(response2.statusCode);
    }
  }
  Future<bool> saveUser() async {
    final http.Response response = await http.post(
      '$url/user/edit',
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'national_id': nationaID,
        'phone': phone,
        'birthdate': birthdate,
        'gender': gender,
        'country': country,
        'city': city,
        'street': street,
        'buildNumber': buildNumber
      }),
    );
    if (response.statusCode == 200) {
      makeToast("Saved");
      return true;
    } else {
      print(response.statusCode);
      makeToast('Failed to save changes');
      return false;
    }
  }
}