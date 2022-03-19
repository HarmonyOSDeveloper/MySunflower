// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class UserConfig extends ChangeNotifier{
  String _uri = "";
  String get ServerIP => _uri;
  
  void initServerIP(String baselineUrl) {
    _uri = baselineUrl;
  }
}
