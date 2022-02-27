import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _sw01 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(color: Colors.black),
          title: Text("Settings",
              style: TextStyle(color: Colors.black))),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Padding(padding: const EdgeInsets.fromLTRB(14, 0, 0, 2),child: Text("Section Name",textAlign: TextAlign.left,style: TextStyle(fontSize: 15),),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(9.0),
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _sw01 = !_sw01;
                          });
                        },
                        child: Row(
                          children: [
                            Text("Biometric Authentication For Login",
                                style: TextStyle(color: Colors.black)),
                            Spacer(),
                            Switch(
                                value: _sw01,
                                onChanged: (vl) {
                                  _sw01 = vl;
                                  setState(() {});
                                })
                          ],
                        ),
                      ),
                      Divider(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _sw01 = !_sw01;
                          });
                        },
                        child: Row(
                          children: [
                            Text("Enable Some Features Yali Yada.",
                                style: TextStyle(color: Colors.black)),
                            Spacer(),
                            Switch(
                                value: _sw01,
                                onChanged: (vl) {
                                  _sw01 = vl;
                                  setState(() {});
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(9.0),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Application Version",
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),
                                Spacer(),
                                Text("9.9.9999(C6PR203)"),
                                //IconButton(iconSize: 15.0,onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded,))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
