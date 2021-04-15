import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'AdminHomeScreen.dart';

// ignore: must_be_immutable
class ViewApplicationScreen extends StatefulWidget {
  String uid;
  ViewApplicationScreen(String uid) {
    this.uid = uid;
  }
  @override
  _ViewApplicationScreenState createState() => _ViewApplicationScreenState(uid);
}

class _ViewApplicationScreenState extends State<ViewApplicationScreen> {
  bool isLoading = true;
  String uid;
  Color color = Colors.white;
  String path;

  String name;
  String birthdate;
  String nationalID;
  String phone;
  String gender;
  String certificate;
  parseJson(var json) {
    var singleApplication = jsonDecode(json).cast<String, dynamic>();

    name = singleApplication['name'];
    birthdate = singleApplication['birthdate'];
    nationalID = singleApplication['national_id'];
    phone = singleApplication['phone'];
    gender = singleApplication['gender'];
    certificate = singleApplication['certificate'];
    print(singleApplication['certificate']);
  }

  Future<void> getApplication() async {
    String token = AdminHomeScreenState.token;

    final http.Response response = await http.post(
      Uri.parse('$url/admin/get_application/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{'userID': uid}),
    );
    if (response.statusCode == 200) {
      print(response.body);
      parseJson(response.body);
      await loadPdf();
      setState(() {
        isLoading = false;
      });
      return true;
    } else {
      print(response.statusCode);
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  _ViewApplicationScreenState(String uid) {
    this.uid = uid;
    getApplication();
  }

  @override
  initState() {
    super.initState();
  }

  void setResult(bool isApproved) async {
    print(isApproved.toString());
    String token = AdminHomeScreenState.token;

    final http.Response response = await http.post(
      Uri.parse('$url/admin/set_approval/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'userID': uid,
        'date': DateTime.now().toString(),
        'result': isApproved.toString()
      }),
    );
    if (response.statusCode == 200) {
      makeToast("Successful");
      Navigator.pop(context);
      //navigate(ApplicationsScreen(), context, true);
    } else {
      print(response.statusCode);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              height: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 5,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.deepOrangeAccent)))));
    } else
      return Scaffold(
        appBar: AppBar(
          title: Text('Monqez - View Application'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //CustomCard(),
              Stack(
                children: <Widget>[
                  Card(
                    color: Colors.deepOrangeAccent,
                    margin:
                        const EdgeInsets.only(top: 30.0, left: 10, right: 10),
                    child: SizedBox(
                        height: 142.0,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30, left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.person,
                                            size: 14,
                                            color: color,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " $name\n",
                                          style: TextStyle(
                                              color: color,
                                              fontSize: 14,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.perm_identity,
                                            size: 14,
                                            color: color,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " $nationalID\n",
                                          style: TextStyle(
                                              color: color,
                                              fontSize: 14,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.email,
                                            size: 14,
                                            color: color,
                                          ),
                                        ),
                                        TextSpan(
                                          recognizer: new TapGestureRecognizer()
                                            ..onTap = () => _launchMail(
                                                "hussienashraf99@gmail.com"),
                                          text: " hussienashraf99@gmail.com\n",
                                          style: TextStyle(
                                              color: color,
                                              fontSize: 14,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        WidgetSpan(
                                          child: Icon(Icons.phone,
                                              size: 14, color: color),
                                        ),
                                        TextSpan(
                                          recognizer: new TapGestureRecognizer()
                                            ..onTap =
                                                () => _launchCaller("$phone"),
                                          text: " $phone\n",
                                          style: TextStyle(
                                              color: color,
                                              fontSize: 14,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        WidgetSpan(
                                          child: Icon(
                                              Icons.accessibility_outlined,
                                              size: 14,
                                              color: color),
                                        ),
                                        TextSpan(
                                          text: " $gender\n",
                                          style: TextStyle(
                                              color: color,
                                              fontSize: 14,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: color,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " $birthdate\n",
                                          style: TextStyle(
                                              color: color,
                                              fontSize: 14,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        )),
                  ),
                  Positioned(
                    top: .0,
                    left: .0,
                    right: .0,
                    child: Center(
                      child: CircleAvatar(
                        radius: 30.0,
                        child: Text("MA"),
                      ),
                    ),
                  )
                ],
              ),
              if (path != null)
                Container(
                  height: MediaQuery.of(context).size.height - 255,
                  child: PdfView(
                    path: path,
                  ),
                )
              else
                Text("Pdf is not Loaded"),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    onPressed: () => {setResult(true)},
                    heroTag: 'accept',
                    child: Icon(Icons.check, color: Colors.white),
                    backgroundColor: Colors.green),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Align(
                alignment: Alignment.bottomLeft,
                //widthFactor:0.5 ,
                child: FloatingActionButton(
                  onPressed: () => {setResult(false)},
                  heroTag: 'decline',
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.exists();
  }

  Future<Uint8List> fetchPost() async {
    var bytes2 = base64Decode(certificate.replaceAll('\n', ''));
    return bytes2;
  }

  Future<void> loadPdf() async {
    await writeCounter(await fetchPost());
    await existsFile();
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

  _launchCaller(String number) async {
    String url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchMail(String mail) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: mail,
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
