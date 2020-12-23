import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monqez - View Application'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Something"),
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
        'https://learn-eu-central-1-prod-fleet01-xythos.content.blackboardcdn.com/5f773d6e67638/808851?X-Blackboard-Expiration=1608768000000&X-Blackboard-Signature=tT8oRX2SO2YaZHAd5d7uLPXiCAHrysl4z3Za7%2FmtWgU%3D&X-Blackboard-Client-Id=306828&response-cache-control=private%2C%20max-age%3D21600&response-content-disposition=inline%3B%20filename%2A%3DUTF-8%27%27Assignment%25203%2520-%2520Fuzzy%2520Logic.pdf&response-content-type=application%2Fpdf&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20201223T180000Z&X-Amz-SignedHeaders=host&X-Amz-Expires=21600&X-Amz-Credential=AKIAZH6WM4PL5M5HI5WH%2F20201223%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Signature=4e757c31c3960960b86375e8f1dc5e5ae072ad95bb60766c67e51fc5cbe46047');
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


}
