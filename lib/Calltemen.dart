// import 'main.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math';
import 'main.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_phone_state/extensions_static.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
//Semacam Session
// import 'package:shared_preferences/shared_preferences.dart';
 
class CallTemen extends StatefulWidget {
  @override
  _CallTemenState createState() => _CallTemenState();
}

class _CallTemenState extends State<CallTemen> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();
  List list;  
  String _phoneNumber;
  List<RawPhoneEvent> _rawEvents;
  List<PhoneCallEvent> _phoneEvents;

  final myCon  = TextEditingController(text: '0821');
  
  @override
  void initState() {
    super.initState();
    _phoneEvents = _accumulate(FlutterPhoneState.phoneCallEvents);
    _rawEvents = _accumulate(FlutterPhoneState.rawPhoneEvents);
    
    getPref();
    this.getData();
  }
  List<R> _accumulate<R>(Stream<R> input) {
    final items = <R>[];
    input.forEach((item) {
      if (item != null) {
        setState(() {
          items.add(item);
        });
      }
    });
    return items;
  }
  
  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener
        );
    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    print(
        "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: "in_ID",
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true);
    // print(lastWords);
    
    setState(() {});
    

  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
    if (lastWords == 'Lala'){
      print(myCon);
      _initiateCall();
    }
    });
  }

  _initiateCall() {
      setState(() {
        FlutterPhoneState.startPhoneCall(_phoneNumber);
      });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    //print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  Future<Map<String,dynamic>> getData() async {
    final response = await http.get('http://blindco.pkyuk.com/pkbackend/public/api/anggota/${iduser.toString()}');
    setState(() {
      list =  json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
     return new Scaffold(
      appBar: AppBar(
          title: Text('BlindCO'),
        ),
      body: new ListView.builder(
        itemCount: list ==  null ? 0 : list.length,
        itemBuilder: (context, i)
        {
          return new Stack(
            children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: MediaQuery.of(context).size.width * 0.05,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],                
              ),              
              child: Text(lastWords),
            ),
          new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch ,
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(top: 20)),
            new Card(
              child: new Column(
                children: <Widget>[
                  new Text(list[i]['nama'], style: new TextStyle( fontSize: 20.0)),
                  new TextField(controller: myCon,readOnly: true,textAlign: TextAlign.center , )
                ],
              ),
            ),
          ],
        ),
            
            Padding(
              padding: const EdgeInsets.only(top : 10.0),
              child: Align(
                alignment: Alignment.topRight,
                child :  FlatButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: _hasSpeech ? null : initSpeechState,
                    ),
                
              ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Align(
                alignment: Alignment.topRight,
                child :  FlatButton(
                      child: Icon(Icons.mic) ,
                      onPressed: !_hasSpeech || speech.isListening
                          ? null
                          : startListening,
                      
                    ),
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Align(
                alignment: Alignment.topRight,
                child :  FlatButton(
                      child: Icon(Icons.add) ,
                      onPressed: () {
                        Navigator.pushNamed(context, '/Tambahdata');
                        }
                    ),
                
              ),
            ),
        ],
          );
        },
      )
      // body: new Stack(
      //   children: <Widget>[
      //     Container(
      //         width: MediaQuery.of(context).size.width * 1.0,
      //         height: MediaQuery.of(context).size.width * 0.05,
      //         decoration: BoxDecoration(
      //           color: Colors.cyanAccent[100],                
      //         ),              
      //         child: Text(lastWords),
      //       ),
      //     new Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch ,
      //     children: <Widget>[
      //       new Padding(padding: const EdgeInsets.only(top: 20)),
      //       new Card(
      //         child: new Column(
      //           children: <Widget>[
      //             new Text("Rama", style: new TextStyle( fontSize: 20.0)),
      //             new TextField(controller: myCon,readOnly: true,textAlign: TextAlign.center , )
      //           ],
      //         ),
      //       ),
      //       new Card(
      //         child: new Column(
      //           children: <Widget>[
      //             new Text("Nama", style: new TextStyle( fontSize: 20.0)),
      //             new Text("No Hp", style: new TextStyle(fontSize: 20.0))
      //           ],
      //         ),
      //       ),
      //       new Card(
      //         child: new Column(
      //           children: <Widget>[
      //             new Text("Nama", style: new TextStyle( fontSize: 20.0)),
      //             new Text("No Hp", style: new TextStyle(fontSize: 20.0))
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      //       Padding(
      //         padding: const EdgeInsets.only(top : 10.0),
      //         child: Align(
      //           alignment: Alignment.topRight,
      //           child :  FlatButton(
      //                 child: Icon(Icons.play_arrow),
      //                 onPressed: _hasSpeech ? null : initSpeechState,
      //               ),
                
      //         ),
      //         ),
      //       Padding(
      //         padding: const EdgeInsets.only(top: 40.0),
      //         child: Align(
      //           alignment: Alignment.topRight,
      //           child :  FlatButton(
      //                 child: Icon(Icons.mic) ,
      //                 onPressed: !_hasSpeech || speech.isListening
      //                     ? null
      //                     : startListening,
                      
      //               ),
                
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(top: 70.0),
      //         child: Align(
      //           alignment: Alignment.topRight,
      //           child :  FlatButton(
      //                 child: Icon(Icons.add) ,
      //                 onPressed: () {
      //                   Navigator.pushNamed(context, '/Tambahdata');
      //                   }
      //               ),
                
      //         ),
      //       ),
      //   ],
      // )
    );
  }

  
}
class ItemList extends StatelessWidget {
    final List list;
    ItemList({this.list});
    @override
    Widget build(BuildContext context) {
      return new ListView.builder(
        itemCount: list ==  null ? 0 : list.length,
        itemBuilder: (context, i)
        {
          return new Text(list[i]['no_hp']);
        },
      );
    }
  }
