import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Backend/FirebaseCloudMessaging.dart';

class User {
  String name;
  String nationalID;
  String phone;
  String birthdate;
  String country;
  String city;
  String street;
  String buildNumber;
  String gender;
  String token;
  String diseases = "";
  static FirebaseCloudMessaging fcm;

  User.empty();

  /*User(String token) {
    this.token = token;
    fcm = new FirebaseCloudMessaging(token);
  }*/
  setToken(String token) {
    this.token = token;
    if (fcm == null) {
      fcm = new FirebaseCloudMessaging(token);
    }
    /*if(!FirebaseCloudMessaging.tokenTaken){
      FirebaseCloudMessaging.tokenTaken=true;
    fcm = new FirebaseCloudMessaging(token);
    }*/
  }

  getUser() async {
    http.Response response2 = await http.get(
      Uri.parse('$url/user/getprofile/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response2.statusCode == 200) {
      var parsed = jsonDecode(response2.body).cast<String, dynamic>();
      this.name = parsed['name'];
      this.nationalID = parsed['national_id'];
      this.phone = parsed['phone'];
      this.birthdate = parsed['birthdate'];
      this.country = parsed['country'];
      this.city = parsed['city'];
      this.street = parsed['street'];
      this.buildNumber = parsed['buildNumber'];
      this.gender = parsed['gender'];
      this.diseases = parsed['chronicDiseases'];
    } else {
      print("HERE!");
      print(response2.statusCode);
      //makeToast("Error!");
    }
  }

  Future<bool> saveUser() async {
    final http.Response response = await http.post(
      Uri.parse('$url/user/edit'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'national_id': nationalID,
        'phone': phone,
        'birthdate': birthdate,
        'gender': gender,
        'country': country,
        'city': city,
        'street': street,
        'buildNumber': buildNumber,
        'chronicDiseases': diseases
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
