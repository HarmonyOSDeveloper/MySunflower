import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mysunflower/addorremove.dart';
import 'package:mysunflower/history.dart';
import 'package:mysunflower/home.dart';
import 'package:mysunflower/my.dart';

var api2;

class NavBase extends StatefulWidget {
  final api;
  final user;

  const NavBase({Key? key, required this.api, required this.user})
      : super(key: key);
  @override
  _NavBaseState createState() => _NavBaseState();
}

class _NavBaseState extends State<NavBase> {
  @override
  int index = 0;
  void changePage(index2) {
    setState(() {
      index = index2;
    });
  }

  Widget build(BuildContext context) {
    final List<Widget> _children = [
      HomePage(api: widget.api, user: widget.user,page:this.changePage),
      MoneyMgr(),
      History(
        api: widget.api,
        user: widget.user,
      ),
      MyScreen()
    ];
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide > 550;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    if (!isTablet) {
      return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          bottomNavigationBar: Container(
            height: 51,
            width: double.infinity,
            child: Column(children: [
              //NavBar Item
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)))),
                              minimumSize: MaterialStateProperty.all(Size(90,50)),
                              foregroundColor: (index == 0)
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 10, 89, 247))
                                  : MaterialStateProperty.all(Color.fromARGB(255, 144, 145, 147)
                                      )
                                      ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Icon(Icons.home),
                            //SizedBox(width: 5),
                            Text("Home")
                          ])),
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          style: ButtonStyle(
                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)))),
                              minimumSize: MaterialStateProperty.all(Size(90,50)),
                              foregroundColor: (index == 1)
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 10, 89, 247))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(255, 144, 145, 147))),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                            Icon(Icons.attach_money_rounded),
                            SizedBox(width: 5),
                            Text("Transactions")
                          ])
                          ),
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              index = 2;
                            });
                          },
                          style: ButtonStyle(
                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)))),
                              minimumSize: MaterialStateProperty.all(Size(90,50)),
                              foregroundColor: (index == 2)
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 10, 89, 247))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(255, 144, 145, 147))),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                            Icon(Icons.history),
                            SizedBox(width: 5),
                            Text("History")
                          ])),
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              index = 3;
                            });
                          },
                          style: ButtonStyle(
                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)))),
                              minimumSize: MaterialStateProperty.all(Size(90,50)),
                              foregroundColor: (index == 3)
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 10, 89, 247))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(255, 144, 145, 147))),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                            Icon(Icons.account_circle_rounded),
                            SizedBox(width: 5),
                            Text("My")
                          ])),
                    ],
                  ),
                ),
              )
            ]),
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
    } else if (isTablet && !isPortrait) {
      return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIconTheme:
                    IconThemeData(color: Color.fromARGB(255, 10, 89, 247)),
                selectedLabelTextStyle:
                    TextStyle(color: Color.fromARGB(255, 10, 89, 247)),
                //indicatorColor: Color.fromARGB(255, 10, 89, 247),
                backgroundColor: Color.fromARGB(255, 241, 243, 245),
                selectedIndex: index,
                onDestinationSelected: (int _index) {
                  setState(() {
                    index = _index;
                    print(widget.api);
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text("Home"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.attach_money_rounded),
                    label: Text('Transactions'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.history),
                    label: Text('History'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.account_circle),
                    label: Text('My'),
                  ),
                ],
              ),
              //const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: _children[index]),
            ],
          ),
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
    } else {
      return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          bottomNavigationBar: Container(
            height: 40,
            width: double.infinity,
            child: Column(children: [
              //NavBar Item
              Container(
                height: 39,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)))),
                              minimumSize: MaterialStateProperty.all(Size(90,45)),
                              foregroundColor: (index == 0)
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 10, 89, 247))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(255, 144, 145, 147))
                                      ),
                          child: Row(children: [
                            Icon(Icons.home),
                            SizedBox(width: 5),
                            Text("Home")
                          ])),
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          style: ButtonStyle(
                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)))),
                              minimumSize: MaterialStateProperty.all(Size(90,45)),
                              foregroundColor: (index == 1)
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 10, 89, 247))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(255, 144, 145, 147))),
                          child: Row(children: [
                            Icon(Icons.attach_money_rounded),
                            SizedBox(width: 5),
                            Text("Transactions")
                          ])),
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              index = 2;
                            });
                          },
                          style: ButtonStyle(
                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)))),
                              minimumSize: MaterialStateProperty.all(Size(90,45)),
                              foregroundColor: (index == 2)
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 10, 89, 247))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(255, 144, 145, 147))),
                          child: Row(children: [
                            Icon(Icons.history),
                            SizedBox(width: 5),
                            Text("History")
                          ])),
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              index = 3;
                            });
                          },
                          style: ButtonStyle(
                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7)))),
                              minimumSize: MaterialStateProperty.all(Size(90,45)),
                              foregroundColor: (index == 3)
                                  ? MaterialStateProperty.all(
                                      Color.fromARGB(255, 10, 89, 247))
                                  : MaterialStateProperty.all(
                                      Color.fromARGB(255, 144, 145, 147))),
                          child: Row(children: [
                            Icon(Icons.account_circle_rounded),
                            SizedBox(width: 5),
                            Text("My")
                          ])),
                    ],
                  ),
                ),
              )
            ]),
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
}
