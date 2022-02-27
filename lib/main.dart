
import 'package:flutter/material.dart';
import 'package:mysunflower/addorremove.dart';
import 'package:mysunflower/nav.dart';
import 'package:mysunflower/reportbug.dart';
import 'package:mysunflower/settings.dart';

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
    routes: {
      '/navbase': (context) => NavBase(),
      '/settings': (context) => Settings(),
      '/bug': (context) => ReportBug()
    },
    theme: ThemeData(
      fontFamily: 'HarmonyOS_Sans',
      hintColor: Color.fromARGB(255, 101, 101, 101),
      scaffoldBackgroundColor: Color.fromARGB(255, 241, 243, 245),
      inputDecorationTheme: InputDecorationTheme(border:OutlineInputBorder(borderSide: BorderSide(width: 0,color: Colors.transparent)),fillColor: Colors.white,filled: true,focusedBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius:BorderRadius.circular(30)),iconColor: Colors.black,prefixIconColor: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF0A59F7)),shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),)),elevation: MaterialStateProperty.all(0),)),
      textButtonTheme: TextButtonThemeData(style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular((11)),)))),
      appBarTheme: AppBarTheme(actionsIconTheme: IconThemeData(color:Colors.black),elevation: 0,backgroundColor: Color.fromARGB(255, 241, 243, 245)),
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
  var _passwordVisible = false;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Login To The System",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 45,
                      maxWidth: double.infinity
                    ),
                    
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 12.0),
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
                      maxHeight: 45,
                      maxWidth: double.infinity
                    ),
                    
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 12.0),
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
                  ElevatedButton(onPressed: (){
                    //validate 
                    //skip 
                    var correctresp = true;
                    //go to Home page if correct
                    if (correctresp){
                       Navigator.pushNamed(context, '/navbase');
                    }
                  }, child: Text("Login"),style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45) // put the width and height you want
                    ),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
