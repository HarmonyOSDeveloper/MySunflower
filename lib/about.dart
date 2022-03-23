// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mysunflower/user_config/my_button.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(color: Colors.black),
          title: Text("關於", style: TextStyle(color: Colors.black))),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Center(
            child: Column(children: [
              Text(
                "MySunflower",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
              Text(
                "版本 1.0.0001(Beta)",
                style: TextStyle(color: Color.fromARGB(255, 102, 102, 102)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        MyButton(
                          height: 55,
                          width: double.infinity,
                          borderRadius: 10,
                          backgroundColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pushNamed(context, '/about');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("官方網站",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                          "Unavalible.com",
                                          style: TextStyle(
                                            color: Color.fromARGB(129, 0, 0, 0),
                                          ),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    //Text("9.9.9999(C6PR203)"),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 2, 2, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("服務熱線",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "+852 00000000",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(129, 0, 0, 0)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 2, 2, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("技術支持電子郵件",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                  "meowtechopensource@gmail.com",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(129, 0, 0, 0)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Expanded(child: Container()),
            ]),
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 241, 243, 245)),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Text(
            "受 MySunflower 軟件許可的約束\nMySunflower，保留所有權利。 (c) 2020-2022\n由 Meow Tech Open Source製成",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromARGB(255, 95, 96, 97)),
          ),
        ),
      ),
    );
  }
}
