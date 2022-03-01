import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final api;
  final user;
  const HomePage({
    Key? key,
    required this.api,
    required this.user
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  var ischild = false;
  //TODO:Check if child and display.
  Widget build(BuildContext context) {
    return new WillPopScope(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome to Sunflower Pocket Money Management System!"),
                  SizedBox(height: 14),
                  Text(
                    "Money Transactions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          //Navigator.pushNamed(context, '/home');
                        },
                        child: Text("Add"),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                180, 39) // put the width and height you want
                            ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
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
                          http.get(Uri.parse('http://127.0.0.1:8888/api/logoutapp'),
                              headers: {
                                'authorization': 'Bearer $logout',
                                'user': '$user'
                              }).then((response) {
                                if (jsonDecode(response.body)["value"] == "Completed"){
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
                          minimumSize: MaterialStateProperty.all(Size(180, 39)),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(10, 0, 0, 0)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Current Balance",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
