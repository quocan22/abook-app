import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/signup/signup_bloc.dart';
import '../blocs/signup/signup_event.dart';
import '../blocs/signup/signup_state.dart';
import '../config/app_constants.dart';
import '../constants/constants.dart' as constants;
import '../utils/validators.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _fullNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  String? fullNameValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return constants.FailureProcess.invalidFullName;
    }
    return null;
  }

  String? emailValidate(String? value) {
    if (!Validators.isValidEmail(value!)) {
      return constants.FailureProcess.invalidEmail;
    }
    return null;
  }

  String? passwordValidate(String? value) {
    if (!Validators.isValidPassword(value!)) {
      return constants.FailureProcess.invalidPassword;
    }
    return null;
  }

  bool formValidate() {
    if (_signUpFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double _textAndTextfieldSpacing = 30.0;
    const double _textAndInkwellSpacing = 5.0;
    const double _signUpFormSpacing = 30.0;
    const _textFieldContentPadding = EdgeInsets.only(top: 15.0, bottom: 5.0);
    const double _signUpButtonHeight = 50.0;

    double _signUpTitleFontSize = 16;
    double _titleTextFormFieldFontSize = 15.5;
    double _textFormFieldFontSize = 19;
    double _signUpButtonFontSize = 18;
    double _loginTitleFontSize = 16;
    double _loginTextFontSize = 19;

    FontWeight _signUpTitleFontWeight = FontWeight.w300;
    FontWeight _titleTextFormFieldFontWeight = FontWeight.w300;
    FontWeight _signUpButtonFontWeight = FontWeight.w400;
    FontWeight _loginTitleFontWeight = FontWeight.w300;

    return BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            Navigator.of(context)
                .pushReplacementNamed(RouteNames.login, arguments: state.email);
          }
        },
        child: Form(
          key: _signUpFormKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Text(constants.SignUpScreenConstants.subtitle,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: constants.ColorsConstant.subTitle,
                    fontSize: _signUpTitleFontSize,
                    fontWeight: _signUpTitleFontWeight)),
            const SizedBox(
              height: _textAndTextfieldSpacing,
            ),
            Text(constants.SignUpScreenConstants.fullName,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: constants.ColorsConstant.textFieldTitle,
                    fontSize: _titleTextFormFieldFontSize,
                    fontWeight: _titleTextFormFieldFontWeight)),
            TextFormField(
              autofocus: true,
              validator: (value) => fullNameValidate(value),
              controller: _fullNameTextController,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    constants.SignUpScreenConstants.fullNameTextLimit),
                FilteringTextInputFormatter.allow(Validators.textOnlyRegExp)
              ],
              cursorColor: constants.ColorsConstant.primaryColor,
              decoration: InputDecoration(
                contentPadding: _textFieldContentPadding,
                errorStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.red,
                    ),
              ),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: constants.ColorsConstant.textField,
                  fontSize: _textFormFieldFontSize),
            ),
            const SizedBox(height: _signUpFormSpacing),
            Text(constants.SignUpScreenConstants.email,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: constants.ColorsConstant.textFieldTitle,
                    fontSize: _titleTextFormFieldFontSize,
                    fontWeight: _titleTextFormFieldFontWeight)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (value) => emailValidate(value),
              controller: _emailTextController,
              textInputAction: TextInputAction.next,
              cursorColor: constants.ColorsConstant.primaryColor,
              decoration: InputDecoration(
                contentPadding: _textFieldContentPadding,
                errorStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.red,
                    ),
              ),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: constants.ColorsConstant.textField,
                  fontSize: _textFormFieldFontSize),
            ),
            const SizedBox(height: _signUpFormSpacing),
            Text(constants.SignUpScreenConstants.password,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: constants.ColorsConstant.textFieldTitle,
                    fontSize: _titleTextFormFieldFontSize,
                    fontWeight: _titleTextFormFieldFontWeight)),
            TextFormField(
              obscureText: true,
              validator: (value) => passwordValidate(value),
              controller: _passwordTextController,
              textInputAction: TextInputAction.done,
              cursorColor: constants.ColorsConstant.primaryColor,
              decoration: InputDecoration(
                contentPadding: _textFieldContentPadding,
                errorStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.red,
                    ),
              ),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: constants.ColorsConstant.textField,
                  fontSize: _textFormFieldFontSize),
            ),
            const SizedBox(height: _signUpFormSpacing / 2),
            BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
              return Visibility(
                visible: (state is SignupFailure &&
                        state.errorMessage == "This email already existed")
                    ? true
                    : false,
                child: Row(
                  children: [
                    Text(
                      constants.SignUpScreenConstants.accountAlreadyExistMsg,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Colors.red,
                          ),
                    ),
                    const SizedBox(
                      width: _textAndInkwellSpacing,
                    ),
                    InkWell(
                      onTap: () {
                        if (state is SignupFailure) {
                          Navigator.pushReplacementNamed(
                              context, RouteNames.login,
                              arguments: state.email);
                          context.read<SignupBloc>().add(SignupStateReseted());
                        }
                      },
                      child: Text(
                        constants.SignUpScreenConstants.tryLoginButton,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: constants.ColorsConstant.primaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: _signUpFormSpacing / 2),
            BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: _signUpButtonHeight,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          constants.ColorsConstant.primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            constants.AppConstants.appBorderRadius),
                      )),
                    ),
                    onPressed: state is SignupInProgress
                        ? null
                        : () {
                            if (formValidate()) {
                              context.read<SignupBloc>().add(SignupRequested(
                                  _emailTextController.text.trim(),
                                  _passwordTextController.text,
                                  _fullNameTextController.text));
                            }
                          },
                    child: state is SignupInProgress
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            constants.SignUpScreenConstants.buttonCreateAccount,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: Colors.white,
                                    fontSize: _signUpButtonFontSize,
                                    fontWeight: _signUpButtonFontWeight),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: _textAndTextfieldSpacing,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    constants
                        .SignUpScreenConstants.subtitleAlreadyHaveAnAccount,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: constants.ColorsConstant.textFieldTitle,
                        fontSize: _loginTitleFontSize,
                        fontWeight: _loginTitleFontWeight),
                  ),
                  const SizedBox(
                    height: _textAndInkwellSpacing,
                  ),
                  InkWell(
                    onTap: () => {
                      Navigator.of(context)
                          .pushReplacementNamed(RouteNames.login)
                    },
                    child: Text(
                      constants.SignUpScreenConstants.subtitleLoginHere,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: constants.ColorsConstant.primaryColor,
                          fontSize: _loginTextFontSize,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
