import 'package:flutter/material.dart';

import 'main.dart';

class Env {
  static Env value;

  String host;
  String operatorUrl;
  String oneSignalAppId;

  Env() {
    value = this;
    runApp(MyApp(this));
  }

  String get name => runtimeType.toString();
}
