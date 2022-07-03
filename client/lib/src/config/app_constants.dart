class RouteNames {
  static const String signUp = '/signUp';
  static const String login = '/login';
  static const String forgotPassword = '/forgotPassword';
  static const String home = '/home';
  static const String initial = '/';
  static const String navigation = '/navigation';
  static const String bookDetail = '/bookDetail';
  static const String bookListByCategory = '/bookListByCategory';
}

class AppConstants {
  static const String HOST_NAME =
      // '10.0.2.2:5000';
      'abook-app-backend.herokuapp.com';
  static const String BOOKS = '/api/books';
  static const String CATEGORIES = '/api/categories';
  static const String BOOKSBYCATE = '/api/books/cate';
  static const String USERS = '/api/users';
  static const String REGISTERUSER = '/api/users/signup';
  static const String LOGIN = '/api/auth/login';
  static const String ADDFAV = '/api/users/fav/add';
  static const String REMOVEFAV = '/api/users/fav/remove';
}
