import 'package:flutter/material.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';

void main() => runApp(BodyMapPage());

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

// ignore: must_be_immutable
class BodyMap extends StatefulWidget {
  var injury = {
    'head': false,
    'neck': false,
    'chest': false,
    'shoulderR': false,
    'shoulderL': false,
    'armR': false,
    'armL': false,
    'handR': false,
    'handL': false,
    'stomach': false,
    'legR': false,
    'legL': false,
    'footR': false,
    'footL': false
  };

  final ValueChanged<bool> onChange = null;
  String _selected;
  double _size;

  BodyMap.init(int bodyValue, double size) {
    setSelected(bodyValue);
    _size = size;
  }

  BodyMap();
  @override
  _BodyMapState createState() {
    return _BodyMapState();
  }

  void setSelected(int selected) {
    _selected = selected.toRadixString(2);
    int diff = injury.length-_selected.length ;
    for (int i=0 ; i<(diff) ; i++) {
      _selected = "0" + _selected;
    }
  }


  int getSelected() {
    List<int> binary = [];
    List<String> selected = [];
    for (String key in this.injury.keys) {
      if (this.injury[key] == true) {
        selected.add(key);
        binary.add(1);
      } else
        binary.add(0);
    }
    print(selected);
    int result = 0;
    for (var digit in binary) {
      result <<= 1;
      result |= digit;
    }
    print(result);
    return result;
  }
}

class _BodyMapState extends State<BodyMap> {
  @override
  Widget build(BuildContext context) {
    if (widget._selected != null) setSelected(widget._selected);

    return new Scaffold(
        backgroundColor: Colors.white,
        body: InteractiveViewer(
            child: Center(
                child: Container(
                    height: widget._size,
                    width: widget._size,
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: ColumnSuper(innerDistance: -119, children: [
                          ColumnSuper(innerDistance: -19, children: [
                            ColumnSuper(innerDistance: -35, children: [
                              InkWell(
                                  onTap: () {
                                    _changeColor('head');
                                  },
                                  child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          widget.injury['head']
                                              ? Colors.red
                                              : Colors.white,
                                          BlendMode.modulate),
                                      child: Tooltip(
                                          message: "Head",
                                          child: Image.asset(
                                              'images/BodyMap/head.png')))),
                              InkWell(
                                  onTap: () {
                                    _changeColor('neck');
                                  },
                                  child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          widget.injury['neck']
                                              ? Colors.red
                                              : Colors.white,
                                          BlendMode.modulate),
                                      child: Tooltip(
                                          message: "Neck",
                                          child: Image.asset(
                                              'images/BodyMap/neck.png'))))
                            ]),
                            ColumnSuper(
                              innerDistance: -60,
                              children: [
                                RowSuper(innerDistance: -49, children: [
                                  InkWell(
                                      onTap: () {
                                        _changeColor('shoulderR');
                                      },
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              widget.injury['shoulderR']
                                                  ? Colors.red
                                                  : Colors.white,
                                              BlendMode.modulate),
                                          child: Tooltip(
                                              message: "Right Shoulder",
                                              child: Image.asset(
                                                  'images/BodyMap/shoulderR.png')))),
                                  InkWell(
                                      onTap: () {
                                        _changeColor('chest');
                                      },
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              widget.injury['chest']
                                                  ? Colors.red
                                                  : Colors.white,
                                              BlendMode.modulate),
                                          child: Tooltip(
                                              message: "Chest",
                                              child: Image.asset(
                                                  'images/BodyMap/chest.png')))),
                                  InkWell(
                                      onTap: () {
                                        _changeColor('shoulderL');
                                      },
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              widget.injury['shoulderL']
                                                  ? Colors.red
                                                  : Colors.white,
                                              BlendMode.modulate),
                                          child: Tooltip(
                                              message: "Left Shoulder",
                                              child: Image.asset(
                                                  'images/BodyMap/shoulderL.png'))))
                                ]),
                                RowSuper(
                                  innerDistance: -10,
                                  children: [
                                    ColumnSuper(innerDistance: -15, children: [
                                      InkWell(
                                          onTap: () {
                                            _changeColor('armR');
                                          },
                                          child: ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                  widget.injury['armR']
                                                      ? Colors.red
                                                      : Colors.white,
                                                  BlendMode.modulate),
                                              child: Tooltip(
                                                  message: "Right Arm",
                                                  child: Image.asset(
                                                      'images/BodyMap/armR.png')))),
                                      InkWell(
                                          onTap: () {
                                            _changeColor('handR');
                                          },
                                          child: ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                  widget.injury['handR']
                                                      ? Colors.red
                                                      : Colors.white,
                                                  BlendMode.modulate),
                                              child: Tooltip(
                                                  message: "Right Hand",
                                                  child: Image.asset(
                                                      'images/BodyMap/handR.png'))))
                                    ]),
                                    InkWell(
                                        onTap: () {
                                          _changeColor('stomach');
                                        },
                                        child: ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                                widget.injury['stomach']
                                                    ? Colors.red
                                                    : Colors.white,
                                                BlendMode.modulate),
                                            child: Tooltip(
                                                message: "Stomach",
                                                child: Image.asset(
                                                    'images/BodyMap/stomach.png')))),
                                    ColumnSuper(innerDistance: -15, children: [
                                      InkWell(
                                          onTap: () {
                                            _changeColor('armL');
                                          },
                                          child: ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                  widget.injury['armL']
                                                      ? Colors.red
                                                      : Colors.white,
                                                  BlendMode.modulate),
                                              child: Tooltip(
                                                  message: "Left Arm",
                                                  child: Image.asset(
                                                      'images/BodyMap/armL.png')))),
                                      InkWell(
                                          onTap: () {
                                            _changeColor('handL');
                                          },
                                          child: ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                  widget.injury['handL']
                                                      ? Colors.red
                                                      : Colors.white,
                                                  BlendMode.modulate),
                                              child: Tooltip(
                                                  message: "Left Hand",
                                                  child: Image.asset(
                                                      'images/BodyMap/handL.png'))))
                                    ]),
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
                                      onTap: () {
                                        _changeColor('legR');
                                      },
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              widget.injury['legR']
                                                  ? Colors.red
                                                  : Colors.white,
                                              BlendMode.modulate),
                                          child: Tooltip(
                                              message: "Right Leg",
                                              child: Image.asset(
                                                  'images/BodyMap/legR.png')))),
                                  InkWell(
                                      onTap: () {
                                        _changeColor('legL');
                                      },
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              widget.injury['legL']
                                                  ? Colors.red
                                                  : Colors.white,
                                              BlendMode.modulate),
                                          child: Tooltip(
                                              message: "Left Leg",
                                              child: Image.asset(
                                                  'images/BodyMap/legL.png')))),
                                ],
                              ),
                              RowSuper(
                                innerDistance: -1,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        _changeColor('footR');
                                      },
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              widget.injury['footR']
                                                  ? Colors.red
                                                  : Colors.white,
                                              BlendMode.modulate),
                                          child: Tooltip(
                                              message: "Right Foot",
                                              child: Image.asset(
                                                  'images/BodyMap/footR.png')))),
                                  InkWell(
                                      onTap: () {
                                        _changeColor('footL');
                                      },
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              widget.injury['footL']
                                                  ? Colors.red
                                                  : Colors.white,
                                              BlendMode.modulate),
                                          child: Tooltip(
                                              message: "Left Foot",
                                              child: Image.asset(
                                                  'images/BodyMap/footL.png')))),
                                ],
                              )
                            ],
                          )
                        ]))))));
  }

  void setSelected(String s) {
    if (_BodyMapState != null) {
      for (String key in widget.injury.keys) {
        widget.injury[key] = false;
      }
      for (int i = 0; i < s.length; i++)
        // True  1 don't'
        // False 1 change
        // True  0 change
        // False 0 change
        if (widget.injury.values.elementAt(i) != (s[i] == "1")) {
          _changeColor(widget.injury.keys.elementAt(i));
        }
    }
  }

  void _changeColor(var key) {
    widget.injury[key] = !widget.injury[key];
    if (mounted) {
      setState(() {});
    }
    if (widget.onChange != null) widget.onChange?.call(widget.injury[key]);
  }
}
