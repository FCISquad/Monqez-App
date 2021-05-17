import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/Model/Instructions/Injury.dart';
import 'package:monqez_app/Screens/Model/Instructions/InstructionsList.dart';
import 'package:monqez_app/Screens/Model/Instructions/Pair.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ModifyInstruction extends StatefulWidget {
  @override
  ModifyInstructionState createState() => ModifyInstructionState();
}

class ModifyInstructionState extends State<ModifyInstruction> {
  TextEditingController titleController;
  List<TextEditingController> stepsControllers = [];
  List<File> images = [];
  Injury injury;
  Pair title;
  List<Pair> instructions;
  ModifyInstructionState([this.injury]);

  Widget getText(String text, double fontSize, bool isBold, Color color) {
    return AutoSizeText(text,
        style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        maxLines: 3);
  }

  bool fileType(String path, String type) {
    final mimeType = lookupMimeType(path);
    return mimeType.startsWith(type + '/');
  }

  Future<File> _uploadID() async {
    FilePickerResult _path;
    try {
      _path = (await FilePicker.platform.pickFiles());
    } on PlatformException catch (e) {
      makeToast("Unsupported operation" + e.toString());
    } catch (ex) {
      makeToast(ex);
    }
    if (_path != null && fileType(_path.files.single.path, "image"))
      return File(_path.files.single.path);
    else {
      makeToast("Please Upload a photo!");
      return null;
    }
  }

  void _buildImagePicker(BuildContext context, int i) async {
    images[i] = await _uploadID();
    setState(() {});
  }

  Future<void> _showMyDialog(int i) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: getText('Replace', 22, true, Colors.green),
                  onPressed: () {
                    print("Replaced");
                    Navigator.of(context).pop();
                    _buildImagePicker(context, i);
                  },
                ), // button 1
                TextButton(
                  child: getText('Remove', 22, true, Color(0xFFF27169)),
                  onPressed: () {
                    images[i] = null;
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ) // button 2
              ]),
        );
      },
    );
  }

  Widget getImage(int i) {
    if (images.length >= i) {
      images.add(null);
    }
    return Ink(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Color(0xFFF3F3F3),
        //border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
          onTap: () {
            File w = images[i];
            if (w == null) {
              _buildImagePicker(context, i);
            } else {
              _showMyDialog(i);
            }
            print("Tapped");
          },
          child: (images[i] == null)
              ? Icon(
                  Icons.add,
                  color: Color(0xFFF27169),
                  size: 32,
                )
              : Image.file(images[i])),
    );
  }

  void addStep() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 400,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                            "Injuries",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                      SizedBox(height: 20),
                      _buildField(
                          context, "Step Text", MediaQuery.of(context).size.width, 0),
                      SizedBox(height: 10.0),
                      SizedBox(
                        width: 200,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.deepOrange,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
  Widget _buildBtn(BuildContext context, String text) {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width / 2,
      height: 45,
      // ignore: deprecated_member_use
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if (text == "Submit") {
            //submit;
            //Navigator.pop(context);
          } else {
            addStep();
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: firstColor,
        child: Text(
          text,
          style: TextStyle(
            color: secondColor,
            letterSpacing: 1,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      BuildContext context, String title, double width, [int index = -1]) {
    if (index != -1 && stepsControllers.length >= index) {
      stepsControllers.add(new TextEditingController());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getTitle(title, 16, firstColor, TextAlign.center, true),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: firstColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50.0,
          width: width,
          child: TextField(
            keyboardType: TextInputType.name,
            controller: index == -1 ? titleController : stepsControllers[index],
            style: TextStyle(
              color: secondColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(14.0),
              hintText: "Enter",
              hintStyle: TextStyle(
                color: secondColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        getTitle(
            "Thumbnail", 16, firstColor, TextAlign.center, true),
        SizedBox(height: 10.0),
        Center(child: getImage(index)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 100;
    double height =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) /
            100;
    if (width > height) {
      double temp = width;
      width = height;
      height = temp;
    }
    var provider = Provider.of<InstructionsList>(context);
    injury = provider.getSelected();
    title = (injury == null) ? null : injury.getTitle();
    instructions =
        (injury == null) ? null : injury.getInstructions();

    // TODO: implement build
    return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
        title:
            getTitle("Modify Injury", 22.0, secondColor, TextAlign.start, true),
        shadowColor: Colors.black,
        backgroundColor: firstColor,
        iconTheme: IconThemeData(color: secondColor),
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                        context, "Title", MediaQuery.of(context).size.width, 0),
                    SizedBox(height: 10.0),
                    Center(child: _buildBtn(context, "Add Step")),
                    SizedBox(height: 10.0),
                    Center(child: _buildBtn(context, "Submit"))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
