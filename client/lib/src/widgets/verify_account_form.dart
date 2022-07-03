import 'package:client/src/blocs/login/login_bloc.dart';
import 'package:client/src/blocs/login/login_event.dart';
import 'package:client/src/blocs/verify/verify_bloc.dart';
import 'package:client/src/blocs/verify/verify_event.dart';
import 'package:client/src/blocs/verify/verify_state.dart';
import 'package:client/src/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart' as constants;

class VerifyAccountForm extends StatefulWidget {
  final String email;
  final String userId;

  const VerifyAccountForm({Key? key, required this.email, required this.userId})
      : super(key: key);

  @override
  _VerifyAccountFormState createState() => _VerifyAccountFormState();
}

class _VerifyAccountFormState extends State<VerifyAccountForm> {
  final _codeTextController = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeTextController.dispose();
    super.dispose();
  }

  String? codeValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Invalid Code';
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
    const double _textAndTextFieldSpacing = 30.0;
    const double _signUpFormSpacing = 30.0;
    const _textFieldContentPadding = EdgeInsets.only(top: 15.0, bottom: 5.0);
    const double _signUpButtonHeight = 50.0;

    double _signUpTitleFontSize = 16;
    double _textFormFieldFontSize = 19;
    double _signUpButtonFontSize = 18;
    double _loginTextFontSize = 19;
    double _loginTitleFontSize = 16;

    FontWeight _signUpTitleFontWeight = FontWeight.w300;
    FontWeight _signUpButtonFontWeight = FontWeight.w400;
    FontWeight _loginTitleFontWeight = FontWeight.w300;

    return BlocListener<VerifyBloc, VerifyState>(
        listener: (context, state) {
          if (state is VerifyInitial && state.userId != null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('An code has bean sent to your email')));
          }
          if (state is VerifySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Your account has been verified. You can login now.')));
            context.read<LoginBloc>().add(LoginStateReseted());
            Navigator.of(context)
                .pushReplacementNamed(RouteNames.login, arguments: state.email);
          }
          if (state is VerifyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('This OTP code is wrong')));
          }
        },
        child: Form(
          key: _signUpFormKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    'Please type the verification code sent to ${widget.email}',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: constants.ColorsConstant.subTitle,
                        fontSize: _signUpTitleFontSize,
                        fontWeight: _signUpTitleFontWeight)),
                const SizedBox(
                  height: _textAndTextFieldSpacing,
                ),
                TextFormField(
                  validator: (value) => codeValidate(value),
                  controller: _codeTextController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  cursorColor: constants.ColorsConstant.primaryColor,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: constants.ColorsConstant.primaryColor),
                    ),
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
                Center(
                  child: InkWell(
                    onTap: () => context
                        .read<VerifyBloc>()
                        .add(VerifyResendOTPRequested(email: widget.email)),
                    child: Text(
                      'Resend Code',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: constants.ColorsConstant.primaryColor,
                          fontSize: _loginTextFontSize,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
                const SizedBox(height: _signUpFormSpacing / 2),
                SizedBox(
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
                    onPressed: () {
                      if (formValidate()) {
                        context.read<VerifyBloc>().add(VerifyRequested(
                            userId: widget.userId,
                            otp: _codeTextController.text.trim(),
                            email: widget.email));
                      }
                    },
                    child: Text(
                      'Verify',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                          fontSize: _signUpButtonFontSize,
                          fontWeight: _signUpButtonFontWeight),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Already verify your account?',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: constants.ColorsConstant.textFieldTitle,
                            fontSize: _loginTitleFontSize,
                            fontWeight: _loginTitleFontWeight),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pushReplacementNamed(
                            RouteNames.login,
                            arguments: widget.email),
                        child: Text(
                          constants.SignUpScreenConstants.subtitleLoginHere,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
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
