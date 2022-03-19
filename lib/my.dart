import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mysunflower/dialog.dart';
import 'package:mysunflower/user_config/my_button.dart';
import 'package:http/http.dart' as http;

var role = "Unknown";
var version = "Sunflower v0.0.0";
var remainder = 0;

class MyScreen extends StatefulWidget {
  final user;
  final api;
  const MyScreen({Key? key, required this.user, required this.api})
      : super(key: key);

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  void initState() {
    super.initState();
    //print("Hello!");
    Uri uri = Uri.parse('http://192.168.0.29:8888/api/ott');
    var api = widget.api;
    var user = widget.user;
    Uri uri3 = Uri.parse('http://192.168.0.29:8888/api/info');
    http.get(uri3).then((response3) {
      var data3 = jsonDecode(response3.body);
      print(data3);
      version = data3["productname"] + " " + data3["ver"];
      setState(() {});
    });
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
    http.get(uri, headers: {
      'authorization': 'Bearer $api',
      'user': '$user'
    }).then((response) {
      var authkey = jsonDecode(response.body)["value"];
      Uri uri2 = Uri.parse('http://192.168.0.29:8888/api/left');
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
      backgroundColor: Color.fromARGB(255, 237, 242, 245),
      body: Column(children: [
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(color: Color.fromARGB(255, 237, 242, 245)),
          child: Center(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Stack(
                    children: [
                      Icon(
                        Icons.account_circle_rounded,
                        size: 70,
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Chip(
                              backgroundColor:
                                  Color.fromARGB(255, 212, 230, 241),
                              label: Container(
                                  width: 40,
                                  height: 16,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      role,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )))),
                    ],
                  ),
                  Text(
                    widget.user.toString(),
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        child: Column(
                          children: [Text("HKD\$$remainder"), Text("Amount")],
                        ),
                      ),
                      Container(
                          height: 25,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: VerticalDivider(color: Colors.black),
                          )),
                      Container(
                        width: 120,
                        child: Column(
                          children: [Text(version), Text("System")],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),

        /// TODO:
        Expanded(
          child: Container(
            //height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(9.0),
              children: <Widget>[
                MyButton(
                  height: 55,
                  borderRadius: 10,
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Settings",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            Spacer(),
                            //Text("9.9.9999(C6PR203)"),
                            IconButton(
                                iconSize: 15.0,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                MyButton(
                  height: 55,
                  borderRadius: 10,
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    Navigator.pushNamed(context, '/about');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("About",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            Spacer(),
                            //Text("9.9.9999(C6PR203)"),
                            IconButton(
                                iconSize: 15.0,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                MyButton(
                  height: 55,
                  borderRadius: 10,
                  backgroundColor: Colors.transparent,
                  onPressed: () async {
                    bool didAuthenticate = false;
                    var localAuth = LocalAuthentication();
                    try {
                      didAuthenticate = await localAuth.authenticate(
                          androidAuthStrings: AndroidAuthMessages(
                            signInTitle: "Show My One Time Auth Code",
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
                              signInTitle: "Show My One Time Auth Code",
                            ),
                            localizedReason:
                                'Authenticate to proceed(Phone Password)');
                      } catch (PlatformException) {
                        Fluttertoast.showToast(
                            backgroundColor: Color.fromARGB(255, 86, 84, 85),
                            msg:
                                "Error: You either don't have a PIN/Password Setup or did not allow the transaction, your action is canceled",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            fontSize: 16.0);
                        didAuthenticate = false;
                      }
                    }
                    if (didAuthenticate) {
                      Uri uri = Uri.parse('http://192.168.0.29:8888/api/ott');
                      var response = await http.get(uri, headers: {
                        'authorization': 'Bearer ${widget.api}',
                        'user': '${widget.user}'
                      });
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            HapticFeedback.heavyImpact();
                            return Dialog3(
                                string: jsonDecode(response.body)["value"]);
                          });
                    } else {
                      Fluttertoast.showToast(
                          backgroundColor: Color.fromARGB(255, 86, 84, 85),
                          msg:
                              "Error: You either don't have a PIN/Password Setup or did not allow the transaction, your action is canceled",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          fontSize: 16.0);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("My One-Time QR(Used For Trasnaction)",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            Spacer(),
                            //Text("9.9.9999(C6PR203)"),
                            IconButton(
                                iconSize: 15.0,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MyButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Color.fromARGB(255, 232, 64, 38)),
                    ),
                    backgroundColor: Color.fromARGB(10, 0, 0, 0))
              ],
            ),
          ),
        )
      ]),
    );
  }
}
