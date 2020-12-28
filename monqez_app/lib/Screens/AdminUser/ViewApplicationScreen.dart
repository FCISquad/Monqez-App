import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ViewApplicationScreen extends StatefulWidget {
  @override
  _ViewApplicationScreenState createState() => _ViewApplicationScreenState();
}

class _ViewApplicationScreenState extends State<ViewApplicationScreen> {
  String path;
  @override
  initState() {
    super.initState();
  }
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
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
                  margin: const EdgeInsets.only(top: 30.0, left: 10, right: 10),
                  child: SizedBox(
                      height: 130.0,
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
                                      child: Icon(Icons.person, size: 14, color: color,),
                                    ),
                                    TextSpan(
                                      text: " Hussien Ashraf\n",
                                      style: TextStyle(
                                          color: color,
                                          fontSize: 14,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: Icon(Icons.email, size: 14 , color: color,),
                                    ),
                                    TextSpan(
                                      recognizer: new TapGestureRecognizer()..onTap = () => _launchMail("hussienashraf99@gmail.com"),
                                      text: " hussienashraf99@gmail.com\n",
                                        style: TextStyle(
                                            color: color,
                                            fontSize: 14,
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.bold
                                        ),
                                    ),
                                    WidgetSpan(
                                      child: Icon(Icons.phone, size: 14, color: color),
                                    ),
                                    TextSpan(
                                      recognizer: new TapGestureRecognizer()..onTap = () => _launchCaller("01016395068"),
                                      text: " 01016395068\n",
                                        style: TextStyle(
                                            color: color,
                                            fontSize: 14,
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.bold
                                        ),
                                    ),
                                    WidgetSpan(
                                      child: Icon(Icons.accessibility_outlined, size: 14, color: color),
                                    ),
                                    TextSpan(
                                        text: " male\n",
                                        style: TextStyle(
                                            color: color,
                                            fontSize: 14,
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.bold
                                        ),
                                    ),
                                    WidgetSpan(
                                      child: Icon(Icons.calendar_today, size: 14, color: color,),
                                    ),
                                    TextSpan(
                                        text: " 4/8/1999\n",
                                        style: TextStyle(
                                            color: color,
                                            fontSize: 14,
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.bold
                                        ),
                                    ),
                                  ],
                                ),
                              )

                            ),
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
                height: 300.0,
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
                  onPressed: loadPdf,
                heroTag: 'accept',
                  child: Icon(Icons.check, color: Colors.white),
                  backgroundColor: Colors.green
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            child: Align(
              alignment: Alignment.bottomLeft,
              widthFactor:0.5 ,
              child: FloatingActionButton(
                  onPressed: () {},
                heroTag: 'decline',
                  child: Icon(Icons.close, color: Colors.white,),
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
    final response = await http.get(
    'http://www.pdf995.com/samples/pdf.pdf');
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  void loadPdf() async {
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
    String  url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }
  }


}