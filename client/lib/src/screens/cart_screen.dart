import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../constants/constants.dart';
import '../models/book.dart';
import '../widgets/book_cart_item.dart';
import '../widgets/book_search_delegate.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  const CartScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(CartDetailRequested(userId: widget.userId));
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.95),
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                image: AssetImage('assets/images/app_logo_no_bg.png'),
                width: 24,
                height: 24,
              ),
              Text(
                'Cart',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsConstant.primaryColor,
                    ),
              ),
              InkWell(
                  onTap: () {
                    showSearch(
                        context: context, delegate: BookSearchDelegate());
                  },
                  child: Icon(Icons.search, color: Colors.black))
            ],
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoadInProgress) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
            if (state is CartLoadFailure) {
              return const Center(
                child: Text('You don\'t have any books in your cart'),
              );
            }
            if (state is CartLoadSuccess) {
              if (state.cartDetailList != null &&
                  state.cartDetailList!.isNotEmpty) {
                List<dynamic>? cartDetailList = state.cartDetailList;
                return BlocBuilder<BookBloc, BookState>(
                  builder: (context, state) {
                    if (state is BookLoadSuccess) {
                      List<Book> bookList = [];
                      List<int> quantity = [];
                      for (var i = 0; i < cartDetailList!.length; i++) {
                        if (state.books!
                            .where((e) => e.id == cartDetailList[i]['bookId'])
                            .isNotEmpty) {
                          bookList.add(state.books!
                              .where((e) => e.id == cartDetailList[i]['bookId'])
                              .first);
                          quantity.add(cartDetailList[i]['quantity']);
                        }
                      }

                      int totalPrice = 0;
                      for (var i = 0; i < bookList.length; i++) {
                        totalPrice += bookList[i].price * quantity[i];
                      }

                      return Stack(children: [
                        Container(
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                            child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return BookCartItem(
                                      userId: widget.userId,
                                      book: bookList[index],
                                      quantity: cartDetailList[index]
                                          ['quantity']);
                                },
                                shrinkWrap: true,
                                itemCount: bookList.length)),
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: AnimatedContainer(
                                height: 125,
                                duration: Duration(milliseconds: 100),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 8,
                                            offset: Offset(0, 3)),
                                      ],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0)),
                                      color: Colors.white),
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Total price',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${totalPrice} VNĐ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(ColorsConstant
                                                        .primaryColor),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            )),
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            'Check Out',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )))
                      ]);
                    } else {
                      return const Center(
                        child: Text('ERROR'),
                      );
                    }
                  },
                );
              } else {
                return const Center(
                  child: Text('You don\'t have any books in your cart'),
                );
              }
            }
            //temp screen
            return const Center(
              child: Text('BLOC NO STATE'),
            );
          },
        ),
      ),
    );
  }
}
