
import 'package:flutter/material.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';

void main() =>
    runApp(BodyMapPage());

class BodyMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BodyMapPage',
      theme: ThemeData(
        primarySwatch: primary,
      ),
      home: BodyMap(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class BodyMap extends StatefulWidget {
  static var injury = {'head':false, 'neck':false, 'chest':false, 'shoulderR':false, 'shoulderL':false, 'armR':false, 'armL':false,
  'handR':false, 'handL':false, 'stomach':false, 'legR':false, 'legL':false, 'footR':false, 'footL':false};

  final ValueChanged<bool> onChange = null;
  @override
  _BodyMapState createState() => _BodyMapState();

  static List<String> getSelected() {
    List<String> selected = [];
    for (String key in BodyMap.injury.keys) {
      if(BodyMap.injury[key] == true) {
        selected.add(key);
      }
    }
    return selected;
  }
}

class _BodyMapState extends State<BodyMap> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: InteractiveViewer(child:Center(
          child: Container(
              child: FittedBox(
                fit: BoxFit.contain,
                child: ColumnSuper(
                    innerDistance: -119,
                    children: [
                      ColumnSuper(
                        innerDistance: -19,
                        children: [
                        ColumnSuper(
                            innerDistance: -35,
                            children: [
                              InkWell(
                                  onTap: (){_changeColor('head');},
                                  child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(BodyMap.injury['head']? Colors.red:Colors.white, BlendMode.modulate),
                                      child: Tooltip(message:"Head",child: Image.asset('images/BodyMap/head.png'))
                                  )
                              ),
                              InkWell(
                                  onTap: (){_changeColor('neck');},
                                  child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(BodyMap.injury['neck']? Colors.red:Colors.white, BlendMode.modulate),
                                      child: Tooltip(message:"Neck",child: Image.asset('images/BodyMap/neck.png'))
                                  )
                              )
                            ]),
                          ColumnSuper(
                            innerDistance: -60,
                            children: [
                              RowSuper(
                                innerDistance: -49,
                                children: [
                                  InkWell(
                                      onTap: (){_changeColor('shoulderR');},
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(BodyMap.injury['shoulderR']? Colors.red:Colors.white, BlendMode.modulate),
                                          child: Tooltip(message:"Right Shoulder",child: Image.asset('images/BodyMap/shoulderR.png'))
                                      )
                                  ),
                                  InkWell(
                                      onTap: (){_changeColor('chest');},
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(BodyMap.injury['chest']? Colors.red:Colors.white, BlendMode.modulate),
                                          child: Tooltip(message:"Chest",child: Image.asset('images/BodyMap/chest.png'))
                                      )
                                  ),
                                  InkWell(
                                      onTap: (){_changeColor('shoulderL');},
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(BodyMap.injury['shoulderL']? Colors.red:Colors.white, BlendMode.modulate),
                                          child: Tooltip(message:"Left Shoulder",child: Image.asset('images/BodyMap/shoulderL.png'))
                                      )
                                  )
                                ]
                              ),
                              RowSuper(
                                innerDistance: -10,
                                children: [
                                  ColumnSuper(
                                      innerDistance: -15,
                                      children: [
                                        InkWell(
                                            onTap: (){_changeColor('armR');},
                                            child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(BodyMap.injury['armR']? Colors.red:Colors.white, BlendMode.modulate),
                                                child: Tooltip(message:"Right Arm",child: Image.asset('images/BodyMap/armR.png'))
                                            )
                                        ),
                                        InkWell(
                                            onTap: (){_changeColor('handR');},
                                            child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(BodyMap.injury['handR']? Colors.red:Colors.white, BlendMode.modulate),
                                                child: Tooltip(message:"Right Hand",child: Image.asset('images/BodyMap/handR.png'))
                                            )
                                        )
                                      ]
                                  ),
                                  InkWell(
                                      onTap: (){_changeColor('stomach');},
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(BodyMap.injury['stomach']? Colors.red:Colors.white, BlendMode.modulate),
                                          child: Tooltip(message:"Stomach",child: Image.asset('images/BodyMap/stomach.png'))
                                      )
                                  ),
                                  ColumnSuper(
                                      innerDistance: -15,
                                      children: [
                                        InkWell(
                                            onTap: (){_changeColor('armL');},
                                            child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(BodyMap.injury['armL']? Colors.red:Colors.white, BlendMode.modulate),
                                                child: Tooltip(message:"Left Arm",child: Image.asset('images/BodyMap/armL.png'))
                                            )
                                        ),
                                        InkWell(
                                            onTap: (){_changeColor('handL');},
                                            child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(BodyMap.injury['handL']? Colors.red:Colors.white, BlendMode.modulate),
                                                child: Tooltip(message:"Left Hand",child: Image.asset('images/BodyMap/handL.png'))
                                            )
                                        )
                                      ]
                                  ),
                                ],
                              )
                            ],
                          ),
                      ]),
                      ColumnSuper(
                        innerDistance: -28,
                        children: [
                          RowSuper(
                            innerDistance: 0.5,
                            children: [
                              InkWell(
                                  onTap: (){_changeColor('legR');},
                                  child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(BodyMap.injury['legR']? Colors.red:Colors.white, BlendMode.modulate),
                                      child: Tooltip(message:"Right Leg",child: Image.asset('images/BodyMap/legR.png'))
                                  )
                              ),
                              InkWell(
                                  onTap: (){_changeColor('legL');},
                                  child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(BodyMap.injury['legL']? Colors.red:Colors.white, BlendMode.modulate),
                                      child: Tooltip(message:"Left Leg",child: Image.asset('images/BodyMap/legL.png'))
                                  )
                              ),
                            ],
                          ),
                          RowSuper(
                            innerDistance: -1,
                            children: [
                              InkWell(
                                  onTap: (){_changeColor('footR');},
                                  child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(BodyMap.injury['footR']? Colors.red:Colors.white, BlendMode.modulate),
                                      child: Tooltip(message:"Right Foot",child: Image.asset('images/BodyMap/footR.png'))
                                  )
                              ),
                              InkWell(
                                  onTap: (){_changeColor('footL');},
                                  child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(BodyMap.injury['footL']? Colors.red:Colors.white, BlendMode.modulate),
                                      child: Tooltip(message:"Left Foot",child: Image.asset('images/BodyMap/footL.png'))
                                  )
                              ),
                            ],
                          )
                        ],
                      )
                    ]
                )
              )
          )
      )
    ));
  }

  void _changeColor(var key){
    BodyMap.injury[key] = !BodyMap.injury[key];
    if (mounted) {
      setState(() {});
    }
    widget.onChange?.call(BodyMap.injury[key]);
  }
}