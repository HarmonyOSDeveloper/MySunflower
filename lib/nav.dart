import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mysunflower/addorremove.dart';
import 'package:mysunflower/history.dart';
import 'package:mysunflower/home.dart';
import 'package:mysunflower/my.dart';
var api2;
class NavBase extends StatefulWidget {
  final api;

  const NavBase({Key? key, required this.api}) : super(key: key);
  @override
  _NavBaseState createState() => _NavBaseState();
}

class _NavBaseState extends State<NavBase> {
  @override
  int index = 0;
  Widget build(BuildContext context) {
    void initState(){
      this.initState();
      final List<Widget> _children = [
          HomePage(api:widget.api),
          MoneyMgr(),
          History(),
          MyScreen()
        ];
    }
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color.fromARGB(255, 10, 89, 247),
          selectedFontSize: 15.0,
          unselectedFontSize: 15.0,
          onTap: (_index) {
            setState(() {
              index = _index;
              print(widget.api);
            });
          },
          backgroundColor: const Color.fromARGB(255, 241, 243, 245),
          currentIndex: index, // this will be set when a new tab is tapped
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.attach_money_rounded),
              label: "Add/Remove Money",
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.history),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle),
              label: "My",
            ),
          ],
        ),
        body: Container(child: _children[index]),
        floatingActionButton: Container(
          height: 37,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 10,
                blurRadius: 50,
                offset: Offset(3, 5),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            elevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            hoverElevation: 0,
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/bug');
            },
            label: Text("Report A Bug",
                style: TextStyle(
                    letterSpacing: .5, fontSize: 15, color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
