import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void initState() {
    var data = [];
    this.initState();
    Uri uri = Uri.parse('http://127.0.0.1:8888/api/apitoken');
    http.get(uri).then((response) {
      data = jsonDecode(response.body);
      for (var d in data){
        
      }
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
          child: Container(
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
              )
            ]),
          ),
        ),
      ),
    );
  }
}
