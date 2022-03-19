import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mysunflower/user_config/my_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

showPopup(bool isTablet, BuildContext context) {
  showGeneralDialog(
      context: context,
      transitionDuration: Duration(milliseconds: 550),
      barrierDismissible: false,
      transitionBuilder: (BuildContext context, a1, a2, widget) {
        final curvedValue = Curves.elasticOut.transform(a1.value) - 1.0;
        return Transform.scale(
          scale: curvedValue + 1.0,
          child: Opacity(
            opacity: a1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              backgroundColor: Colors.transparent, //this right here
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 15.0,
                    sigmaY: 15.0,
                  ),
                  child: Container(
                    //height: 130,
                    decoration: new BoxDecoration(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: isTablet ? 350 : double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Logout",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                fontFamily: "HarmonyOS_Sans"),
                          ),
                          Text("Are you sure you want to logout?"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 232, 64, 38)),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)))),
                                    )),
                              ),
                              // wrap with sizedbox(height : 16)
                              SizedBox(
                                height: 25,
                                child: VerticalDivider(
                                  thickness: 1,
                                  width: 15,
                                  color: Color.fromRGBO(0, 0, 0, 0.2),
                                ),
                              ),
                              Expanded(
                                  child: MyButton(
                                borderRadius: 20,
                                backgroundColor: Colors.transparent,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 10, 89, 247)),
                                ),
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Text('1234');
      });
}

class Dialog3 extends StatefulWidget {
  final string;
  const Dialog3({
    Key? key,
    required this.string,
  }) : super(key: key);

  @override
  State<Dialog3> createState() => _Dialog3State();
}

class _Dialog3State extends State<Dialog3> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15.0,
            sigmaY: 15.0,
          ),
          child: Container(
            height: 410,
            width: 550,
            decoration: new BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "One Time Transaction",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                Center(
                  child: QrImage(
                    data: widget.string,
                    version: QrVersions.auto,
                    size: 270.0,
                  ),
                ),
                Spacer(),
                Center(
                  child: Container(
                      width: 250,
                      height: 40,
                      child: MyButton(
                        borderRadius: 30,
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                              color: Color.fromARGB(255, 10, 89, 247)),
                        ),
                      )),
                ),
                SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
