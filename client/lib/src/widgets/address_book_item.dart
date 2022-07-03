import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/address_book.dart';

class AddressBookItem extends StatefulWidget {
  final AddressBook addressBook;
  final VoidCallback? onTap;
  final bool? isRemovable;
  final VoidCallback? onRemove;

  const AddressBookItem(
      {Key? key,
      required this.addressBook,
      this.onTap,
      this.isRemovable,
      this.onRemove})
      : super(key: key);

  @override
  State<AddressBookItem> createState() => _AddressBookItemState();
}

class _AddressBookItemState extends State<AddressBookItem> {
  Future<void> _showRemoveAddressConfirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Do you want to remove this address?',
            style: TextStyle(color: Colors.blue),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: widget.onRemove,
              child: Text('Yes'),
              color: ColorsConstant.primaryColor,
              textColor: Colors.white,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        // height: 100,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.addressBook.fullName,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          widget.addressBook.phoneNumber,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          widget.addressBook.address,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.isRemovable ?? true,
                    child: InkWell(
                      onTap: () {
                        _showRemoveAddressConfirmDialog();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
