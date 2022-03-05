import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysunflower/screen_management/screen_manager.dart';
import 'package:provider/provider.dart';

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
  var ischild = false;
  //TODO:Check if child and display.
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              "Home",
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
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
                        "Welcome to Sunflower Pocket Money Management System!"),
                    SizedBox(height: 14),
                    Text(
                      "Money Transactions",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => screenManager.changeScreen(1),
                          child: Text("Add"),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  180, 39) // put the width and height you want
                              ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => screenManager.changeScreen(1),
                          child: Text("Remove"),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  180, 39) // put the width and height you want
                              ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "History&Account Operations",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => screenManager.changeScreen(2),
                          child: Text("View History"),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  180, 39) // put the width and height you want
                              ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            var logout = widget.api;
                            var user = widget.user;
                            http.get(
                                Uri.parse(
                                    'http://127.0.0.1:8888/api/logoutapp'),
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
                            "Logout",
                            style: TextStyle(
                                color: Color.fromARGB(255, 232, 64, 38)),
                          ),
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(Size(180, 39)),
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(10, 0, 0, 0)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Current Balance",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "HKD\$199",
                      style: TextStyle(fontSize: 15),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      child: Text("App Settings"),
                      style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(180, 39) // put the width and height you want
                          ),
                    ),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              backgroundColor:
                                  Colors.transparent, //this right here
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 15.0,
                                    sigmaY: 15.0,
                                  ),
                                  child: Container(
                                    height: 130,
                                    decoration: new BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255)
                                          .withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Logout",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                                fontFamily: "HarmonyOS_Sans"),
                                          ),
                                          Text(
                                              "Are you sure you want to logout?"),
                                          SizedBox(
                                            height: 26,
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    232,
                                                                    64,
                                                                    38)),
                                                      ),
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)))),
                                                      )),
                                                ),
                                                VerticalDivider(
                                                  thickness: 1,
                                                  width: 15,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.2),
                                                ),
                                                Expanded(
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Done",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    10,
                                                                    89,
                                                                    247)),
                                                      ),
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)))),
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      child: Text("Dialog"),
                      style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(180, 39) // put the width and height you want
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
