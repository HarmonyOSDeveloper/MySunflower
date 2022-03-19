// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mysunflower/user_config/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  void initState() {
    super.initState();
    Uri uri = Uri.parse('http://192.168.0.29:8888/api/ott');
    var api = widget.api;
    var user = widget.user;
    http.get(uri, headers: {
      'authorization': 'Bearer $api',
      'user': '$user'
    }).then((response) {
      var authkey = jsonDecode(response.body)["value"];
      Uri uri2 = Uri.parse('http://192.168.0.29:8888/api/isadult');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Transactions",
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
                  hintText: 'Amount(\$CUR)',
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
                  hintText: "Child's Username",
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
                  hintText: "Reason(Multiline)",
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
                              Uri.parse('http://192.168.0.29:8888/api/ott');
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
                                    signInTitle: "Add Pocket Money",
                                  ),
                                  sensitiveTransaction: true,
                                  localizedReason:
                                      'Authenticate to proceed(Face/Fingerprint)',
                                  biometricOnly: true);
                            } catch (PlatformException) {
                              print("Sorry, No Biom");
                              try {
                                var localAuth = LocalAuthentication();
                                didAuthenticate = await localAuth.authenticate(
                                    sensitiveTransaction: true,
                                    androidAuthStrings: AndroidAuthMessages(
                                      signInTitle: "Add Pocket Money",
                                    ),
                                    localizedReason:
                                        'Authenticate to proceed(Phone Password)');
                              } catch (PlatformException) {
                                print("Sorry, No PIN Also");
                                didAuthenticate = false;
                              }
                            }
                            if (didAuthenticate) {
                              var authkey = jsonDecode(response.body)["value"];
                              Uri uri2 = Uri.parse(
                                  'http://192.168.0.29:8888/api/addmoney');
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
                                      msg: "Transaction Completed.",
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
                                      "Error: You either don't have a PIN/Password Setup or did not allow the transaction, the transaction failed",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0);
                            }
                          });
                        } else {
                          Fluttertoast.showToast(
                              backgroundColor: Color.fromARGB(255, 86, 84, 85),
                              msg: "Please enter all of the text fields.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0);
                        }
                      } else {
                        //No Perm, Force QUIT
                        Fluttertoast.showToast(
                            backgroundColor: Color.fromARGB(255, 86, 84, 85),
                            msg: "Permission Denied.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            fontSize: 16.0);
                      }
                    },
                    child: Text("Add"),
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
                              Uri.parse('http://192.168.0.29:8888/api/ott');
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
                                    signInTitle: "Remove Pocket Money",
                                  ),
                                  sensitiveTransaction: true,
                                  localizedReason:
                                      'Authenticate to proceed(Face/Fingerprint)',
                                  biometricOnly: true);
                            } catch (PlatformException) {
                              print("Sorry, No Biom");
                              try {
                                var localAuth = LocalAuthentication();
                                didAuthenticate = await localAuth.authenticate(
                                    sensitiveTransaction: true,
                                    androidAuthStrings: AndroidAuthMessages(
                                      signInTitle: "Remove Pocket Money",
                                    ),
                                    localizedReason:
                                        'Authenticate to proceed(Phone Password)');
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
                                        "Error: To use this feature, please give us camera permission.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    fontSize: 16.0);
                              } else {
                                grant = true;
                              }
                              Future pushnamed = Navigator.pushNamed(context, "/scan");
                              // pushnamed.then((_){
                              //   print("THEN?");
                              // });
                                // var authkey =
                                //     jsonDecode(response.body)["value"];
                                // Uri uri2 = Uri.parse(
                                //     'http://192.168.0.29:8888/api/removemoney');
                                // if (camcode.toString() == "null"){
                                //   camcode = "";
                                // }
                                // http.get(uri2, headers: {
                                //   'authorization': 'Bearer $authkey',
                                //   'user': '$user',
                                //   'money': amount.text,
                                //   'child': childuname.text,
                                //   'notes': reason.text.replaceAll("\n", " "),
                                //   'Authorization2':camcode.toString()
                                // }).then((response2) {
                                //   print(response2.body);
                                //   String data =
                                //       jsonDecode(response2.body)["value"];
                                //   if (data.startsWith("ERR:")) {
                                //     Fluttertoast.showToast(
                                //         backgroundColor:
                                //             Color.fromARGB(255, 86, 84, 85),
                                //         msg:
                                //             "Error: ${data.replaceAll('ERR:', '')}",
                                //         toastLength: Toast.LENGTH_SHORT,
                                //         gravity: ToastGravity.BOTTOM,
                                //         timeInSecForIosWeb: 1,
                                //         fontSize: 16.0);
                                //   } else {
                                //     Fluttertoast.showToast(
                                //         backgroundColor:
                                //             Color.fromARGB(255, 86, 84, 85),
                                //         msg: "Transaction Completed.",
                                //         toastLength: Toast.LENGTH_SHORT,
                                //         gravity: ToastGravity.BOTTOM,
                                //         timeInSecForIosWeb: 1,
                                //         fontSize: 16.0);
                                //     amount.text = "";
                                //     childuname.text = "";
                                //     reason.text = "";
                                //     setState(() {});
                                //   }
                                // });
                              
                            } else {
                              Fluttertoast.showToast(
                                  backgroundColor:
                                      Color.fromARGB(255, 86, 84, 85),
                                  msg:
                                      "Error: You either don't have a PIN/Password Setup or did not allow the transaction, the transaction failed",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0);
                            }
                          });
                        } else {
                          Fluttertoast.showToast(
                              backgroundColor: Color.fromARGB(255, 86, 84, 85),
                              msg: "Please enter all of the text fields.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0);
                        }
                      } else {
                        //No Perm, Force QUIT
                        Fluttertoast.showToast(
                            backgroundColor: Color.fromARGB(255, 86, 84, 85),
                            msg: "Permission Denied.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            fontSize: 16.0);
                      }
                    },
                    child: Text("Remove"),
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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 270.0
        : 350.0;
    if (grant) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Scan One Time QR Code"),
          elevation: 0,
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.blueAccent,
                  borderRadius: 0,
                  borderLength: 30,
                  borderWidth: 20,
                  cutOutSize: scanArea,
                ),
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(body: Text("Please grant us camera permission."));
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      if (result != null) {
        controller.pauseCamera();
        camcode = result!.code;
        Navigator.of(context).pop();
      }
    });
  }

  // @override
  // void dispose() {
  //   controller!.dispose();
  //   super.dispose();
  // }
}
