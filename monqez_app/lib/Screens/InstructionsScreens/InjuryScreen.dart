import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monqez_app/Models/Instructions/Injury.dart';
import 'package:monqez_app/Models/Instructions/InstructionsList.dart';
import 'package:monqez_app/Models/Instructions/Pair.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:provider/provider.dart';

class InjuryScreen extends StatefulWidget {
  @override
  _InjuryScreenState createState() => _InjuryScreenState();
}

class _InjuryScreenState extends State<InjuryScreen> {
  Injury injury;

  Widget getText(String text, double fontSize, bool isBold, Color color) {
    return AutoSizeText(text,
        style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        maxLines: 3);
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
    Pair title = injury.getTitle();
    List<Pair> instructions = injury.getInstructions();

    return MaterialApp(
        home: Scaffold(
            body: Scaffold(
                body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          snap: false,
          floating: false,
          expandedHeight: height * 24,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: firstColor,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: EdgeInsets.only(bottom: 10),
            title: Align(
              alignment: Alignment.bottomCenter,
              child: getText(title.getCaption(), 22, true, secondColor),
            ),
            background: Padding(
              padding: EdgeInsets.all(50),
              child: Center(
                child: Image.memory(
                  title.getImage().decode(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 8,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                color: index.isOdd ? Colors.white : Colors.black12,
                height: height * 34,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getText(instructions[index].getCaption(), 24, false,
                        Colors.black),
                    Image.memory(
                      instructions[index].getImage().decode(),
                      height: height * 14,
                    )
                  ],
                ),
              );
            },
            childCount: instructions.length,
          ),
        ),
      ],
    ))));
  }
}
