import 'package:flutter/material.dart';

import '../constants/constants.dart' as constants;

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Navigator.of(context).pushNamedAndRemoveUntil(
    //   route_names.RouteNames.login, (route) => false);

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: constants.ColorsConstant.primaryColor,
        ),
      ),
    );
  }
}
