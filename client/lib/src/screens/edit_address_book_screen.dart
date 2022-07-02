import 'package:client/src/models/address_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/address_book/address_book_bloc.dart';
import '../blocs/address_book/address_book_event.dart';
import '../blocs/address_book/address_book_state.dart';
import '../constants/constants.dart';
import '../widgets/address_book_item.dart';
import './add_or_update_address_book_screen.dart';

class EditAddressBookScreen extends StatefulWidget {
  final String userId;

  const EditAddressBookScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  State<EditAddressBookScreen> createState() => _EditAddressBookScreenState();
}

class _EditAddressBookScreenState extends State<EditAddressBookScreen> {
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
            'My Address',
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
                      child:
                          Text('We have any errors when get address book list'),
                    );
                  } else if (state.addressBookList!.isEmpty) {
                    return Center(
                      child: Text('We don\'t have any address book'),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                          itemCount: state.addressBookList!.length,
                          itemBuilder: (context, index) {
                            return AddressBookItem(
                                onRemove: () {
                                  context.read<AddressBookBloc>().add(
                                      AddressBookUpdated(
                                          userId: widget.userId,
                                          addressBookList: state
                                              .addressBookList!
                                              .where((e) =>
                                                  e !=
                                                  state.addressBookList!
                                                      .elementAt(index))
                                              .toList()));
                                  Navigator.of(context).pop();
                                },
                                onTap: () async {
                                  var addressBook = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (_) =>
                                              AddOrUpdateAddressBookScreen(
                                                userId: widget.userId,
                                                addressBook: state
                                                    .addressBookList!
                                                    .elementAt(index),
                                                isNew: false,
                                              )));

                                  if (addressBook != null) {
                                    List<AddressBook> newAddressList = state
                                        .addressBookList!
                                        .where((e) =>
                                            e !=
                                            state.addressBookList!
                                                .elementAt(index))
                                        .toList();
                                    newAddressList.add(addressBook);

                                    context.read<AddressBookBloc>().add(
                                        AddressBookUpdated(
                                            userId: widget.userId,
                                            addressBookList: newAddressList));
                                  }
                                },
                                addressBook:
                                    state.addressBookList!.elementAt(index));
                          }),
                    );
                  }
                }
                return Center(
                  child: Text('We have any errors when get address book list'),
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
                    'Add New Address',
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
