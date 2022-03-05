import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class History extends StatefulWidget {
  final api;
  final user;
  const History({Key? key, required this.api, required this.user})
      : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  List<Map> _listb = [];
  void initState() {
    super.initState();
    //print("Hello!");
    var data = [];
    Uri uri = Uri.parse('http://127.0.0.1:8888/api/ott');
    var api = widget.api;
    var user = widget.user;
    http.get(uri, headers: {
      'authorization': 'Bearer $api',
      'user': '$user'
    }).then((response) {
      var authkey = jsonDecode(response.body)["value"];
      Uri uri2 = Uri.parse('http://127.0.0.1:8888/api/history');
      http.get(uri2, headers: {
        'authorization': 'Bearer $authkey',
        'user': '$user'
      }).then((response2) {
        //print("$authkey");
        //print(response2.body);
        data = jsonDecode(response2.body);
        for (var d in data) {
          _listb.add(d);
          //print(d);
        }
        setState(() {});
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "History",
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
          automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(17, 2, 8, 8),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 40, maxWidth: 240),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 12.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Search',
                    ),
                  ),
                ),
                SizedBox(width: 7),
                ElevatedButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, '/home');
                  },
                  child: Text("Search"),
                  style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(70, 45) // put the width and height you want
                      ),
                ),
              ],
              //TODO:Add The List view and/or the dialog, do it later.
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Column(children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  "Date",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Pocket Money",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Adult",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Child",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                            Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Reason",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                          ],
                        ),
                        Divider(),
                      ]),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _listb.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                                child: Row(
                                  children: [
                                    Expanded(
                                flex: 2,
                                child: Text(
                                  _listb[index]["date"],
                                  style: TextStyle(),
                                )),
                            Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      _listb[index]["action"]+
                                      _listb[index]["money"],
                                      style: TextStyle(
                                          ),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      _listb[index]["from"],
                                      style: TextStyle(
                                          ),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      _listb[index]["to"],
                                      style: TextStyle(
                                          ),
                                    ))),
                            Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      _listb[index]["reason"],
                                      style: TextStyle(
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                                  ],
                                ),
                              ),
                              Divider()
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}