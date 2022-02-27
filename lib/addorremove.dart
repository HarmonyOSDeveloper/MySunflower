import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoneyMgr extends StatefulWidget {
  const MoneyMgr({Key? key}) : super(key: key);

  @override
  _MoneyMgrState createState() => _MoneyMgrState();
}

class _MoneyMgrState extends State<MoneyMgr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Add/Remove Money",
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            automaticallyImplyLeading: false),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(17, 2, 17, 8),
          child: Column(children: [
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: 40, maxWidth: double.infinity),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Amount(\$CUR)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], 
              ),
            ),
            SizedBox(
                height: 15,
              ),
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: 40, maxWidth: double.infinity),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Child's Username",
                ),
              ),
            ),
            SizedBox(
                height: 15,
              ),
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: double.infinity, maxWidth: double.infinity),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Reason(Multiline)",
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            SizedBox(height:15),
            Row(children: [
                ElevatedButton(onPressed: (){
                  //Navigator.pushNamed(context, '/home');
                }, child: Text("Add"),style: ElevatedButton.styleFrom(
                    minimumSize: Size(180, 43) // put the width and height you want
                ),
              ),
              SizedBox(width:10),
              ElevatedButton(onPressed: (){
                  //Navigator.pushNamed(context, '/home');
                }, child: Text("Remove"),style: ElevatedButton.styleFrom(
                    minimumSize: Size(180, 43) // put the width and height you want
                ),
              )
              ],),
          ]),
        ));
  }
}
