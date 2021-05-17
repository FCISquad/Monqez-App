import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/Model/Instructions/Injury.dart';
import 'package:monqez_app/Screens/Model/Instructions/InstructionsList.dart';
import 'package:monqez_app/Screens/Model/Instructions/Pair.dart';
import '../../main.dart';
import 'file:///C:/Users/Khaled-Predator/Desktop/FCI/GP/Monqez-App/monqez_app/lib/Screens/Instructions/InjuryScreen.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class InstructionsScreen extends StatelessWidget {
  bool _isAdmin;
  InstructionsScreen([this._isAdmin = true]);

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
    List<Injury> instructions = provider.getInjuries();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
            title: getTitle(
                "Instructions", 22.0, secondColor, TextAlign.start, true),
            actions: [
              Visibility(
                visible: _isAdmin,
                child: IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      navigatorKey.currentState.pushNamed('modify_instruction');
                    }),
              )
            ],
            shadowColor: Colors.black,
            backgroundColor: firstColor,
            iconTheme: IconThemeData(color: secondColor),
            elevation: 5),
        body: Container(
          color: secondColor,
          child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 10, left: 10, bottom: 12),
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: instructions.length,
                  itemBuilder: (BuildContext context, int index) {
                    Injury selected = instructions[index];
                    File image = selected.getTitle().getImage();
                    String caption = selected.getTitle().getCaption();

                    return Container(
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
                      child: ListTile(
                        dense: true,
                        tileColor: Colors.transparent,
                        onTap: () {
                          provider.select(index);
                          navigatorKey.currentState.pushNamed('injury');
                        },
                        title: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Visibility(
                              visible: _isAdmin,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    provider.select(index);
                                    navigatorKey.currentState.pushNamed('modify_instruction');
                                  },
                                  child: new Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            border: Border.all(width: 2, color: firstColor)),
                                        child: Icon(
                                          Icons.edit,
                                          color: firstColor,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  image.path,
                                  width: width * 50,
                                  height: width * 50,
                                ),
                                getTitle(caption, 26, firstColor,
                                    TextAlign.center, true),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
        ),
      ),
    );
  }
}
