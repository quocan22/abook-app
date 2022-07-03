import 'package:equatable/equatable.dart';

import '../../models/address_book.dart';

abstract class AddressBookState extends Equatable {
  const AddressBookState();

  @override
  List<Object?> get props => [];
}

class AddressBookInitial extends AddressBookState {}

class AddressBookLoadInProgress extends AddressBookState {}

class AddressBookLoadFailure extends AddressBookState {
  final String? errorMessage;

  const AddressBookLoadFailure({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class AddressBookLoadSuccess extends AddressBookState {
  final List<AddressBook>? addressBookList;

  const AddressBookLoadSuccess({this.addressBookList});

  @override
  List<Object?> get props => [addressBookList];
}
