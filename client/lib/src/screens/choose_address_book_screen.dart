import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../blocs/address_book/address_book_bloc.dart';
import '../blocs/address_book/address_book_event.dart';
import '../blocs/address_book/address_book_state.dart';
import '../constants/constants.dart';
import '../widgets/address_book_item.dart';
import './add_or_update_address_book_screen.dart';

class ChooseAddressBookScreen extends StatefulWidget {
  final String userId;

  const ChooseAddressBookScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  State<ChooseAddressBookScreen> createState() =>
      _ChooseAddressBookScreenState();
}

class _ChooseAddressBookScreenState extends State<ChooseAddressBookScreen> {
  bool orderConfirmed = false;

  Future<void> _showOrderConfirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'chooseAddressBookScreen.confirmOrderMsg'.tr(),
            style: TextStyle(color: Colors.blue),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).maybePop();
                setState(() {
                  orderConfirmed = true;
                });
              },
              child: Text('chooseAddressBookScreen.yes'.tr()),
              color: ColorsConstant.primaryColor,
              textColor: Colors.white,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              child: Text('chooseAddressBookScreen.no'.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<AddressBookBloc>()
        .add(AddressBookRequested(userId: widget.userId));
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'chooseAddressBookScreen.myAddress'.tr(),
            style: Theme.of(context).textTheme.headline4?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsConstant.primaryColor,
                ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: BlocBuilder<AddressBookBloc, AddressBookState>(
              builder: (context, state) {
                if (state is AddressBookLoadInProgress) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is AddressBookLoadSuccess) {
                  if (state.addressBookList == null) {
                    return Center(
                      child: Text('chooseAddressBookScreen.errorMsg'.tr()),
                    );
                  } else if (state.addressBookList!.isEmpty) {
                    return Center(
                      child: Text('chooseAddressBookScreen.noAddressBook'.tr()),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                          itemCount: state.addressBookList!.length,
                          itemBuilder: (context, index) {
                            return AddressBookItem(
                                isRemovable: false,
                                onTap: () async {
                                  await _showOrderConfirmDialog();
                                  if (orderConfirmed) {
                                    Navigator.of(context).maybePop(state
                                        .addressBookList!
                                        .elementAt(index));
                                  }
                                },
                                addressBook:
                                    state.addressBookList!.elementAt(index));
                          }),
                    );
                  }
                }
                return Center(
                  child: Text('chooseAddressBookScreen.errorMsg'.tr()),
                );
              },
            )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        ColorsConstant.primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AddOrUpdateAddressBookScreen(
                              userId: widget.userId,
                              isNew: true,
                            )));
                  },
                  child: Text(
                    'chooseAddressBookScreen.addNewAddress'.tr(),
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
