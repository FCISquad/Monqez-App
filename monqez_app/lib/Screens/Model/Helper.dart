import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monqez_app/Backend/Authentication.dart';

import 'User.dart';

class Helper extends User {
  String status;

  Helper(String token) : super(token);

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
  }
}
