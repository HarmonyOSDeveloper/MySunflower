// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:mysunflower/user_config/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'server_ip_management/server_ip_manager.dart';

//import 'package:qr_code_scanner/qr_code_scanner.dart';
var remainder = 0;
var role;
var camcode;
bool grant = false;

class MoneyMgr extends StatefulWidget {
  final api;
  final user;
  const MoneyMgr({Key? key, required this.api, required this.user})
      : super(key: key);

  @override
  _MoneyMgrState createState() => _MoneyMgrState();
}

class _MoneyMgrState extends State<MoneyMgr> {
  var amount = TextEditingController();
  var childuname = TextEditingController();
  var reason = TextEditingController();
  late String serverIp;

  @override
  void initState() {
    super.initState();
    serverIp = ServerIpManager.instance.ip;
    Uri uri = Uri.parse('http://$serverIp/api/ott');
    var api = widget.api;
    var user = widget.user;
    http.get(uri, headers: {
      'authorization': 'Bearer $api',
      'user': '$user'
    }).then((response) {
      var authkey = jsonDecode(response.body)["value"];
      Uri uri2 = Uri.parse('http://$serverIp/api/isadult');
      http.get(uri2, headers: {
        'authorization': 'Bearer $authkey',
        'user': '$user'
      }).then((response2) {
        // print(response2.body);
        // start from printing response2.body first
        var data = jsonDecode(response2.body)["value"] as bool;
        setState(() {
          //print(data);

          if (data) {
            role = "Adult";
          } else {
            role = "Child";
          }
        });
      });
    });
    http.get(uri, headers: {
      'authorization': 'Bearer $api',
      'user': '$user'
    }).then((response) {
      var authkey = jsonDecode(response.body)["value"];
      Uri uri2 = Uri.parse('http://$serverIp/api/left');
      http.get(uri2, headers: {
        'authorization': 'Bearer $authkey',
        'user': '$user'
      }).then((response2) {
        // print(response2.body);
        // start from printing response2.body first
        print(response2.body);
        var data = jsonDecode(response2.body)["value"] as int;
        setState(() {
          remainder = data;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "??????/?????? ?????????",
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(17, 2, 17, 8),
          child: Column(children: [
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: 40, maxWidth: double.infinity),
              child: TextField(
                controller: amount,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: '???????????????',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: 40, maxWidth: double.infinity),
              child: TextField(
                controller: childuname,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "???????????????????????????",
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: 40, maxWidth: double.infinity,minHeight: 40),
              child: Container(
                child: TextField(
                  controller: reason,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: "??????",
                  ),
                  keyboardType: TextInputType.multiline,
                  //maxLines: null,
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 18,
                  child: MyButton(
                    onPressed: () {
                      if (role == "Adult") {
                        if (amount.text != "" &&
                            reason.text != "" &&
                            childuname.text != "") {
                          Uri uri = Uri.parse('http://$serverIp/api/ott');
                          var api = widget.api;
                          var user = widget.user;
                          http.get(uri, headers: {
                            'authorization': 'Bearer $api',
                            'user': '$user'
                          }).then((response) async {
                            //Now Check -> FingerPrint Auth!!!
                            bool didAuthenticate = false;
                            var localAuth = LocalAuthentication();
                            try {
                              didAuthenticate = await localAuth.authenticate(
                                  androidAuthStrings: AndroidAuthMessages(
                                    signInTitle: "??????",
                                  ),
                                  sensitiveTransaction: true,
                                  localizedReason: '????????????????????????/?????????',
                                  biometricOnly: true);
                            } catch (PlatformException) {
                              print("Sorry, No Biom");
                              try {
                                var localAuth = LocalAuthentication();
                                didAuthenticate = await localAuth.authenticate(
                                    sensitiveTransaction: true,
                                    androidAuthStrings: AndroidAuthMessages(
                                      signInTitle: "??????",
                                    ),
                                    localizedReason: '???????????????(PIN/Password)');
                              } catch (PlatformException) {
                                print("Sorry, No PIN Also");
                                didAuthenticate = false;
                              }
                            }
                            if (didAuthenticate) {
                              var authkey = jsonDecode(response.body)["value"];
                              Uri uri2 =
                                  Uri.parse('http://$serverIp/api/addmoney');
                              http.get(uri2, headers: {
                                'authorization': 'Bearer $authkey',
                                'user': '$user',
                                'money': amount.text,
                                'child': childuname.text,
                                'notes': reason.text.replaceAll("\n", " "),
                              }).then((response2) {
                                print(response2.body);
                                String data =
                                    jsonDecode(response2.body)["value"];
                                if (data.startsWith("ERR:")) {
                                  Fluttertoast.showToast(
                                      backgroundColor:
                                          Color.fromARGB(255, 86, 84, 85),
                                      msg:
                                          "Error: ${data.replaceAll('ERR:', '')}",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      fontSize: 16.0);
                                } else {
                                  Fluttertoast.showToast(
                                      backgroundColor:
                                          Color.fromARGB(255, 86, 84, 85),
                                      msg: "????????????",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      fontSize: 16.0);
                                  amount.text = "";
                                  childuname.text = "";
                                  reason.text = "";
                                  setState(() {});
                                }
                              });
                            } else {
                              Fluttertoast.showToast(
                                  backgroundColor:
                                      Color.fromARGB(255, 86, 84, 85),
                                  msg: "?????????????????? PIN/?????????????????????????????????",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0);
                            }
                          });
                        } else {
                          Fluttertoast.showToast(
                              backgroundColor: Color.fromARGB(255, 86, 84, 85),
                              msg: "????????????????????????",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0);
                        }
                      } else {
                        //No Perm, Force QUIT
                        Fluttertoast.showToast(
                            backgroundColor: Color.fromARGB(255, 86, 84, 85),
                            msg: "???????????????",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            fontSize: 16.0);
                      }
                    },
                    child: Text("??????"),
                  ),
                ),
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 18,
                  child: MyButton(
                    onPressed: () async {
                      if (role == "Adult") {
                        if (amount.text != "" &&
                            reason.text != "" &&
                            childuname.text != "") {
                          Uri uri = Uri.parse('http://$serverIp/api/ott');
                          var api = widget.api;
                          var user = widget.user;
                          http.get(uri, headers: {
                            'authorization': 'Bearer $api',
                            'user': '$user'
                          }).then((response) async {
                            //Now Check -> FingerPrint Auth!!!
                            bool didAuthenticate = false;
                            var localAuth = LocalAuthentication();
                            try {
                              didAuthenticate = await localAuth.authenticate(
                                  androidAuthStrings: AndroidAuthMessages(
                                    signInTitle: "??????",
                                  ),
                                  sensitiveTransaction: true,
                                  localizedReason: '????????????????????????/?????????',
                                  biometricOnly: true);
                            } catch (PlatformException) {
                              print("Sorry, No Biom");
                              try {
                                var localAuth = LocalAuthentication();
                                didAuthenticate = await localAuth.authenticate(
                                    sensitiveTransaction: true,
                                    androidAuthStrings: AndroidAuthMessages(
                                      signInTitle: "??????",
                                    ),
                                    localizedReason: '???????????????(Password/PIN)');
                              } catch (PlatformException) {
                                print("Sorry, No PIN Also");
                                didAuthenticate = false;
                              }
                            }
                            if (didAuthenticate) {
                              if (!await Permission.camera
                                  .request()
                                  .isGranted) {
                                Fluttertoast.showToast(
                                    backgroundColor:
                                        Color.fromARGB(255, 86, 84, 85),
                                    msg: "??????????????????????????????????????????????????????",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 16.0);
                              } else {
                                grant = true;
                              }
                              camcode = "";
                              Future pushNamed =
                                  Navigator.pushNamed(context, "/scan");
                              pushNamed.then((value) {
                                print("Running");
                                var authkey =
                                    jsonDecode(response.body)["value"];
                                Uri uri2 = Uri.parse(
                                    'http://$serverIp/api/removemoney');
                                if (camcode.toString() == "null") {
                                  print("IS NULL!");
                                  camcode = "";
                                }
                                http.get(uri2, headers: {
                                  'authorization': 'Bearer $authkey',
                                  'user': '$user',
                                  'money': amount.text,
                                  'child': childuname.text,
                                  'notes': reason.text.replaceAll("\n", " "),
                                  'Authorization2':
                                      "Bearer " + camcode.toString()
                                }).then((response2) {
                                  print(response2.body);
                                  String data =
                                      jsonDecode(response2.body)["value"];
                                  if (data.startsWith("ERR:")) {
                                    Fluttertoast.showToast(
                                        backgroundColor:
                                            Color.fromARGB(255, 86, 84, 85),
                                        msg:
                                            "Error: ${data.replaceAll('ERR:', '')}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        fontSize: 16.0);
                                  } else {
                                    Fluttertoast.showToast(
                                        backgroundColor:
                                            Color.fromARGB(255, 86, 84, 85),
                                        msg: "?????????.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        fontSize: 16.0);
                                    amount.text = "";
                                    childuname.text = "";
                                    reason.text = "";
                                    setState(() {});
                                  }
                                });
                              });
                            } else {
                              Fluttertoast.showToast(
                                  backgroundColor:
                                      Color.fromARGB(255, 86, 84, 85),
                                  msg: "?????????????????? PIN/?????????????????????????????????",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0);
                            }
                          });
                        } else {
                          Fluttertoast.showToast(
                              backgroundColor: Color.fromARGB(255, 86, 84, 85),
                              msg: "????????????????????????",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0);
                        }
                      } else {
                        //No Perm, Force QUIT
                        Fluttertoast.showToast(
                            backgroundColor: Color.fromARGB(255, 86, 84, 85),
                            msg: "???????????????",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            fontSize: 16.0);
                      }
                    },
                    child: Text("??????"),
                  ),
                ),
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ]),
        ));
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<QRViewExample> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("?????????"),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: MobileScanner(
          allowDuplicates: false,
          onDetect: (barcode, args) {
            HapticFeedback.heavyImpact();
            camcode = barcode.rawValue;
            Navigator.pop(context);
          }),
    );
  }
}
