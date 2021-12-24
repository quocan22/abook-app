import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConfig {
  static final AppConfig _singleton = AppConfig._internal();
  static final AppConfig instance = AppConfig();

  factory AppConfig() {
    return _singleton;
  }

  AppConfig._internal();

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));
  }
}
