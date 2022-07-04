import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/profile/profile_bloc.dart';
import '../blocs/profile/profile_event.dart';
import '../blocs/profile/profile_state.dart';
import '../blocs/user_claim/user_claim_bloc.dart';
import '../blocs/user_claim/user_claim_event.dart';
import '../blocs/user_claim/user_claim_state.dart';
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
  late File _imageFile;
  bool isFileNull = true;
  bool isDeleteProfileImage = false;
  final _formKey = GlobalKey<FormState>();
  ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

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
                      Center(
                        child: SizedBox(
                          height: 115,
                          width: 115,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              isDeleteProfileImage
                                  ? CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: AssetImage(
                                          'assets/images/app_logo_no_bg.png'))
                                  : isFileNull
                                      ? CircleAvatar(
                                          radius: 50.0,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  state.userClaim!.avatarUrl))
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.file(
                                            _imageFile,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                              Positioned(
                                  bottom: -10,
                                  right: -25,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      _changeProfileImage(context);
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white70,
                                    //fillColor: Color(0x60FFFFFF),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    shape: CircleBorder(),
                                  )),
                            ],
                          ),
                        ),
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
                                  if (isDeleteProfileImage) {
                                    context.read<ProfileBloc>().add(
                                        ProfileUpdated(
                                            fullName: _fullName,
                                            address: _address,
                                            phoneNumber: _phone,
                                            userId: widget.userId,
                                            isProfileImageRemoved: true));
                                    Navigator.of(context).maybePop();
                                  } else if (isFileNull) {
                                    context.read<ProfileBloc>().add(
                                        ProfileUpdated(
                                            fullName: _fullName,
                                            address: _address,
                                            phoneNumber: _phone,
                                            userId: widget.userId,
                                            isProfileImageRemoved: false));
                                    Navigator.of(context).maybePop();
                                  } else {
                                    context.read<ProfileBloc>().add(
                                        ProfileUpdated(
                                            profileImage: _imageFile,
                                            fullName: _fullName,
                                            address: _address,
                                            phoneNumber: _phone,
                                            userId: widget.userId,
                                            isProfileImageRemoved: false));
                                    Navigator.of(context).maybePop();
                                  }
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

  _changeProfileImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 285,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Change Profile Image',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorsConstant.primaryColor,
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConstant.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          getImageGallery();
                        },
                        child: Text(
                          'From Gallery',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConstant.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          getImageCamera();
                        },
                        child: Text(
                          'From Camera',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConstant.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            isDeleteProfileImage = true;
                            isFileNull = true;
                          });
                        },
                        child: Text(
                          'Remove Current Profile Image',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConstant.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  getImageGallery() async {
    PickedFile? imageFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
        isFileNull = false;
        isDeleteProfileImage = false;
      });
    }
  }

  getImageCamera() async {
    PickedFile? imageFile =
        await imagePicker.getImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
        isFileNull = false;
        isDeleteProfileImage = false;
      });
    }
  }
}
