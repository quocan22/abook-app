import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/forgotpassword/forgotpassword_bloc.dart';
import '../blocs/forgotpassword/forgotpassword_event.dart';
import '../blocs/forgotpassword/forgotpassword_state.dart';
import '../config/app_constants.dart';
import '../constants/constants.dart' as constants;
import '../utils/validators.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _emailController = TextEditingController();
  final double spaceBetweenItems = 30;
  final double spacingAboveOfTexts = 15;
  final double spacingBelowOfTexts = 5;
  final double buttonHeight = 50;

  final _resetformKey = GlobalKey<FormState>();

  bool isInvalidEmail(String email) {
    return email.isEmpty || !Validators.isValidEmail(email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double spacingBelowLoginTitle = 47;

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
      if (state is ResetPasswordSuccess) {
        Navigator.of(context).pushNamed(RouteNames.login);
      }
      if (state is ResetPasswordFailure) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content:
                  Text(constants.ForgotPasswordScreenConstants.sendingFail),
            ),
          );
      }
    }, child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
            builder: (context, state) {
      return Form(
        key: _resetformKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(constants.ForgotPasswordScreenConstants.resetPassword,
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    color: constants
                        .ForgotPasswordScreenConstants.welcomeTitleColor)),
            const SizedBox(
              height: spacingBelowLoginTitle,
            ),
            Text(constants.ForgotPasswordScreenConstants.forgotPasswordTitle,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: constants.ForgotPasswordScreenConstants
                        .forgotPasswordTitleColor)),
            const SizedBox(
              height: spacingBelowLoginTitle,
            ),
            Text(constants.ForgotPasswordScreenConstants.emailTitle,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: constants
                        .ForgotPasswordScreenConstants.emailTitleColor)),
            TextFormField(
                controller: _emailController,
                validator: (email) => isInvalidEmail(email!)
                    ? constants.FailureProcess.invalidEmail
                    : null,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                cursorColor: constants.ForgotPasswordScreenConstants.mainTheme,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      top: spacingAboveOfTexts, bottom: spacingBelowOfTexts),
                  isDense: true,
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: constants.ForgotPasswordScreenConstants.mainTheme,
                      width: 2,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: constants
                        .ForgotPasswordScreenConstants.textFieldTextColor)),
            SizedBox(
              height: spaceBetweenItems,
            ),
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      constants.ForgotPasswordScreenConstants.mainTheme),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
                ),
                onPressed: () => {
                  if (_resetformKey.currentState!.validate())
                    {
                      context
                          .read<ForgotPasswordBloc>()
                          .add(ForgotRequested(_emailController.text.trim())),
                    }
                },
                child: Text(constants.ForgotPasswordScreenConstants.sendButton,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: constants.ForgotPasswordScreenConstants
                            .sendButtonTextColor)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              child: Center(
                child: Text(
                  'Back To Login',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: constants.ColorsConstant.primaryColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w200),
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }
}
