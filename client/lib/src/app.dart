import 'package:client/src/blocs/book_by_category/book_by_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart' as dio;

import './config/app_constants.dart' as route_names;
import './config/routes.dart';
import './constants/app_theme.dart';
import 'blocs/book/book_bloc.dart';
import 'blocs/category/category_bloc.dart';
import 'blocs/forgotpassword/forgotpassword_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'blocs/signup/signup_bloc.dart';
import 'services/category_service/category_service_impl.dart';
import 'services/book_service/book_service_impl.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dioClient = dio.Dio();
    BookServiceImpl _bookService = BookServiceImpl(dioClient: dioClient);
    CategoryServiceImpl _categoryService =
        CategoryServiceImpl(dioClient: dioClient);

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
          BlocProvider(
            create: (context) => BookBloc(service: _bookService),
          ),
          BlocProvider(
            create: (context) => BookByCategoryBloc(service: _bookService),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(service: _categoryService),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          onGenerateRoute: Routes.onGenerateRoute,
          initialRoute: route_names.RouteNames.navigation,
        ));
  }
}
