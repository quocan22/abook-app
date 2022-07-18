import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_state.dart';
import '../constants/constants.dart';
import '../models/book.dart';
import '../widgets/order_detail_item.dart';

class OrderDetailsScreen extends StatefulWidget {
  final List<dynamic> details;

  const OrderDetailsScreen({Key? key, required this.details}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'orderDetailScreen.orderDetailTitle'.tr(),
          style: Theme.of(context).textTheme.headline4?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsConstant.primaryColor,
              ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookLoadSuccess) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    Book book = state.books!
                        .where((e) => e.id == widget.details[index]['bookId'])
                        .first;
                    return OrderDetailItem(
                        book: book,
                        quantity: widget.details[index]['quantity']);
                  },
                  shrinkWrap: true,
                  itemCount: widget.details.length),
            );
          }
          return Center(
            child: Text('orderDetailScreen.errorMsg'.tr()),
          );
        },
      ),
    );
  }
}
