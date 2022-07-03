import 'package:equatable/equatable.dart';

import '../../models/address_book.dart';

abstract class AddressBookEvent extends Equatable {
  const AddressBookEvent();

  @override
  List<Object?> get props => [];
}

class AddressBookRequested extends AddressBookEvent {
  final String userId;

  const AddressBookRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AddressBookAdded extends AddressBookEvent {
  final String userId;
  final String fullName;
  final String address;
  final String phoneNumber;

  AddressBookAdded({
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    required this.userId,
  });

  @override
  List<Object?> get props => [userId, fullName, phoneNumber, address];
}

class AddressBookUpdated extends AddressBookEvent {
  final String userId;
  final List<AddressBook>? addressBookList;

  AddressBookUpdated({required this.userId, this.addressBookList});

  @override
  List<Object?> get props => [userId, addressBookList];
}
