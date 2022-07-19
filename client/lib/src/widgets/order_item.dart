import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../constants/constants.dart';
import '../models/order.dart';
import '../screens/order_details_screen.dart';
import '../utils/format_rules.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    String id = order.id;
    String billId =
        '${id[0]}${id[1]}${id[2]}...${id[id.length - 3]}${id[id.length - 2]}${id[id.length - 1]}';
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '${'orderItem.billNo'.tr()}: $billId',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    '${'orderItem.orderAt'.tr()}: ${DateFormat('dd/MM/yyyy – hh:mm').format(order.createdAt)}',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    '${'orderItem.totalBooks'.tr()}: ${order.details.length}',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
            ),
            order.shippingStatus == 1
                ? Chip(
                    label: Text('orderItem.shipping'.tr()),
                    backgroundColor: Colors.yellow)
                : order.shippingStatus == 2
                    ? Chip(
                        label: Text('orderItem.completed'.tr()),
                        backgroundColor: Colors.greenAccent)
                    : Chip(
                        label: Text('orderItem.cancelled'.tr()),
                        backgroundColor: Colors.redAccent)
          ],
        ),
        Row(
          children: [
            Text(
              'orderItem.totalPrice'.tr(),
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            Spacer(),
            Text(
              FormatRules.formatPrice(order.totalPrice),
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    for (var i = 0; i < order.details.length; i++) {
                      context.read<CartBloc>().add(CartBookAdded(
                          userId: order.userId,
                          bookId: order.details[i]['bookId'],
                          quantity: order.details[i]['quantity']));
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('orderItem.addBookToCartMsg'.tr())));
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: ColorsConstant.primaryColor))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    'orderItem.buyAgain'.tr(),
                    style: TextStyle(color: ColorsConstant.primaryColor),
                  )),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            OrderDetailsScreen(details: order.details)));
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: ColorsConstant.primaryColor))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    'orderItem.details'.tr(),
                    style: TextStyle(color: ColorsConstant.primaryColor),
                  )),
            ),
          ],
        )
      ],
    );
  }
}
