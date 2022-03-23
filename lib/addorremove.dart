// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mysunflower/history.dart';
import 'package:mysunflower/user_config/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
var remainder = 0;
var role;
var camcode;
bool grant = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  // Try reading data from the counter key. If it doesn't exist, return 0.
  ServerIP = prefs.getString("ip") ?? "";
}
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
  void initState() {
    super.initState();
    Uri uri = Uri.parse('http://$ServerIP/api/ott');
    var api = widget.api;
    var user = widget.user;
    http.get(uri, headers: {
      'authorization': 'Bearer $api',
      'user': '$user'
    }).then((response) {
      var authkey = jsonDecode(response.body)["value"];
      Uri uri2 = Uri.parse('http://$ServerIP/api/isadult');
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
      Uri uri2 = Uri.parse('http://$ServerIP/api/left');
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
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "增值/提取 零用錢",
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
                  hintText: '請輸入金額',
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
                  hintText: "請輸入孩子的用戶名",
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: double.infinity, maxWidth: double.infinity),
              child: TextField(
                controller: reason,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "原因",
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
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
                          Uri uri =
                              Uri.parse('http://$ServerIP/api/ott');
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
                                    signInTitle: "增值",
                                  ),
                                  sensitiveTransaction: true,
                                  localizedReason:
                                      '驗證以繼續（人臉/指紋）',
                                  biometricOnly: true);
                            } catch (PlatformException) {
                              print("Sorry, No Biom");
                              try {
                                var localAuth = LocalAuthentication();
                                didAuthenticate = await localAuth.authenticate(
                                    sensitiveTransaction: true,
                                    androidAuthStrings: AndroidAuthMessages(
                                      signInTitle: "增值",
                                    ),
                                    localizedReason:
                                        '驗證以繼續(PIN/Password)');
                              } catch (PlatformException) {
                                print("Sorry, No PIN Also");
                                didAuthenticate = false;
                              }
                            }
                            if (didAuthenticate) {
                              var authkey = jsonDecode(response.body)["value"];
                              Uri uri2 = Uri.parse(
                                  'http://$ServerIP/api/addmoney');
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
                                      msg: "成功完成",
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
                                  msg:
                                      "錯誤：您沒有 PIN/密碼設置或不允許，失敗",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0);
                            }
                          });
                        } else {
                          Fluttertoast.showToast(
                              backgroundColor: Color.fromARGB(255, 86, 84, 85),
                              msg: "請輸入所有文本框",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0);
                        }
                      } else {
                        //No Perm, Force QUIT
                        Fluttertoast.showToast(
                            backgroundColor: Color.fromARGB(255, 86, 84, 85),
                            msg: "沒有權限。",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            fontSize: 16.0);
                      }
                    },
                    child: Text("增值"),
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
                          Uri uri =
                              Uri.parse('http://$ServerIP/api/ott');
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
                                    signInTitle: "提取",
                                  ),
                                  sensitiveTransaction: true,
                                  localizedReason:
                                      '驗證以繼續（人臉/指紋）',
                                  biometricOnly: true);
                            } catch (PlatformException) {
                              print("Sorry, No Biom");
                              try {
                                var localAuth = LocalAuthentication();
                                didAuthenticate = await localAuth.authenticate(
                                    sensitiveTransaction: true,
                                    androidAuthStrings: AndroidAuthMessages(
                                      signInTitle: "提取",
                                    ),
                                    localizedReason:
                                        '驗證以繼續(Password/PIN)');
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
                                    msg:
                                        "錯誤：要使用此功能，請給我們相機權限",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 16.0);
                              } else {
                                grant = true;
                              }
                              camcode = "";
                              Future pushNamed = Navigator.pushNamed(context, "/scan");
                              pushNamed.then((value) {
                                print("Running");
                                var authkey =
                                    jsonDecode(response.body)["value"];
                                Uri uri2 = Uri.parse(
                                    'http://$ServerIP/api/removemoney');
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
                                  'Authorization2': "Bearer " + camcode.toString()
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
                                        msg: "已完成.",
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
                                  msg:
                                      "錯誤：您沒有 PIN/密碼設置或不允許，失敗",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0);
                            }
                          });
                        } else {
                          Fluttertoast.showToast(
                              backgroundColor: Color.fromARGB(255, 86, 84, 85),
                              msg: "請輸入所有文本框",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0);
                        }
                      } else {
                        //No Perm, Force QUIT
                        Fluttertoast.showToast(
                            backgroundColor: Color.fromARGB(255, 86, 84, 85),
                            msg: "沒有權限。",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            fontSize: 16.0);
                      }
                    },
                    child: Text("提取"),
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
        title: Text("掃一掃"),
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
