import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 242, 245),
      body: Container(
        height: double.infinity,
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 237, 242, 245),
            ),
            child: Center(
                child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
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
                                      "Child",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )))),
                    ],
                  ),
                  Text(
                    "Username123",
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
                          children: [Text("HKD\$999"), Text("Amount")],
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
                          children: [Text("Sunflower v9.9"), Text("System")],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            )),
          ),
          Expanded(
            child: Container(
              //height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(9.0),
                children: <Widget>[
                  TextButton(
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
                  TextButton(
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
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Color.fromARGB(255, 232, 64, 38)),
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(180, 39)),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(10, 0, 0, 0)),
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
