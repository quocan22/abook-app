import 'package:client/src/blocs/profile/profile_bloc.dart';
import 'package:client/src/blocs/profile/profile_event.dart';
import 'package:client/src/blocs/profile/profile_state.dart';
import 'package:client/src/blocs/user_claim/user_claim_bloc.dart';
import 'package:client/src/blocs/user_claim/user_claim_event.dart';
import 'package:client/src/blocs/user_claim/user_claim_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart' as constants;
import '../utils/validators.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  const EditProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _fullName = '';
  String _address = '';
  String _phone = '';
  final _formKey = GlobalKey<FormState>();

  String? fullNameValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return constants.FailureProcess.invalidFullName;
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
          context
              .read<UserClaimBloc>()
              .add(UserClaimRequested(userId: widget.userId));
          Navigator.of(context).maybePop();
        }
      },
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
            child: BlocBuilder<UserClaimBloc, UserClaimState>(
          builder: (context, state) {
            if (state is UserClaimLoadSuccess) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
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
                        child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                NetworkImage(state.userClaim!.avatarUrl)),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(constants.SignUpScreenConstants.fullName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: constants
                                          .ColorsConstant.textFieldTitle,
                                      fontSize: _titleTextFormFieldFontSize,
                                      fontWeight:
                                          _titleTextFormFieldFontWeight)),
                          TextFormField(
                            initialValue: state.userClaim!.displayName,
                            onChanged: (value) => _fullName = value,
                            autofocus: true,
                            validator: (value) => fullNameValidate(value),
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(constants
                                  .SignUpScreenConstants.fullNameTextLimit),
                              FilteringTextInputFormatter.allow(
                                  Validators.textOnlyRegExp)
                            ],
                            cursorColor: constants.ColorsConstant.primaryColor,
                            decoration: InputDecoration(
                              contentPadding: _textFieldContentPadding,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
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
                          Text('Address',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: constants
                                          .ColorsConstant.textFieldTitle,
                                      fontSize: _titleTextFormFieldFontSize,
                                      fontWeight:
                                          _titleTextFormFieldFontWeight)),
                          TextFormField(
                            initialValue: state.userClaim!.address,
                            onChanged: (value) => _address = value,
                            textInputAction: TextInputAction.next,
                            cursorColor: constants.ColorsConstant.primaryColor,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(constants
                                  .SignUpScreenConstants.fullNameTextLimit),
                              FilteringTextInputFormatter.allow(
                                  Validators.textOnlyRegExp)
                            ],
                            decoration: InputDecoration(
                              contentPadding: _textFieldContentPadding,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
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
                          Text('Phone Number',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: constants
                                          .ColorsConstant.textFieldTitle,
                                      fontSize: _titleTextFormFieldFontSize,
                                      fontWeight:
                                          _titleTextFormFieldFontWeight)),
                          TextFormField(
                            initialValue: state.userClaim!.phoneNumber,
                            onChanged: (value) => _phone = value,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(constants
                                  .SignUpScreenConstants.fullNameTextLimit),
                              FilteringTextInputFormatter.allow(
                                  Validators.numberOnlyRegExp)
                            ],
                            cursorColor: constants.ColorsConstant.primaryColor,
                            decoration: InputDecoration(
                              contentPadding: _textFieldContentPadding,
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
                                      ProfileUpdated(
                                          fullName: _fullName,
                                          address: _address,
                                          phoneNumber: _phone,
                                          userId: widget.userId));
                                }
                              },
                              child: Text(
                                'Update',
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
      ),
    );
  }
}
