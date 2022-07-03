import 'package:client/src/blocs/verify/verify_bloc.dart';
import 'package:client/src/blocs/verify/verify_event.dart';
import 'package:client/src/blocs/verify/verify_state.dart';
import 'package:client/src/screens/verify_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../blocs/login/login_state.dart';
import '../config/app_constants.dart' as app_constants;
import '../constants/constants.dart' as constants;
import '../utils/validators.dart';

class LoginForm extends StatefulWidget {
  final String? defaultEmail;

  const LoginForm({Key? key, this.defaultEmail}) : super(key: key);
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _emailController;
  final _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController(text: widget.defaultEmail);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isInvalidEmail(String email) {
    return email.isEmpty || !Validators.isValidEmail(email);
  }

  bool isInvalidPassword(String password) {
    return password.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    double _spacingAboveOfTexts = 15;
    double _spacingBelowOfTexts = 5;
    double _buttonHeight = 57;
    double _loginTitleSpacingAbove = 5;
    double _emailTextFormFieldSectionAndPasswordTextFormFieldSectionSpacing =
        35;
    double _passwordTextFormFieldSectionAndLogginButtonSpacing = 35;
    double _logginButtonAndSignUpTitleSpacing = 35;
    double _passwordTitleAndpasswordTextFormFieldSpacing = 5;
    double _titleTextFormFieldFontSize = 15.5;
    double _textFormFieldFontSize = 19;
    double _forgotPasswordFontSize = 16;
    double _loginButtonFontSize = 18;
    double _signUpTitleFontSize = 16;
    double _signUpTextFontSize = 19;
    FontWeight _titleTextFormFieldFontWeight = FontWeight.w300;
    FontWeight _forgotPasswordFontWeight = FontWeight.w500;
    FontWeight _loginButtonFontWeight = FontWeight.w400;
    FontWeight _signUpTitleFontWeight = FontWeight.w300;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure &&
            state.errorMessage != 'This user has not been activated') {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
        }
        if (state is LoginSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              app_constants.RouteNames.navigation, (route) => false);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: _loginTitleSpacingAbove,
                ),
                Text(
                  constants.LoginScreenConstants.emailTitle,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: constants
                            .LoginScreenConstants.emailAndPasswordTitleColor,
                        fontSize: _titleTextFormFieldFontSize,
                        fontWeight: _titleTextFormFieldFontWeight,
                      ),
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (email) => isInvalidEmail(email!)
                      ? constants.FailureProcess.invalidEmail
                      : null,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: constants.LoginScreenConstants.mainTheme,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      top: _spacingAboveOfTexts,
                      bottom: _spacingBelowOfTexts,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: constants.LoginScreenConstants.mainTheme,
                        width: 2,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.7,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color:
                            constants.LoginScreenConstants.textFieldTextColor,
                        fontSize: _textFormFieldFontSize,
                      ),
                ),
                SizedBox(
                  height:
                      _emailTextFormFieldSectionAndPasswordTextFormFieldSectionSpacing,
                ),
                Text(
                  constants.LoginScreenConstants.passwordTitle,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: constants
                            .LoginScreenConstants.emailAndPasswordTitleColor,
                        fontSize: _titleTextFormFieldFontSize,
                        fontWeight: _titleTextFormFieldFontWeight,
                      ),
                ),
                SizedBox(
                  height: _passwordTitleAndpasswordTextFormFieldSpacing,
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (password) => isInvalidPassword(password!)
                      ? "Password can't be null"
                      : null,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  cursorColor: constants.LoginScreenConstants.mainTheme,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      top: _spacingAboveOfTexts,
                      bottom: _spacingBelowOfTexts,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: constants.LoginScreenConstants.mainTheme,
                        width: 2,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.7,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color:
                            constants.LoginScreenConstants.textFieldTextColor,
                        fontSize: _textFormFieldFontSize,
                      ),
                ),
                SizedBox(
                  height:
                      _passwordTextFormFieldSectionAndLogginButtonSpacing / 2,
                ),
                Visibility(
                  visible: (state is LoginFailure &&
                          state.errorMessage ==
                              'This user has not been activated')
                      ? true
                      : false,
                  child: Row(
                    children: [
                      Text(
                        'Your account has not been verified',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      InkWell(
                        onTap: () {
                          if (state is LoginFailure &&
                              state.errorMessage ==
                                  'This user has not been activated') {
                            context.read<VerifyBloc>().add(
                                VerifyResendOTPRequested(email: state.email!));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => VerifyAccountScreen(
                                        email: state.email!,
                                        userId: state.userId!)));
                          }
                        },
                        child: Text(
                          'Verify',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                color: constants.ColorsConstant.primaryColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height:
                      _passwordTextFormFieldSectionAndLogginButtonSpacing / 2,
                ),
                SizedBox(
                  width: double.infinity,
                  height: _buttonHeight,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          constants.LoginScreenConstants.mainTheme),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                    ),
                    onPressed: () {
                      if (_loginFormKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(LoginRequested(
                            _emailController.text.trim(),
                            _passwordController.text));
                      }
                    },
                    child: state is LoginInProgress
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            constants.LoginScreenConstants.loginButton,
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: constants.LoginScreenConstants
                                          .loginButtonTextColor,
                                      fontSize: _loginButtonFontSize,
                                      fontWeight: _loginButtonFontWeight,
                                    ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Center(
                  child: Text(
                    'Or',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color:
                              constants.LoginScreenConstants.signUpTitleColor,
                          fontSize: _signUpTitleFontSize,
                          fontWeight: _signUpTitleFontWeight,
                        ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: _buttonHeight,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        side: BorderSide(
                            color: constants.ColorsConstant.primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      )),
                    ),
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                            app_constants.RouteNames.navigation,
                            (route) => false),
                    child: state is LoginInProgress
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Continue as Guest',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color:
                                        constants.ColorsConstant.primaryColor,
                                    fontSize: _loginButtonFontSize,
                                    fontWeight: _loginButtonFontWeight,
                                  ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: _logginButtonAndSignUpTitleSpacing,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        constants.LoginScreenConstants.signUpTitle,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: constants
                                  .LoginScreenConstants.signUpTitleColor,
                              fontSize: _signUpTitleFontSize,
                              fontWeight: _signUpTitleFontWeight,
                            ),
                      ),
                      SizedBox(
                        height: _spacingBelowOfTexts,
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pushReplacementNamed(
                            app_constants.RouteNames.signUp),
                        child: Text(
                          constants.LoginScreenConstants.signUp,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: constants
                                        .LoginScreenConstants.signUpTextColor,
                                    fontSize: _signUpTextFontSize,
                                    fontWeight: FontWeight.w200,
                                  ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
