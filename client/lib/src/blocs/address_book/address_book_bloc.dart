import 'package:bloc/bloc.dart';

import '../../models/address_book.dart';
import '../../services/user_service/user_service.dart';
import './address_book_event.dart';
import './address_book_state.dart';

class AddressBookBloc extends Bloc<AddressBookEvent, AddressBookState> {
  final UserService service;

  AddressBookBloc({required this.service}) : super(AddressBookInitial()) {
    on<AddressBookRequested>((event, emit) async {
      emit(AddressBookLoadInProgress());
      try {
        List<AddressBook>? addressBookList =
            await service.getAddressBookByUserId(event.userId);

        emit(AddressBookLoadSuccess(addressBookList: addressBookList));
      } catch (e) {
        emit(AddressBookLoadFailure(errorMessage: e.toString()));
      }
    });
    on<AddressBookAdded>((event, emit) async {
      emit(AddressBookLoadInProgress());
      try {
        String? msg = await service.addAddressBook(
            event.userId, event.fullName, event.address, event.phoneNumber);

        if (msg == 'Add address to address book successfully') {
          emit(AddressBookLoadSuccess(
              addressBookList:
                  await service.getAddressBookByUserId(event.userId)));
        } else {
          emit(AddressBookLoadFailure(
              errorMessage: 'Add addressBook to userClaim failed'));
        }
      } catch (e) {
        emit(AddressBookLoadFailure(errorMessage: e.toString()));
      }
    });
    on<AddressBookUpdated>((event, emit) async {
      emit(AddressBookLoadInProgress());
      try {
        String? msg = await service.updateAddressBookForUser(
            event.userId, event.addressBookList);

        if (msg == 'Update address book successfully') {
          emit(AddressBookLoadSuccess(
              addressBookList:
                  await service.getAddressBookByUserId(event.userId)));
        } else {
          emit(AddressBookLoadFailure(
              errorMessage: 'update addressBook list failed'));
        }
      } catch (e) {
        emit(AddressBookLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
