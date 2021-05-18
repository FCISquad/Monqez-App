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
import 'ImageController.dart';

class ModifyInstruction extends StatefulWidget {
  @override
  ModifyInstructionState createState() => ModifyInstructionState();
}

class ModifyInstructionState extends State<ModifyInstruction> {
  List<TextEditingController> stepsControllers = [TextEditingController()]; // First is title
  List<ImageController> images = [null]; // First is thumbnail

  Injury injury;
  List<Pair> instructions = [];
  ModifyInstructionState([this.injury]);

  double _height;
  double _width;

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

  Future<ImageController> _uploadID() async {
    FilePickerResult _path;
    try {
      _path = (await FilePicker.platform.pickFiles());
    } on PlatformException catch (e) {
      makeToast("Unsupported operation" + e.toString());
    } catch (ex) {
      makeToast(ex);
    }
    if (_path != null && fileType(_path.files.single.path, "image"))
      return ImageController(File(_path.files.single.path));
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
    if (images.length <= i) {
      images.add(null);
    }
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Color(0xFFF3F3F3),
        //border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(5),
      ),
      child: MaterialButton(
        child: (images[i] == null)
            ? Icon(
                Icons.add,
                color: Color(0xFFF27169),
                size: 32,
              )
            : Image.memory(images[i].decode()),
        onPressed: () {
          if (images[i] == null) {
            _buildImagePicker(context, i);
          } else {
            _showMyDialog(i);
          }
          print("Tapped");
        },
      ),
    );
  }

  void addStep() {
    showDialog(
        context: context,
        builder: (context) {
          int i = instructions.length + 1;
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: _height * 60,
                width: _width * 90,
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
                          context,
                          "Step Title",
                          MediaQuery.of(context).size.width,
                          i),
                      SizedBox(height: 10.0),
                      SizedBox(
                        width: 200,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          onPressed: () {
                            print("Here " + instructions.length.toString());
                            instructions.add(new Pair(
                                images.last, stepsControllers.last.text));
                            print("Here2 " + instructions.length.toString());
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
            if (images[0] == null || stepsControllers[0].text == "") {
              makeToast("Please insert title correctly!");
              return;
            }
            injury = new Injury(images[0], stepsControllers[0].text );
            injury.setInstructions(instructions);

             Provider.of<InstructionsList>(context, listen: false).addInjury(injury);
             Navigator.pop(context);

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

  Widget _buildField(BuildContext context, String title, double width,
      [int index = 0]) {
    if (stepsControllers.length <= index) {
      print("Adding");
      stepsControllers.add(new TextEditingController());
    }
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: secondColor,
        border: Border.all(color: firstColor, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
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
                controller: stepsControllers[index],
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
            getTitle("Thumbnail", 16, firstColor, TextAlign.center, true),
            SizedBox(height: 10.0),
            Center(child: getImage(index)),
          ],
        ),
      ),
    );
  }

  /*
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
  }*/

  @protected
  @mustCallSuper
  void deactivate() {
    super.deactivate();
    Provider.of<InstructionsList>(context, listen: false).unSelect();
  }
  @override
  void initState() {
    super.initState();
    var provider = Provider.of<InstructionsList>(context, listen: false);
    if (provider.edit){
      injury = provider.getSelected();
      stepsControllers[0].text = injury.getTitle().getCaption();
      images[0] = injury.getTitle().getImage();
      instructions = injury.getInstructions();
      for(Pair pair in instructions) {
        stepsControllers.add(new TextEditingController(text: pair.getCaption()));
        images.add(pair.getImage());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width / 100;
    _height =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) /
            100;
    if (_width > _height) {
      double temp = _width;
      _width = _height;
      _height = temp;
    }


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
          onPressed: () {
            Navigator.pop(context);
            },
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
                    ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 20,
                          );
                        },
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: instructions.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(instructions.length);
                          return _buildField(
                              context, "Step Text", _width * 100, index + 1);
                        }),
                    SizedBox(height: 20,),
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
