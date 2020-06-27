import 'dart:async';
import 'dart:convert';

import 'package:blind/Calltemen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
//Import Page
import 'package:blind/Homepage.dart';
//Semacam Session
import 'package:shared_preferences/shared_preferences.dart';
  void main() {
    runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "BlindCO",
    home: new Login(),
    routes: <String, WidgetBuilder>{
      '/Register': (BuildContext content) => new Register(),
      '/Login': (BuildContext content) => new Login(),
      '/Home': (BuildContext content) => new Homepage(),
      '/Calltemen' : (BuildContext content) => new CallTemen(),
      '/Tambahdata' : (BuildContext content) => new Tambahdata(),
    },
  ));
}
//simpan shared preferences
  void savePref(int value) async{

  SharedPreferences preferences = await SharedPreferences.getInstance();


    preferences.setInt("id_user", value);

    preferences.commit();

  }
  var iduser;

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    iduser = preferences.getInt("id_user");
    // print("ini main $value");
  }

//Register
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _jk = "";
  String _date = "";
  TextEditingController controllerNama = new TextEditingController();
  TextEditingController controllerUmur = new TextEditingController();
  TextEditingController controllerKelamin = new TextEditingController();
  TextEditingController controllerTempat = new TextEditingController();
  TextEditingController controllerTanggal = new TextEditingController();
  TextEditingController controllerAlamat = new TextEditingController();
  TextEditingController controllerHp = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerUser = new TextEditingController();
  TextEditingController controllerPass = new TextEditingController();

  void _pilihjk(String value) {
    setState(() {
      _jk = value;
    });
  }

  void _kirimdata() {
    var url = "http://blindco.pkyuk.com/pkbackend/public/api/user/store";
    http.post(url,
        headers: {
          'Accept' : 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "nama": controllerNama.text,
          "umur": controllerUmur.text,
          "kelamin": _jk,
          "tempat": controllerTempat.text,
          "tanggal_lahir": _date,
          "alamat": controllerAlamat.text,
          "no_hp": controllerHp.text,
          "email": controllerEmail.text,
          "username": controllerUser.text,
          "password": controllerPass.text,
        }).then((response)
          {
            print('Response Status : ${response.statusCode}');
            print('Response Body : ${response.body}');
          }
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: <Widget>[
          new Padding(padding: EdgeInsets.only(top: 40.0)),
          new Center(
            child: new Container(
              child: new Text(
                "Blind.Co",
                style: new TextStyle(fontFamily: "Serif", fontSize: 40.0),
              ),
            ),
          ),
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: controllerNama,
                  decoration: new InputDecoration(
                      hintText: "Nama",
                      labelText: "Nama",
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                new TextField(
                  controller: controllerUmur,
                  decoration: new InputDecoration(
                      hintText: "Umur",
                      labelText: "Umur",
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Radio(
                        value: "Laki-laki",
                        groupValue: _jk,
                        onChanged: (String value) {
                          _pilihjk(value);
                        }),
                    new Text(
                      "Laki-laki",
                      style: new TextStyle(fontSize: 20.0),
                    ),
                    new Radio(
                        value: "Perempuan",
                        groupValue: _jk,
                        onChanged: (String value) {
                          _pilihjk(value);
                        }),
                    new Text(
                      "Perempuan",
                      style: new TextStyle(fontSize: 20.0),
                    )
                  ],
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                new TextField(
                  controller: controllerTempat,
                  decoration: new InputDecoration(
                      hintText: "Tempat lahir",
                      labelText: "Tempat Lahir",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4.0,
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime(2050, 12, 31), onConfirm: (date) {
                      _date = '${date.year} - ${date.month} - ${date.day}';
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    size: 18.0,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    " $_date",
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          "  Change",
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                ),
                SizedBox(
                  height: 20.0,
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                new TextField(
                  controller: controllerAlamat,
                  maxLines: 2,
                  decoration: new InputDecoration(
                      hintText: "Alamat",
                      labelText: "Alamat",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                new TextField(
                  controller: controllerHp,
                  decoration: new InputDecoration(
                      hintText: "No Handphone",
                      labelText: "No Handphone",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                new TextField(
                  controller: controllerEmail,
                  decoration: new InputDecoration(
                      hintText: "Email",
                      labelText: "Email",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                new TextField(
                  controller: controllerUser,
                  decoration: new InputDecoration(
                      hintText: "Username",
                      labelText: "Username",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                new TextField(
                  controller: controllerPass,
                  obscureText: true,
                  decoration: new InputDecoration(
                      hintText: "Password",
                      labelText: "Password",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
                new RaisedButton(
                    onPressed: () {
                      _kirimdata();
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child:
                        new Text("Save", style: TextStyle(color: Colors.white)),
                    color: Colors.lightBlueAccent)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Login
class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  String msg = '';
  //function login
  Future<void> _login() async {
    final response = await http.post(
        "http://blindco.pkyuk.com/pkbackend/public/api/user/login",
        body: {
          "email": user.text,
          "password": pass.text,
        });

    var datauser = json.decode(response.body);
    if (datauser['value'] == 'Password salah') {
      setState(() {
        msg = 'Password salah';
      });
    } else if (datauser['value'] == 'Password atau Email, Salah!') {
      setState(() {
        msg = 'Password atau Email, Salah!';
      });
    }else {
      
      savePref(datauser['value']['id_user']);

      Navigator.pushNamed(context, '/Home');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: () {
          _login();
        },
        padding: new EdgeInsets.all(20.0),
        color: Colors.lightBlueAccent,
        child: Text('Log In ', style: TextStyle(color: Colors.white)),
      ),
    );
    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/Register');
        },
        padding: new EdgeInsets.all(20.0),
        color: Colors.lightBlueAccent,
        child: Text('Register', style: TextStyle(color: Colors.white)),
      ),
    );
    final forgotLabel = FlatButton(
      child: Text(
        'Lupa Password?',
        style: TextStyle(color: Colors.lightBlueAccent),
      ),
      onPressed: () {},
    );
    return new Scaffold(
      body: new ListView(
        children: <Widget>[
          new Padding(padding: EdgeInsets.only(top: 40.0)),
          new Center(
            child: new Container(
              child: new Text(
                "Blind.Co",
                style: new TextStyle(fontFamily: "Serif", fontSize: 40.0),
              ),
            ),
          ),
          new Container(
            padding: new EdgeInsets.all(20.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: user,
                  decoration: new InputDecoration(
                      hintText: "Please input your username here",
                      labelText: "Username",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                new TextField(
                  controller: pass,
                  obscureText: true,
                  decoration: new InputDecoration(
                      hintText: "Please input your password here",
                      labelText: "Password",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
                new Row(
                  children: <Widget>[
                    loginButton,
                    registerButton,
                  ],
                ),
                forgotLabel,
                Text(
                  msg,
                  style: TextStyle(fontSize: 20.0, color: Colors.red),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class Tambahdata extends StatefulWidget {
  @override
  _TambahdataState createState() => _TambahdataState();
}

class _TambahdataState extends State<Tambahdata> {
  TextEditingController controllerNama = new TextEditingController();
  TextEditingController controllerHp = new TextEditingController();

  void _kirimdata() {
    var url = "http://blindco.pkyuk.com/pkbackend/public/api/anggota/store";
    http.post(url,
        headers: {
          'Accept' : 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          "id_user": iduser.toString(),
          "nama": controllerNama.text,
          "no_hp": controllerHp.text,
        }).then((response)
          {
            print('Response Status : ${response.statusCode}');
            print('Response Body : ${response.body}');
          }
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: <Widget>[
          new Padding(padding: EdgeInsets.only(top: 20.0)),
          new Center(
            child: new Container(
              child: new Text(
                "Tambah Telepon",
                style: new TextStyle(fontFamily: "Serif", fontSize: 40.0),
              ),
            ),
          ),
          new Container(
            padding: EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: controllerNama,
                  decoration: new InputDecoration(
                      hintText: "Nama",
                      labelText: "Nama",
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                new TextField(
                  controller: controllerHp,
                  decoration: new InputDecoration(
                      hintText: "No Handphone",
                      labelText: "No Handphone",
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0))),
                ),
                new RaisedButton(
                    onPressed: () {
                      _kirimdata();
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child:
                        new Text("Save", style: TextStyle(color: Colors.white)),
                    color: Colors.lightBlueAccent)
              ],
            ),
          ),
        ],
      ),
    );
  }
}