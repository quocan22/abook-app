import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart' as constants;
import '../utils/validators.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    const double _signUpFormSpacing = 30.0;
    const _textFieldContentPadding = EdgeInsets.only(top: 15.0, bottom: 5.0);

    double _titleTextFormFieldFontSize = 15.5;
    double _textFormFieldFontSize = 19;

    FontWeight _titleTextFormFieldFontWeight = FontWeight.w300;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.headline4?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: constants.ColorsConstant.primaryColor,
                ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0.0, 5.0),
                      )
                    ],
                  ),
                  child: const CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1617975251517-b90ff061b52e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80')),
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(constants.SignUpScreenConstants.fullName,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: constants.ColorsConstant.textFieldTitle,
                            fontSize: _titleTextFormFieldFontSize,
                            fontWeight: _titleTextFormFieldFontWeight)),
                    TextFormField(
                      autofocus: true,
                      validator: (value) => fullNameValidate(value),
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            constants.SignUpScreenConstants.fullNameTextLimit),
                        FilteringTextInputFormatter.allow(
                            Validators.textOnlyRegExp)
                      ],
                      cursorColor: constants.ColorsConstant.primaryColor,
                      decoration: InputDecoration(
                        contentPadding: _textFieldContentPadding,
                        errorStyle:
                            Theme.of(context).textTheme.bodyText2!.copyWith(
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
                      textInputAction: TextInputAction.done,
                      cursorColor: constants.ColorsConstant.primaryColor,
                      decoration: InputDecoration(
                        contentPadding: _textFieldContentPadding,
                        errorStyle:
                            Theme.of(context).textTheme.bodyText2!.copyWith(
                                  color: Colors.red,
                                ),
                      ),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: constants.ColorsConstant.textField,
                          fontSize: _textFormFieldFontSize),
                    ),
                    const SizedBox(height: _signUpFormSpacing),
                    Text('Confirm Password',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: constants.ColorsConstant.textFieldTitle,
                            fontSize: _titleTextFormFieldFontSize,
                            fontWeight: _titleTextFormFieldFontWeight)),
                    TextFormField(
                      obscureText: true,
                      validator: (value) => passwordValidate(value),
                      textInputAction: TextInputAction.done,
                      cursorColor: constants.ColorsConstant.primaryColor,
                      decoration: InputDecoration(
                        contentPadding: _textFieldContentPadding,
                        errorStyle:
                            Theme.of(context).textTheme.bodyText2!.copyWith(
                                  color: Colors.red,
                                ),
                      ),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Update',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
