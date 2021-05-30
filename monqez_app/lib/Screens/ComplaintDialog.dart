import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class complaintDialog extends StatefulWidget {
  @override
  _complaintDialogState createState() => _complaintDialogState();
}
class _complaintDialogState extends State<complaintDialog> {

  Widget _getText(String text, double fontSize, Color color,FontWeight fontWeight) {
    return AutoSizeText(text,
      textDirection: TextDirection.ltr,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: 'Cairo',
          fontWeight: fontWeight
      ),

    );
  }

  Widget _showMaterialDialog() {
    double width = MediaQuery.of(context).size.width / 100;
    double height =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) /
            100;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(

              insetPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child:SingleChildScrollView(
            scrollDirection: Axis.vertical ,
              child :Container(
                height: height*65,
                width: width*80,
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 7.5 * height,
                          width: 60 * width,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(237, 237, 237,1),
                            borderRadius: BorderRadius.circular(50.0),),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center ,
                            children: [
                              Image.asset('images/users.png',
                              ),
                              SizedBox(width: 2.5*width,),
                              _getText("Make a complaint", 18, Colors.black,FontWeight.w600),
                            ],
                          ) ,
                        ),
                      ),
                      SizedBox(height: height*2),
                      Container(
                          width: 60*width ,
                          height: 50*height ,
                          child :Directionality
                            (
                              textDirection: TextDirection.ltr,
                              child: Align
                                (
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    children: [
                                      Align(
                                          alignment:Alignment.bottomLeft,
                                          child: _getText("Subject", 16, Colors.black, FontWeight.w600)),
                                      TextField(
                                        //autofocus: true,
                                          decoration: InputDecoration(
                                              hintText: "Subject" ,
                                              hintStyle: TextStyle(
                                                color:Colors.black,
                                                fontSize: 10,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w300,
                                              ),
                                              enabledBorder:  UnderlineInputBorder(
                                                  borderSide:  BorderSide(color: Colors.black)
                                              ))
                                      ),
                                      SizedBox(height: height*2,),
                                      Align(
                                          alignment:Alignment.topLeft,
                                          child: _getText("Message Details", 16, Colors.black, FontWeight.w600)),
                                      SizedBox(height: 2*height),
                                      Container(
                                          height:height* 17 ,
                                          width: width * 80,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                              color:Color.fromRGBO(237, 237, 237,1) ,
                                              shape: BoxShape.rectangle,
                                              border: new Border.all(
                                                  color: Colors.black,
                                                  width: 0.5)),
                                          child : TextField(
                                              decoration: new InputDecoration.collapsed(
                                              )
                                          )),//.horizontal
                                      SizedBox(height:height*5,),
                                      Container(
                                          height: 5*height,
                                          width: 40*width,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50.0),
                                            color: Colors.deepOrange

                                          ),
                                          child: FlatButton(
                                            color: Colors.transparent,
                                            splashColor: Colors.black26,
                                            onPressed: () {
                                              print('done');
                                            },
                                            child: _getText('Submit', 16, Colors.white,FontWeight.w600),
                                          )
                                      )
                                    ],
                                  )
                              )
                          ),
                      )
                    ],
                  ),

              )),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset :false,
          body:  Center(
            child: RaisedButton(
              onPressed: _showMaterialDialog,
            ),
          )),
    );
  }
}