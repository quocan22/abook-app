import 'package:client/src/blocs/authentication/authentication_bloc.dart';
import 'package:client/src/blocs/authentication/authentication_event.dart';
import 'package:client/src/blocs/authentication/authentication_state.dart';
import 'package:client/src/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart' as constants;

class RootScreen extends StatefulWidget {
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthenticationBloc>().add(AuthenticationLoaded());
    return BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          if (state is AuthenticationFailure) {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteNames.login, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteNames.navigation, (route) => false);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(
              color: constants.ColorsConstant.primaryColor,
            ),
          ),
        ));
  }
}
