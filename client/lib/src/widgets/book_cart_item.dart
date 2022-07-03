import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../constants/constants.dart';
import '../models/book.dart';
import '../utils/format_rules.dart';

class BookCartItem extends StatefulWidget {
  final Book book;
  final int quantity;
  final String userId;

  const BookCartItem({
    Key? key,
    required this.book,
    required this.quantity,
    required this.userId,
  }) : super(key: key);

  @override
  State<BookCartItem> createState() => _BookCartItemState();
}

class _BookCartItemState extends State<BookCartItem> {
  Future<void> _showRemoveBookConfirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Do you want to remove this book from your cart?',
            style: TextStyle(color: Colors.blue),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(widget.book.name),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                context.read<CartBloc>().add(CartBookRemoved(
                    userId: widget.userId, bookId: widget.book.id));
                Navigator.of(context).pop();
              },
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
        height: 100,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.book.imageUrl,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.name,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          FormatRules.formatPrice(widget.book.price),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize:
                                (widget.book.discountRatio == 0) ? 15 : 10,
                            decoration: (widget.book.discountRatio == 0)
                                ? TextDecoration.none
                                : TextDecoration.lineThrough,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Visibility(
                          visible: widget.book.discountRatio != 0,
                          child: Text(
                            FormatRules.formatPrice(widget.book.price *
                                (100 - widget.book.discountRatio) ~/
                                100),
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (widget.quantity == 1) return;
                                context.read<CartBloc>().add(
                                    CartBookQuantityChanged(
                                        userId: widget.userId,
                                        bookId: widget.book.id,
                                        newQuantity: widget.quantity - 1));
                              },
                              child: Icon(
                                Icons.remove_circle_outline,
                                color: widget.quantity == 1
                                    ? Colors.black12
                                    : Colors.black54,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              widget.quantity.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black87),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                context.read<CartBloc>().add(
                                    CartBookQuantityChanged(
                                        userId: widget.userId,
                                        bookId: widget.book.id,
                                        newQuantity: widget.quantity + 1));
                              },
                              child: Icon(
                                Icons.add_circle_outline,
                                color: Colors.black54,
                                size: 20,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  InkWell(
                    onTap: () {
                      _showRemoveBookConfirmDialog();
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
