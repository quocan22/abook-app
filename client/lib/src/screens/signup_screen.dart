import 'package:flutter/material.dart';

import '../constants/constants.dart' as constants;
import '../widgets/logo.dart';
import '../widgets/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mobileBackroundImagePadding = EdgeInsets.fromLTRB(25, 60, 0, 0);
    final _mobileSignUpFormPadding =
        EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 25.0);
    final double _heightBackgroundMobile = 240;
    final double _heightFromLogoToWellcomeTitleMobile = 45;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _heightBackgroundMobile,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100)),
                image: DecorationImage(
                  image: AssetImage(
                    constants.SignUpScreenConstants.mobileBackgroungImage,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              padding: _mobileBackroundImagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Logo(),
                  SizedBox(height: _heightFromLogoToWellcomeTitleMobile),
                  Text(
                    constants.SignUpScreenConstants.mobileWellcomeTitle,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                        ),
                  )
                ],
              ),
            ),
            Padding(
              padding: _mobileSignUpFormPadding,
              child: SignUpForm(),
            )
          ],
        ),
      ),
    );
  }
}
