import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mysunflower/addorremove.dart';
import 'package:mysunflower/bouncing.dart';
import 'package:mysunflower/dialog.dart';
import 'package:mysunflower/screen_management/screen_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_config/my_button.dart';
var ServerIP;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  // Try reading data from the counter key. If it doesn't exist, return 0.
  ServerIP = prefs.getString("ip") ?? "";
}
class HomePage extends StatefulWidget {
  final api;
  final user;
  const HomePage({
    Key? key,
    required this.api,
    required this.user,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState(){
    super.initState();
    main();
  }
  var ischild = false;
  //TODO:Check if child and display.
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide > 550;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButton: Bouncing(
          child: Icon(Icons.add),
          onPress: () {},
        ),
        appBar: AppBar(
            title: Text(
              "主頁",
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () async {
                    await _showMenu(context);
                  },
                  icon: Icon(Icons.more_vert_rounded))
            ],
            automaticallyImplyLeading: false),
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(17, 2, 8, 8),
              child: Consumer<ScreenManager>(
                builder: (context, screenManager, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "歡迎來到零用錢系統！"),
                    SizedBox(height: 14),
                    Text(
                      "增值/提取 零用錢",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ///  4 + 1 + 4 + 1 = 10
                        Expanded(
                          flex: 5,
                          child: MyButton(
                            onPressed: () => screenManager.changeScreen(1),
                            child: Text("增值"),
                          ),
                        ),
                        Expanded(child: SizedBox(), flex: 1),
                        Expanded(
                          flex: 5,
                          child: MyButton(
                            onPressed: () => screenManager.changeScreen(1),
                            child: Text("提取"),
                          ),
                        ),
                        Expanded(child: SizedBox(), flex: 1),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "記錄/登出",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: MyButton(
                            onPressed: () => screenManager.changeScreen(2),
                            child: Text("記錄"),
                          ),
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                          flex: 5,
                          child: MyButton(
                              onPressed: () {
                                var logout = widget.api;
                                var user = widget.user;
                                http.get(
                                    Uri.parse(
                                        'http://$ServerIP/api/logoutapp'),
                                    headers: {
                                      'authorization': 'Bearer $logout',
                                      'user': '$user'
                                    }).then((response) {
                                  //print(user);
                                  if (jsonDecode(response.body)["value"] ==
                                      "Completed") {
                                    Navigator.of(context).pop();
                                  }
                                });
                              },
                              child: Text(
                                "登出",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 232, 64, 38)),
                              ),
                              backgroundColor: Color.fromARGB(10, 0, 0, 0)),
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "餘額",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "HKD\$$remainder",
                      style: TextStyle(fontSize: 15),
                    ),
                    // MyButton(
                    //   onPressed: () {
                    //     Navigator.pushNamed(context, '/settings');
                    //   },
                    //   child: Text("App Settings"),
                    // ),
                    SizedBox(height: 5),
                    // MyButton(
                    //   onPressed: () => showPopup(isTablet, context),
                    //   // onPressed: () async {
                    //   //   bool didAuthenticate = false;
                    //   //   var localAuth = LocalAuthentication();
                    //   //   try {
                    //   //     didAuthenticate = await localAuth.authenticate(
                    //   //       androidAuthStrings: AndroidAuthMessages(signInTitle: "Add Pocket Money",),
                    //   //       sensitiveTransaction: true,
                    //   //         localizedReason:
                    //   //             'Authenticate to proceed(Face/Fingerprint)',
                                  
                    //   //         biometricOnly: true);
                    //   //   } catch (PlatformException) {
                    //   //     print("Sorry, No Biom");
                    //   //     try {
                    //   //       var localAuth = LocalAuthentication();
                    //   //       didAuthenticate =
                    //   //           await localAuth.authenticate(
                    //   //             sensitiveTransaction: true,
                    //   //             androidAuthStrings: AndroidAuthMessages(signInTitle: "Add Pocket Money",),
                    //   //               localizedReason: 'Authenticate to proceed(Phone Password)');
                    //   //     }
                    //   //     catch (PlatformException) {
                    //   //       print("Sorry, No PIN Also");
                    //   //       didAuthenticate = false;
                    //   //     }
                    //   //   }
                    //   //   print(didAuthenticate);
                    //   // },
                    //   child: Text("Dialog"),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showMenu(BuildContext context) async {
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(300, 10, 0, 10),
        items: [
          PopupMenuItem(
            height: 0,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            enabled: false,
            child: TextButton(
              child: Text("孩子"),
              onPressed: () {},
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 50)),
              ),
            ),
          ),
          PopupMenuItem(
            height: 0,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            enabled: false,
            child: TextButton(
              child: Text("孩子"),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 50)),
              ),
            ),
          ),
        ]);
  }
}
