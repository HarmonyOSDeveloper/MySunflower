import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mysunflower/addorremove.dart';
import 'package:mysunflower/nav.dart';
import 'package:mysunflower/reportbug.dart';
import 'package:mysunflower/settings.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
    routes: {
      '/settings': (context) => Settings(),
      '/bug': (context) => ReportBug()
    },
    theme: ThemeData(
      fontFamily: 'HarmonyOS_Sans',
      hintColor: Color.fromARGB(255, 101, 101, 101),
      scaffoldBackgroundColor: Color.fromARGB(255, 241, 243, 245),
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30)),
          iconColor: Colors.black,
          prefixIconColor: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF0A59F7)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        )),
        elevation: MaterialStateProperty.all(0),
      )),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular((11)),
      )))),
      appBarTheme: AppBarTheme(
          actionsIconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 241, 243, 245)),
      splashColor: Colors.transparent,
    ),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  final username = TextEditingController();
  final pw = TextEditingController();
  final url = TextEditingController();
  var _passwordVisible = false;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Login To The System",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 45, maxWidth: double.infinity),
                    child: TextField(
                      controller: username,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: 'Username',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 45, maxWidth: double.infinity),
                    child: TextField(
                      controller: pw,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: _passwordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //validate
                      //skip
                      bool correctresp = false;
                      if (username.text != "" && pw.text != "") {
                        String credentials = username.text + ":" + pw.text;
                        Codec<String, String> stringToBase64 =
                            utf8.fuse(base64);
                        String encoded = stringToBase64.encode(credentials);
                        Uri uri =
                            Uri.parse('http://127.0.0.1:8888/api/apitoken');
                        http.get(uri,
                            // Send authorization headers to the backend.
                            headers: {
                              HttpHeaders.authorizationHeader: 'Basic $encoded'
                            }).then((response) {
                          print(response.body);
                          if (jsonDecode(response.body)["value"]
                              .startsWith("ERR:")) {
                            correctresp = false;
                            //print(correctresp);
                          } else {
                            correctresp = true;
                            setState(() {
                              username.text == "";
                              pw.text == "";
                            });
                          }
                          if (correctresp == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NavBase(api:jsonDecode(response.body)["value"]),
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity,
                            45) // put the width and height you want
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
