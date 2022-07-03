import 'package:bloc/bloc.dart';

import '../../models/discount.dart';
import '../../services/discount_service/discount_service.dart';
import './discount_event.dart';
import './discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final DiscountService service;

  DiscountBloc({required this.service}) : super(DiscountInitial()) {
    on<DiscountRequested>((event, emit) async {
      emit(DiscountLoadInProgress());
      try {
        List<Discount>? discounts = await service.getAllDiscount();
        emit(DiscountLoadSuccess(discounts: discounts));
      } catch (e) {
        emit(DiscountLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
