import 'main.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
//Semacam Session
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _currentAddress;
  Position _currentPosition;
  Widget _child;
  GoogleMapController _controller;
  
  //Variabel voice command
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();

  // String _currentLocaleId = "";
  // List<LocaleName> _localeNames = [];
  
  @override
  void initState() {
    super.initState();

    getPref();
    getCurrentLocation();
  }

  
//get long lat
  void getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      _currentPosition = res;
      _child = mapWidget();
    });
    // _getAddressFromLatLng();
    
    
    List<Placemark> p = await Geolocator().placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);

    Placemark place = p[0];

    _currentAddress =
        "${place.locality}, ${place.subLocality}, ${place.subThoroughfare}, ${place.thoroughfare}";
    // _kirimdata();
  }

  _kirimdata() {
    var url = "http://blindco.pkyuk.com/pkbackend/public/api/map/store";
    // print(url);
    http.post(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      "id_user": iduser.toString(),
      "long": _currentPosition.longitude.toString(),
      "lat": _currentPosition.latitude.toString(),
      "jalan": _currentAddress,
    }).then((response) {
      print('Response Status : ${response.statusCode}');
      print('Response Body : ${response.body}');
    });
  }

  //fungsi voice command
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
    if (lastWords == 'telepon'){
      // print('masuk kesini');
      Navigator.pushNamed(context, '/Calltemen');
    }
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('BlindCO'),
        ),
        body: new Stack(
          children: <Widget>[
            _child == null ? Container() : _child,
            Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: MediaQuery.of(context).size.width * 0.05,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],                
              ),              
              child: Text(lastWords),
            ),
            Padding(
              padding: const EdgeInsets.only(top : 55.0),
              child: Align(
                alignment: Alignment.topRight,
                child :  FlatButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: _hasSpeech ? null : initSpeechState,
                    ),
                
              ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 95.0),
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
          ],
        ));
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 15.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
      myLocationEnabled: true,
      padding: EdgeInsets.only(
        top: 60.0,
      ),
    );
  }
}
