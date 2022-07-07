import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';

class AppConfig {
  static final AppConfig _singleton = AppConfig._internal();
  static final AppConfig instance = AppConfig();

  factory AppConfig() {
    return _singleton;
  }

  AppConfig._internal();

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await GlobalConfiguration().loadFromPath('assets/env/env.json');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
