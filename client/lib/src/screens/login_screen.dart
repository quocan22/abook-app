import 'package:flutter/material.dart';

import '../constants/constants.dart' as constant;
import '../widgets/login_form.dart';
import '../widgets/logo.dart';

class LoginScreen extends StatefulWidget {
  final String? defaultEmail;

  const LoginScreen({Key? key, this.defaultEmail}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double _mobileBackgroundImageHeight = 240;
    double _mobileSpaceBetweenLogoAndWelcomeTitle = 50;
    double _mobileLeftPadding = 25;
    double _mobileRightPadding = 25;
    double _mobileLogoTopPadding = 70;
    double _mobileLoginFormTopPadding = 20;
    EdgeInsetsGeometry _logoPadding =
        EdgeInsets.fromLTRB(_mobileLeftPadding, _mobileLogoTopPadding, 0, 0);
    EdgeInsetsGeometry _welcomeTitlePadding =
        EdgeInsets.fromLTRB(_mobileLeftPadding, 0, 0, 0);
    EdgeInsetsGeometry _loginFormPadding = EdgeInsets.fromLTRB(
        _mobileLeftPadding,
        _mobileLoginFormTopPadding,
        _mobileRightPadding,
        20);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _mobileBackgroundImageHeight,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100)),
                image: DecorationImage(
                  image: AssetImage(
                    constant.LoginScreenConstants.mobileImageAssets,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: _logoPadding,
                    child: Logo(),
                  ),
                  SizedBox(
                    height: _mobileSpaceBetweenLogoAndWelcomeTitle,
                  ),
                  Padding(
                    padding: _welcomeTitlePadding,
                    child: Text(
                      constant.LoginScreenConstants.welcomeTitle,
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: _loginFormPadding,
              child: LoginForm(
                defaultEmail: widget.defaultEmail,
              ),
            )
          ],
        ),
      ),
    );
  }
}
