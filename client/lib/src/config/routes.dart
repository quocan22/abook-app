import 'package:client/src/widgets/bottom_navigator.dart';
import 'package:flutter/material.dart';

import '../screens/forgot_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/root_screen.dart';
import '../screens/signup_screen.dart';
import './app_constants.dart' as app_constants;

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case app_constants.RouteNames.initial:
        return MaterialPageRoute(
          builder: (_) => const RootScreen(),
        );
      case app_constants.RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case app_constants.RouteNames.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case app_constants.RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => settings.arguments != null
              ? LoginScreen(
                  defaultEmail: settings.arguments as String,
                )
              : const LoginScreen(),
        );
      case app_constants.RouteNames.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(),
        );
      case app_constants.RouteNames.navigation:
        return MaterialPageRoute(
          builder: (_) => BottomNavigator(),
        );
      default:
        throw Exception();
    }
  }
}
