import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _sw01 = false;
  bool? _value = false;
  double _value2 = 0;
  var val;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(color: Colors.black),
          title: Text("Settings", style: TextStyle(color: Colors.black))),
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
                    padding: const EdgeInsets.all(6.0),
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
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
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
              Checkbox(
                value: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                fillColor:
                    MaterialStateProperty.all(Color.fromARGB(255, 10, 89, 247)),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                      width: 1.5, color: Color.fromRGBO(0, 0, 0, 40)),
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.blue,
                  inactiveTrackColor: Colors.grey,
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 30.0,
                  thumbColor: Colors.white,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 12.0,
                  ),
                  overlayColor: Colors.white.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                ),
                child: Slider(
                  value: _value2,
                  onChanged: (value) {
                    setState(() {
                      _value2 = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text("Male"),
                leading: Radio(
                  value: 1,
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
              ListTile(
                title: Text("Female"),
                leading: Radio(
                  value: 2,
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value;
                    });
                  },
                  activeColor: Colors.green,
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
