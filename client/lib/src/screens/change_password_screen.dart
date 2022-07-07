import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/profile/profile_bloc.dart';
import '../blocs/profile/profile_event.dart';
import '../blocs/profile/profile_state.dart';
import '../blocs/user_claim/user_claim_bloc.dart';
import '../blocs/user_claim/user_claim_event.dart';
import '../blocs/user_claim/user_claim_state.dart';
import '../constants/constants.dart' as constants;
import '../utils/validators.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String userId;

  const ChangePasswordScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String _oldPassword = '';
  String _newPassword = '';
  String _repeatNewPassword = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  String? passwordValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password cannot be left blank';
    }
    if (!Validators.isValidPassword(value)) {
      return constants.FailureProcess.invalidPassword;
    }
    return null;
  }

  String? repeatPasswordCheck(String? newPass) {
    if (newPass == null || newPass.trim().isEmpty) {
      return 'Please repeat your new password';
    }
    if (newPass != _newPassword) {
      return 'Not match';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    const double _signUpFormSpacing = 30.0;
    const _textFieldContentPadding = EdgeInsets.only(top: 15.0, bottom: 5.0);

    double _titleTextFormFieldFontSize = 15.5;
    double _textFormFieldFontSize = 19;

    FontWeight _titleTextFormFieldFontWeight = FontWeight.w300;

    context
        .read<UserClaimBloc>()
        .add(UserClaimRequested(userId: widget.userId));

    return BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            if (state.msg != null ||
                state.msg != 'Change password successfully') {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Change Password Fail')));
            } else {
              context
                  .read<UserClaimBloc>()
                  .add(UserClaimRequested(userId: widget.userId));
              Navigator.of(context).maybePop();
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'Change Your Password',
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: constants.ColorsConstant.primaryColor,
                  ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
              child: BlocBuilder<UserClaimBloc, UserClaimState>(
            builder: (context, state) {
              if (state is UserClaimLoadSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current Password',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color:
                                        constants.ColorsConstant.textFieldTitle,
                                    fontSize: _titleTextFormFieldFontSize,
                                    fontWeight: _titleTextFormFieldFontWeight)),
                        TextFormField(
                          initialValue: _oldPassword,
                          onChanged: (value) => _oldPassword = value,
                          obscureText: true,
                          validator: (value) => passwordValidate(value),
                          textInputAction: TextInputAction.next,
                          cursorColor: constants.ColorsConstant.primaryColor,
                          decoration: InputDecoration(
                            contentPadding: _textFieldContentPadding,
                            errorStyle:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Colors.red,
                                    ),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: constants.ColorsConstant.textField,
                                  fontSize: _textFormFieldFontSize),
                        ),
                        const SizedBox(height: _signUpFormSpacing),
                        Text('New Password',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color:
                                        constants.ColorsConstant.textFieldTitle,
                                    fontSize: _titleTextFormFieldFontSize,
                                    fontWeight: _titleTextFormFieldFontWeight)),
                        TextFormField(
                          initialValue: _newPassword,
                          onChanged: (value) => _newPassword = value,
                          textInputAction: TextInputAction.next,
                          cursorColor: constants.ColorsConstant.primaryColor,
                          validator: (value) => passwordValidate(value),
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: _textFieldContentPadding,
                            errorStyle:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Colors.red,
                                    ),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: constants.ColorsConstant.textField,
                                  fontSize: _textFormFieldFontSize),
                        ),
                        const SizedBox(height: _signUpFormSpacing),
                        Text('Repeat Your New Password',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color:
                                        constants.ColorsConstant.textFieldTitle,
                                    fontSize: _titleTextFormFieldFontSize,
                                    fontWeight: _titleTextFormFieldFontWeight)),
                        TextFormField(
                          obscureText: true,
                          initialValue: _repeatNewPassword,
                          onChanged: (value) => _repeatNewPassword = value,
                          textInputAction: TextInputAction.done,
                          cursorColor: constants.ColorsConstant.primaryColor,
                          validator: (value) => repeatPasswordCheck(value),
                          decoration: InputDecoration(
                            contentPadding: _textFieldContentPadding,
                            errorStyle:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Colors.red,
                                    ),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: constants.ColorsConstant.textField,
                                  fontSize: _textFormFieldFontSize),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  constants.ColorsConstant.primaryColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ProfileBloc>().add(
                                    ProfilePasswordChanged(
                                        oldPassword: _oldPassword,
                                        newPassword: _newPassword,
                                        userId: widget.userId));
                              }
                            },
                            child: Text(
                              'Update Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
        ));
  }
}
