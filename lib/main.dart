import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash/splash.dart' as Splashes;
import 'package:flutter/material.dart';
import 'package:mysunflower/about.dart';
import 'package:mysunflower/addorremove.dart';
import 'package:mysunflower/nav.dart';
import 'package:mysunflower/reportbug.dart';
import 'package:mysunflower/screen_management/screen_manager.dart';
import 'package:mysunflower/settings.dart';
import 'package:http/http.dart' as http;
import 'package:mysunflower/user_config/user_config.dart';
import 'package:provider/provider.dart';

import 'server_ip_management/server_ip_manager.dart';

var ServerIP;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  // Try reading data from the counter key. If it doesn't exist, return 0.
  print("Running");
  ServerIP = prefs.getString("ip") ?? "";
  print(ServerIP);
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ScreenManager())],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '/settings': (context) => Settings(),
        '/bug': (context) => ReportBug(),
        '/about': (context) => AboutPage(),
        '/scan': (context) => QRViewExample(),
      },
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
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
          // splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.all(Color.fromRGBO(0, 0, 0, 0.1)),
          backgroundColor: MaterialStateProperty.all(Color(0xFF0A59F7)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          )),
          elevation: MaterialStateProperty.all(0),
        )),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Color.fromRGBO(0, 0, 0, 0.1)),
                splashFactory: NoSplash.splashFactory,
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular((10)),
                )))),
        appBarTheme: AppBarTheme(
            actionsIconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Color.fromARGB(255, 241, 243, 245)),
        //splashColor: Colors.transparent,
        popupMenuTheme: PopupMenuThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
      ),
    ),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final pw = TextEditingController();
  final url = TextEditingController();
  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings').then((value) {
                  setState(() async {
                    WidgetsFlutterBinding.ensureInitialized();
                    var prefs = await SharedPreferences.getInstance();
                    // Try reading data from the counter key. If it doesn't exist, return 0.
                    ServerIP = prefs.getString("ip") ?? "";
                    print(ServerIP);
                  });
                });
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Testing:
                //TextButton(child: const Text('FlatButton'), onPressed: () {}),
                // Title:
                Text(
                  "登入",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 25),

                userNameField(),
                SizedBox(height: 15),

                passwordField(context),
                SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () => tryLogin(context),
                  child: Text("登入"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45)),
                ),
                Text(ServerIP)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userNameField() => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 45, maxWidth: double.infinity),
        child: TextField(
          controller: username,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: '用戶',
          ),
        ),
      );

  Widget passwordField(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 45, maxWidth: double.infinity),
        child: TextField(
          controller: pw,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: '密碼',
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),

              // Update the state i.e. toogle the state of passwordVisible variable
              onPressed: () =>
                  setState(() => _passwordVisible = !_passwordVisible),
            ),
          ),
          obscureText: _passwordVisible,
          enableSuggestions: false,
          autocorrect: false,
        ),
      );

  Future<void> tryLogin(BuildContext context) async {
    bool correctresp = false;
    if (ServerIP == "") {
      Fluttertoast.showToast(
          backgroundColor: Color.fromARGB(255, 86, 84, 85),
          msg: "請在設置中輸入服務器IP.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else if (username.text != "" && pw.text != "") {
      String credentials = username.text + ":" + pw.text;
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(credentials);
      //First,Validate That It Is A Legit Sunflower-Compatable Server.
      var resp;
      bool right = false;
      try {
        resp = await http.get(
            Uri.parse("http://$ServerIP/api/islegitsunflowercompatableserver"));
        right = true;
      } catch (exception) {
        print(exception);
        Fluttertoast.showToast(
            backgroundColor: Color.fromARGB(255, 86, 84, 85),
            msg: "錯誤：無法訪問服務器，請嘗試重新連接到網絡或檢查服務器 IP/域。",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
      Uri uri = Uri.parse('http://$ServerIP/api/apitoken');
      if (right) {
        if (resp.statusCode == 200) {
          http.get(uri,
              // Send authorization headers to the backend.
              headers: {
                HttpHeaders.authorizationHeader: 'Basic $encoded'
              }).then((response) {
            //print(response.body);
            if (jsonDecode(response.body)["value"].startsWith("ERR:")) {
              correctresp = false;
              //print(correctresp);
            } else {
              correctresp = true;
            }
            if (correctresp == true) {
              var username1 = "";
              setState(() {
                username1 = username.text;
                username.text = "";
                pw.text = "";
              });

              ServerIpManager.instance.ip = ServerIP;
              print(ServerIpManager.instance.ip);

              //print(username1);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavBase(
                      api: jsonDecode(response.body)["value"], user: username1),
                ),
              );
            }
          });
        } else {
          Fluttertoast.showToast(
              backgroundColor: Color.fromARGB(255, 86, 84, 85),
              msg: "錯誤：無法訪問服務器，請嘗試重新連接到網絡或檢查服務器 IP/域。",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      }
    }
  }
}
