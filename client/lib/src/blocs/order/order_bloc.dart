import 'package:bloc/bloc.dart';

import '../../models/order.dart';
import '../../services/order_service/order_service.dart';
import './order_event.dart';
import './order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderService service;

  OrderBloc({required this.service}) : super(OrderInitial()) {
    on<OrderRequested>((event, emit) async {
      emit(OrderLoadInProgress());
      try {
        List<Order>? orders = await service.getOrderListByUserId(event.userId);

        emit(OrderLoadSuccess(orderList: orders));
      } catch (e) {
        emit(OrderLoadFailure(errorMessage: e.toString()));
      }
    });
    on<OrderCreated>((event, emit) async {
      emit(OrderLoadInProgress());
      try {
        String? msg = await service.createNewOrder(
            event.userId, event.discountPrice, event.addressBook);

        if (msg == 'Create order successfully') {
          emit(OrderLoadSuccess(
              orderList: await service.getOrderListByUserId(event.userId)));
        } else {
          emit(OrderLoadFailure(errorMessage: 'Create order failed'));
        }
      } catch (e) {
        emit(OrderLoadFailure(errorMessage: e.toString()));
      }
    });
  }
}
