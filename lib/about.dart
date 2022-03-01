import 'package:flutter/material.dart';

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
          title: Text("About", style: TextStyle(color: Colors.black))),
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
                "Version 9.9.9999(C2PR5)",
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Official Website",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        Text(
                                          "https://google.com",
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
                                Text("Service Hotline",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                                Text("+852 00000000",style: TextStyle(fontWeight: FontWeight.w500,color: Color.fromARGB(129, 0, 0, 0)),),
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
                                Text("Support E-Mail",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                                Text("meowtechopensource@gmail.com",style: TextStyle(fontWeight: FontWeight.w500,color: Color.fromARGB(129, 0, 0, 0)),),
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
          child: Text("Subject to the MySunflower Software License\nMySunflower, All rights reserved. (c) 2020-2022\nMade By Meow Tech Open Source",textAlign: TextAlign.center,style: TextStyle(color:Color.fromARGB(255, 95, 96, 97)),),
        ),
      ),
    );
  }
}
