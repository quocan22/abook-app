import 'package:flutter/material.dart';

import '/../src/widgets/logo.dart';
import '/../src/widgets/reset_password_form.dart';
import '/../src/constants/constants.dart' as constant;

class ForgotPasswordScreen extends StatelessWidget {
  final double loginFormWidth = 425;
  final double loginFormHeight = 467;
  final double mobileBackgroundImageHeight = 285;
  final double spaceBetweenLogoAndWelcomeTitle = 45;
  final double loginFormPadding = 50;
  final double loginFormBorder = 8;
  final double leftPadding = 25;
  final double rightPadding = 25;
  final double logoTopPadding = 60;
  final double loginFormTopPadding = 20;

  static const String mobileBackgroungImage =
      'assets/images/mobile_background.png';
  static const String tabletBackgroungImage =
      'assets/images/tablet_background.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: mobileBackgroundImageHeight,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(100)),
                  image: DecorationImage(
                      image: AssetImage(constant
                          .ForgotPasswordScreenConstants.mobileImageAssets),
                      fit: BoxFit.fill)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(leftPadding, logoTopPadding, 0, 0),
                    child: Logo(),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    leftPadding, loginFormTopPadding, rightPadding, 0),
                child: ResetPasswordForm()),
          ],
        ),
      ),
    );
  }
}
