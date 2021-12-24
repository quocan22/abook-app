import 'package:flutter/material.dart';

import './src/app.dart';
import './src/config/app_config.dart';

void main() async {
  await AppConfig().initialize();
  runApp(const App());
}
