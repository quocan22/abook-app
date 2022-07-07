import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/address_book/address_book_bloc.dart';
import '../blocs/address_book/address_book_event.dart';
import '../constants/constants.dart' as constants;
import '../models/address_book.dart';
import '../utils/validators.dart';

class AddOrUpdateAddressBookScreen extends StatefulWidget {
  final AddressBook? addressBook;
  final bool? isNew;
  final String userId;

  const AddOrUpdateAddressBookScreen(
      {Key? key, this.addressBook, this.isNew, required this.userId})
      : super(key: key);

  @override
  State<AddOrUpdateAddressBookScreen> createState() =>
      _AddOrUpdateAddressBookScreenState();
}

class _AddOrUpdateAddressBookScreenState
    extends State<AddOrUpdateAddressBookScreen> {
  String _fullName = '';
  String _address = '';
  String _phone = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.addressBook != null) {
      _fullName = widget.addressBook!.fullName;
      _address = widget.addressBook!.address;
      _phone = widget.addressBook!.phoneNumber;
    }
  }

  String? fullNameValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return constants.FailureProcess.invalidFullName;
    }
    return null;
  }

  String? phoneNumberValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone Number cannot be left blank';
    }
    return null;
  }

  String? addressValidate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address cannot be left blank';
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          (widget.isNew != null && widget.isNew == true)
              ? 'Add New Address'
              : 'Update Address',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(constants.SignUpScreenConstants.fullName,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: constants.ColorsConstant.textFieldTitle,
                      fontSize: _titleTextFormFieldFontSize,
                      fontWeight: _titleTextFormFieldFontWeight)),
              TextFormField(
                initialValue: widget.addressBook != null
                    ? widget.addressBook!.fullName
                    : '',
                onChanged: (value) => _fullName = value,
                validator: (value) => fullNameValidate(value),
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
              Text('Phone Number',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: constants.ColorsConstant.textFieldTitle,
                      fontSize: _titleTextFormFieldFontSize,
                      fontWeight: _titleTextFormFieldFontWeight)),
              TextFormField(
                initialValue: widget.addressBook != null
                    ? widget.addressBook!.phoneNumber
                    : '',
                onChanged: (value) => _phone = value,
                validator: (value) => phoneNumberValidate(value),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      constants.SignUpScreenConstants.fullNameTextLimit),
                  FilteringTextInputFormatter.allow(Validators.numberOnlyRegExp)
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
              Text('Address',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: constants.ColorsConstant.textFieldTitle,
                      fontSize: _titleTextFormFieldFontSize,
                      fontWeight: _titleTextFormFieldFontWeight)),
              TextFormField(
                initialValue: widget.addressBook != null
                    ? widget.addressBook!.address
                    : '',
                onChanged: (value) => _address = value,
                validator: (value) => addressValidate(value),
                textInputAction: TextInputAction.done,
                cursorColor: constants.ColorsConstant.primaryColor,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1000),
                  FilteringTextInputFormatter.allow(Validators.textOnlyRegExp)
                ],
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
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.isNew != null && widget.isNew!) {
                        context.read<AddressBookBloc>().add(AddressBookAdded(
                            fullName: _fullName,
                            address: _address,
                            phoneNumber: _phone,
                            userId: widget.userId));
                        Navigator.of(context).maybePop();
                      } else {}
                      Navigator.of(context).maybePop(AddressBook(
                          fullName: _fullName,
                          phoneNumber: _phone,
                          address: _address));
                    }
                  },
                  child: Text(
                    'Save',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
