import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './config/app_constants.dart' as route_names;
import './config/routes.dart';
import './constants/app_theme.dart';
import 'blocs/forgotpassword/forgotpassword_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'blocs/signup/signup_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignupBloc(),
          ),
          BlocProvider(
            create: (context) => LoginBloc(),
          ),
          BlocProvider(
            create: (context) => ForgotPasswordBloc(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          onGenerateRoute: Routes.onGenerateRoute,
          initialRoute: route_names.RouteNames.login,
        ));
  }
}
