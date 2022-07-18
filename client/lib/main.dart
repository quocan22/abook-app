import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import './src/app.dart';
import './src/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppConfig().initialize();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],
      path: 'assets/translations',
      // startLocale: const Locale('vi', 'US'),
      child: const App(),
    ),
  );
}
