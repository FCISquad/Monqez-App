import 'package:http/http.dart' as http;
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appID = '0ab37d96b60442c8985a93189f3402cb';

class VoicePage extends StatefulWidget {
  final String channelName;

  final String userType;
  const VoicePage({Key key, this.channelName, this.userType}) : super(key: key);

  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool speaker = false;
  RtcEngine _engine;
  bool screenEnabled = true;
  bool _monqezJoined = false;
  String textEnabled = "Double tap to lock the controls";
  String textDisabled = "Double tap to unlock the controls";

  Future<void> callOut() async {
    var _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString("userToken");
    await http.post(
      Uri.parse('$url/user/call_out/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    if (widget.userType == "normal") {
      callOut();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (appID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();

    await _engine.setDefaultAudioRoutetoSpeakerphone(speaker);
    await _engine.joinChannel(null, widget.channelName, null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appID);
    await _engine.enableVideo();
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
          _monqezJoined = true;
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          final info = 'userOffline: $uid , reason: $reason';
          _monqezJoined = false;
          _infoStrings.add(info);
          _users.remove(uid);
        });
      },
    ));
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchSpeaker,
            child: Icon(
              Icons.volume_up,
              color: speaker ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: speaker ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  String titleWait = "Voice Call - waiting";
  String titleJoined = "Voice Call - InCall";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_monqezJoined ? titleJoined : titleWait),
        leading: IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              if (screenEnabled) {
                Navigator.pop(context);
              }
            }),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProfileAvatar(
                  null,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  borderColor: _monqezJoined ? Colors.green : firstColor,
                  elevation: 5.0,
                  cacheImage: true,
                  onTap: () {
                  },
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      screenEnabled = !screenEnabled;
                    });
                  },
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(), color: Colors.red),
                    child: Text(
                      screenEnabled ? textEnabled : textDisabled,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
            IgnorePointer(ignoring: !screenEnabled, child: _toolbar()),
          ],
        ),
      ),
    );
  }
  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchSpeaker() {
    setState(() {
      speaker = !speaker;
    });
    _engine.setEnableSpeakerphone(speaker);
  }
}
