import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './blocs/authentication/authentication_bloc.dart';
import './blocs/book/book_bloc.dart';
import './blocs/book_by_category/book_by_category_bloc.dart';
import './blocs/category/category_bloc.dart';
import './blocs/chatbot/chatbot_bloc.dart';
import './blocs/feedback/feedback_bloc.dart';
import './blocs/forgotpassword/forgotpassword_bloc.dart';
import './blocs/login/login_bloc.dart';
import './blocs/profile/profile_bloc.dart';
import './blocs/signup/signup_bloc.dart';
import './blocs/user_claim/user_claim_bloc.dart';
import './config/app_constants.dart' as route_names;
import './config/routes.dart';
import './constants/app_theme.dart';
import './services/book_service/book_service_impl.dart';
import './services/category_service/category_service_impl.dart';
import './services/chatbot_service/chatbot_service_impl.dart';
import './services/feedback_service/feedback_service_impl.dart';
import './services/user_service/user_service_impl.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dioClient = dio.Dio();
    BookServiceImpl _bookService = BookServiceImpl(dioClient: dioClient);
    CategoryServiceImpl _categoryService =
        CategoryServiceImpl(dioClient: dioClient);
    UserServiceImpl _userService = UserServiceImpl(dioClient: dioClient);
    FeedbackServiceImpl _feedbackService =
        FeedbackServiceImpl(dioClient: dioClient);

    ChatbotServiceImpl _chatbotService =
        ChatbotServiceImpl(dioClient: dioClient);

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthenticationBloc()),
          BlocProvider(
            create: (context) => SignupBloc(userService: _userService),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(userService: _userService),
          ),
          BlocProvider(
            create: (context) => LoginBloc(userService: _userService),
          ),
          BlocProvider(
            create: (context) => UserClaimBloc(userService: _userService),
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
          BlocProvider(
            create: (context) => FeedbackBloc(service: _feedbackService),
          ),
          BlocProvider(
            create: (context) => ChatbotBloc(service: _chatbotService),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          onGenerateRoute: Routes.onGenerateRoute,
          initialRoute: route_names.RouteNames.initial,
        ));
  }
}
