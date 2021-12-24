import 'package:flutter/material.dart';

import '../constants/constants.dart' as constants;

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthLogo = 30;
    double heightLogo = 30;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          constants.AppConstants.logoImageAssets,
          width: widthLogo,
          height: heightLogo,
          scale: 0.7,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          constants.AppConstants.appName,
          style: Theme.of(context).textTheme.headline4?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}
