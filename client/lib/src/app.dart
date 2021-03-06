import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import './blocs/address_book/address_book_bloc.dart';
import './blocs/authentication/authentication_bloc.dart';
import './blocs/best_seller_book/best_seller_book_bloc.dart';
import './blocs/book/book_bloc.dart';
import './blocs/book_detail/book_detail_bloc.dart';
import './blocs/book_by_category/book_by_category_bloc.dart';
import './blocs/cart/cart_bloc.dart';
import './blocs/category/category_bloc.dart';
import './blocs/chatbot/chatbot_bloc.dart';
import './blocs/discount/discount_bloc.dart';
import './blocs/feedback/feedback_bloc.dart';
import './blocs/order/order_bloc.dart';
import './blocs/forgotpassword/forgotpassword_bloc.dart';
import './blocs/login/login_bloc.dart';
import './blocs/profile/profile_bloc.dart';
import './blocs/signup/signup_bloc.dart';
import './blocs/user_claim/user_claim_bloc.dart';
import './blocs/verify/verify_bloc.dart';
import './config/app_constants.dart' as route_names;
import './config/routes.dart';
import './constants/app_theme.dart';
import './services/book_service/book_service_impl.dart';
import './services/cart_service/cart_service_impl.dart';
import './services/category_service/category_service_impl.dart';
import './services/chatbot_service/chatbot_service_impl.dart';
import './services/discount_service/discount_service_impl.dart';
import './services/feedback_service/feedback_service_impl.dart';
import './services/order_service/order_service_impl.dart';
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
    CartServiceImpl _cartService = CartServiceImpl(dioClient: dioClient);
    DiscountServiceImpl _discountService =
        DiscountServiceImpl(dioClient: dioClient);
    OrderServiceImpl _orderService = OrderServiceImpl(dioClient: dioClient);

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
            create: (context) => UserClaimBloc(
                userService: _userService, bookService: _bookService),
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
          BlocProvider(
            create: (context) => CartBloc(service: _cartService),
          ),
          BlocProvider(
            create: (context) => DiscountBloc(service: _discountService),
          ),
          BlocProvider(
            create: (context) => BookDetailBloc(
                service: _bookService, userService: _userService),
          ),
          BlocProvider(
            create: (context) => AddressBookBloc(service: _userService),
          ),
          BlocProvider(
            create: (context) => OrderBloc(service: _orderService),
          ),
          BlocProvider(
            create: (context) => VerifyBloc(userService: _userService),
          ),
          BlocProvider(
            create: (context) => BestSellerBookBloc(service: _bookService),
          )
        ],
        child: MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          onGenerateRoute: Routes.onGenerateRoute,
          initialRoute: route_names.RouteNames.initial,
        ));
  }
}
