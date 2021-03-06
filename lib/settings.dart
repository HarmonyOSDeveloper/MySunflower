import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysunflower/user_config/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'server_ip_management/server_ip_manager.dart';

var _sw01 = false;
bool? _value = false;
double _value2 = 0;
var val;
var errmsg = "";
var addr = TextEditingController();
var token = TextEditingController();
SharedPreferences? prefs;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late Future ipFuture;

  @override
  void initState() {
    super.initState();
    ipFuture = getIp();
  }

  Future<void> getIp() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it doesn't exist, return 0.
    addr.text = prefs?.getString("ip") ?? "";
    token.text = prefs?.getString("token") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ipFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
                leading: BackButton(color: Colors.black),
                title: Text("Settings", style: TextStyle(color: Colors.black))),
            body: Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          children: <Widget>[
                            Column(
                              children: [
                                TextField(
                                  controller: addr,
                                  // textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 14.0),
                                    hintText: "???????????????",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          children: <Widget>[
                            Column(
                              children: [
                                TextField(
                                  controller: token,
                                  // textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 14.0),
                                    hintText: "Token",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Checkbox(
                    //   value: _value,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _value = value;
                    //     });
                    //   },
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(4)),
                    //   fillColor:
                    //       MaterialStateProperty.all(Color.fromARGB(255, 10, 89, 247)),
                    //   side: MaterialStateBorderSide.resolveWith(
                    //     (states) => BorderSide(
                    //         width: 1.5, color: Color.fromRGBO(0, 0, 0, 40)),
                    //   ),
                    // ),
                    // SliderTheme(
                    //   data: SliderTheme.of(context).copyWith(
                    //     activeTrackColor: Colors.blue,
                    //     inactiveTrackColor: Colors.grey,
                    //     trackShape: RoundedRectSliderTrackShape(),
                    //     trackHeight: 30.0,
                    //     thumbColor: Colors.white,
                    //     thumbShape: RoundSliderThumbShape(
                    //       enabledThumbRadius: 12.0,
                    //     ),
                    //     overlayColor: Colors.white.withAlpha(32),
                    //     overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    //   ),
                    //   child: Slider(
                    //     value: _value2,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _value2 = value;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // ListTile(
                    //   title: Text("Male"),
                    //   leading: Radio(
                    //     value: 1,
                    //     groupValue: val,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         val = value;
                    //       });
                    //     },
                    //     activeColor: Colors.green,
                    //   ),
                    // ),
                    // ListTile(
                    //   title: Text("Female"),
                    //   leading: Radio(
                    //     value: 2,
                    //     groupValue: val,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         val = value;
                    //       });
                    //     },
                    //     activeColor: Colors.green,
                    //   ),
                    // ),
                    Text(
                      errmsg,
                      style: TextStyle(color: Colors.red),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyButton(
                        onPressed: () async {
                          if (addr.text != "" && token.text != "") {
                            bool right = false;
                            var resp;
                            try {
                              resp = await http.get(Uri.parse(
                                  "http://${addr.text}/api/islegitsunflowercompatableserver"));
                              right = true;
                            } catch (exception) {
                              print(exception);
                            }
                            if (right) {
                              if (resp.statusCode == 200) {
                                bool valid = false;
                                String data = "";
                                try {
                                  data = jsonDecode(resp.body)["value"];
                                  valid = true;
                                } catch (identifier) {
                                  Fluttertoast.showToast(
                                      backgroundColor:
                                          Color.fromARGB(255, 86, 84, 85),
                                      msg: "????????????????????????????????????????????????????????????????????????????????? IP/??????",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      fontSize: 16.0);
                                }
                                if (valid) {
                                  if (data == "1") {
                                    if (data == "1") {
                                      http.get(
                                          Uri.parse(
                                              "http://${addr.text}/api/remcode"),
                                          headers: {
                                            'code': token.text
                                          }).then((resp2) async {
                                        var data2 =
                                            jsonDecode(resp2.body)["value"];
                                        if (data2 == "1") {
                                          await prefs?.setString(
                                              "ip", addr.text);
                                          await prefs?.setString(
                                              "token", token.text);
                                          print(token.text);
                                          Fluttertoast.showToast(
                                              backgroundColor: Color.fromARGB(
                                                  255, 86, 84, 85),
                                              msg: "???????????????",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              fontSize: 16.0);
                                        } else {
                                          Fluttertoast.showToast(
                                              backgroundColor: Color.fromARGB(
                                                  255, 86, 84, 85),
                                              msg: "??????????????????Token?????????",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              fontSize: 16.0);
                                        }
                                      });
                                    } else if (data == "0") {
                                      Fluttertoast.showToast(
                                          backgroundColor:
                                              Color.fromARGB(255, 86, 84, 85),
                                          msg: "???????????????????????????????????????????????????????????????",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          fontSize: 16.0);
                                    } else {
                                      Fluttertoast.showToast(
                                          backgroundColor:
                                              Color.fromARGB(255, 86, 84, 85),
                                          msg: "??????????????????????????? MySunflower",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          fontSize: 16.0);
                                    }
                                  }
                                }
                              } else {
                                Fluttertoast.showToast(
                                    backgroundColor:
                                        Color.fromARGB(255, 86, 84, 85),
                                    msg: "??????????????????????????? MySunflower",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 16.0);
                              }
                            }
                          }
                        },
                        child: Text("??????"),
                        width: double.infinity,
                        height: 45,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                    //   child: Row(
                    //     children: [
                    //       CircularProgressIndicator(),
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text("Connecting to server.....")
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
