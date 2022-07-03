import 'package:flutter/material.dart';

class SignUpScreenConstants {
  static const String mobileBackgroungImage =
      'assets/images/mobile_background_image.jpg';
  static const String tabletWellcomeTitle = 'Start from Scratch';
  static const String mobileWellcomeTitle = 'Start \nfrom Scratch';
  static const String subtitle = 'Create account to continue';
  static const String fullName = 'Full Name';
  static const String email = 'Email Address';
  static const String password = 'Password';
  static const String subtitleAlreadyHaveAnAccount = 'Already have an account?';
  static const String buttonCreateAccount = 'Create Account';
  static const String subtitleLoginHere = 'Login Here';
  static const String signUpButton = 'Sign Up';
  static const String tryLoginButton = 'Try login';
  static const String accountAlreadyExistMsg = 'Account already exists';
  static const int fullNameTextLimit = 50;
}

class LoginScreenConstants {
  static const mainTheme = Color(0xFF00B4D8);
  static const welcomeTitleColor = Color(0xff030F09);
  static const loginTitleColor = Color(0xff606060);
  static const forgotPasswordTitleColor = Color(0xff606060);
  static const emailAndPasswordTitleColor = Color(0xffA8A8A8);
  static const signUpTitleColor = Color(0xffA8A8A8);
  static const loginButtonTextColor = Color(0xffffffff);
  static const signUpTextColor = Color(0xFF00B4D8);
  static const textFieldTextColor = Color(0xff030F09);

  static const String welcomeTitle = 'Welcome \nBack!';
  static const String loginTitle = 'Please login to continue.';
  static const String emailTitle = 'Email';
  static const String passwordTitle = 'Password';
  static const String forgotPasswordTitle = 'Forgot password?';
  static const String loginButton = 'Login';
  static const String signUpTitle = 'New to Scratch?';
  static const String signUp = 'Create Account Here';
  static const String mobileImageAssets =
      'assets/images/mobile_background_image.jpg';
  static const String logoImageAssets = 'assets/images/app_logo_no_bg.png';
  static const String loginFailNotification =
      'Your Username or Password is incorrect, please try again!!';
}

class ForgotPasswordScreenConstants {
  static const mainTheme = Color(0xFF00B4D8);
  static const welcomeTitleColor = Color(0xff030F09);
  static const forgotPasswordTitleColor = Color(0xff606060);
  static const emailTitleColor = Color(0xffA8A8A8);
  static const sendButtonTextColor = Color(0xffffffff);
  static const textFieldTextColor = Color(0xff030F09);

  static const String resetPassword = 'Reset Password!';
  static const String forgotPasswordTitle =
      'Enter the email associated with your account  and we\'ll send an email with a link to reset your password.';
  static const String emailTitle = 'Email address';
  static const String sendButton = 'Send';
  static const String mobileImageAssets =
      'assets/images/mobile_background_image.jpg';
  static const String logoImageAssets = 'assets/images/scratch_logo.png';
  static const String tabletWellcomeTitle = 'Start from Scratch';
  static const String mobileWellcomeTitle = 'Start \nfrom Scratch';
  static const String sendingFail = 'Sending fail, please try again!!';
}

class AppConstants {
  static const String appName = 'ABook';
  static const String primaryFont = 'Nunito';
  static const String secondaryFont = 'Arial';
  static const double minTabletWidth = 600.0;
  static const double appBorderRadius = 8.0;
  static const String logoImageAssets = 'assets/images/app_logo_no_bg.png';
}

class ColorsConstant {
  static const primaryColor = Color(0xFF00B4D8);
  static const subTitle = Color(0xff606060);
  static const textFieldTitle = Color(0xffA8A8A8);
  static const textField = Color(0xff030F09);
  static const logoText = Color(0xff363837);
  static const activeTabButton = Color(0xFF00B4D8);
  static const inactiveTabButton = Color(0xffA8A8A8);

  static List<Color> gradientBackgroundColorLoginScreen = [
    Colors.white.withOpacity(0.1),
    Colors.white.withOpacity(0.5),
    Colors.white.withOpacity(0.7),
    Colors.white,
  ];
}

class FailureProcess {
  static const String invalidEmail = 'Invalid Email';
  static const String invalidPassword =
      'Password must have at least 8 characters, including uppercase, lowercase, numbers, special characters';
  static const String invalidFullName = 'Full name cannot be left blank';
}
