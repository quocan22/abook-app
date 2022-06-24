import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/src/blocs/cart/cart_bloc.dart';
import 'package:client/src/blocs/cart/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../models/book.dart';

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.book.imageUrl,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
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
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          '${widget.book.price} VNĐ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                    onTap: () {},
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
