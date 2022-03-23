import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mysunflower/user_config/my_button.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime start = DateTime.now();
DateTime end = DateTime.now();
var dtc = TextEditingController();
var ServerIP;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  // Try reading data from the counter key. If it doesn't exist, return 0.
  ServerIP = prefs.getString("ip") ?? "";
}
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
    Uri uri = Uri.parse('http://$ServerIP/api/ott');
    var api = widget.api;
    var user = widget.user;
    main();
    http.get(uri, headers: {
      'authorization': 'Bearer $api',
      'user': '$user'
    }).then((response) {
      var authkey = jsonDecode(response.body)["value"];
      Uri uri2 = Uri.parse('http://$ServerIP/api/history');
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
            "記錄",
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
          automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(17, 2, 8, 8),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: TextField(
                    controller: dtc,
                    readOnly: true,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: '搜索',
                        prefixIcon: IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 15.0,
                                          sigmaY: 15.0,
                                        ),
                                        child: Container(
                                          height: 500,
                                          width: 550,
                                          decoration: new BoxDecoration(
                                            color: Color.fromARGB(
                                                    255, 255, 255, 255)
                                                .withOpacity(1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  "搜索",
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Center(
                                                  child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(15, 0, 0, 0),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          "開始日期：",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )),
                                                  ),
                                                  DatePickerWidget(
                                                    initialDate: DateTime.now(),
                                                    onChange: (dateTime,
                                                            selectedIndex) =>
                                                        {start = dateTime},
                                                  ),
                                                ],
                                              )),
                                              Spacer(),
                                              Center(
                                                  child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(15, 0, 0, 0),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          "結束日期：",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )),
                                                  ),
                                                  DatePickerWidget(
                                                    initialDate: DateTime.now(),
                                                    onChange: (dateTime,
                                                            selectedIndex) =>
                                                        {end = dateTime},
                                                  ),
                                                ],
                                              )),
                                              SizedBox(height: 5,),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Expanded(
                                                  child: Container(
                                                      width: 250,
                                                      height: 40,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: MyButton(
                                                              backgroundColor: Colors.transparent,
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                dtc.text = "";
                                                                start = DateTime.now();
                                                                end = DateTime.now();
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                "清除過濾器",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            232,
                                                                            64,
                                                                            38)),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 25,
                                                            child:
                                                                VerticalDivider(
                                                              thickness: 1,
                                                              width: 15,
                                                              color:
                                                                  Color.fromRGBO(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0.2),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: MyButton(
                                                              borderRadius: 30,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              onPressed: () {
                                                                if (start.isBefore(
                                                                    end)) {
                                                                  dtc.text = DateFormat(
                                                                              "y-M-d")
                                                                          .format(
                                                                              start) +
                                                                      " - " +
                                                                      DateFormat(
                                                                              "y-M-d")
                                                                          .format(
                                                                              end);
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(() {});
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                      backgroundColor:
                                                                          Color.fromARGB(
                                                                              255,
                                                                              86,
                                                                              84,
                                                                              85),
                                                                      msg:
                                                                          "錯誤：開始日期大於結束日期。",
                                                                      toastLength: Toast
                                                                          .LENGTH_SHORT,
                                                                      gravity:
                                                                          ToastGravity
                                                                              .BOTTOM,
                                                                      timeInSecForIosWeb:
                                                                          1,
                                                                      fontSize:
                                                                          16.0);
                                                                }
                                                              },
                                                              child: Text(
                                                                "OK",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            10,
                                                                            89,
                                                                            247)),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                        )),
                  ),
                ),
                SizedBox(width: 7),
                Expanded(
                  flex: 2,
                  child: MyButton(
                    width: 80,
                    onPressed: () {
                      print(dtc.text);
                      if (dtc.text != "") {
                        //print("Hello!");
                        var data = [];
                        Uri uri = Uri.parse('http://$ServerIP/api/ott');
                        var api = widget.api;
                        var user = widget.user;
                        http.get(uri, headers: {
                          'authorization': 'Bearer $api',
                          'user': '$user'
                        }).then((response) {
                          var authkey = jsonDecode(response.body)["value"];
                          Uri uri2 =
                              Uri.parse('http://$ServerIP/api/history');
                          http.get(uri2, headers: {
                            'authorization': 'Bearer $authkey',
                            'user': '$user',
                            'start': dtc.text.split(" - ")[0],
                            'end': dtc.text.split(" - ")[1]
                          }).then((response2) {
                            //print("$authkey");
                            //print(response2.body);
                            data = jsonDecode(response2.body);
                            _listb = [];
                            for (var d in data) {
                              _listb.add(d);
                              //print(d);
                            }
                            setState(() {});
                          });
                        });
                      } else {
                        //print("Hello!");
                        var data = [];
                        Uri uri = Uri.parse('http://$ServerIP/api/ott');
                        var api = widget.api;
                        var user = widget.user;
                        http.get(uri, headers: {
                          'authorization': 'Bearer $api',
                          'user': '$user'
                        }).then((response) {
                          var authkey = jsonDecode(response.body)["value"];
                          Uri uri2 =
                              Uri.parse('http://$ServerIP/api/history');
                          http.get(uri2, headers: {
                            'authorization': 'Bearer $authkey',
                            'user': '$user',
                          }).then((response2) {
                            //print("$authkey");
                            //print(response2.body);
                            data = jsonDecode(response2.body);
                            _listb = [];
                            for (var d in data) {
                              _listb.add(d);
                              //print(d);
                            }
                            setState(() {});
                          });
                        });
                      }
                    },
                    child: Text("搜索"),
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
                                  "日期",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "零用錢",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "成人",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "孩子",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                            Expanded(
                                flex: 2,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "零用錢",
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
                                              _listb[index]["action"] +
                                                  _listb[index]["money"],
                                              style: TextStyle(),
                                            ))),
                                    Expanded(
                                        flex: 1,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              _listb[index]["from"],
                                              style: TextStyle(),
                                            ))),
                                    Expanded(
                                        flex: 1,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              _listb[index]["to"],
                                              style: TextStyle(),
                                            ))),
                                    Expanded(
                                        flex: 2,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              _listb[index]["reason"],
                                              style: TextStyle(),
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
