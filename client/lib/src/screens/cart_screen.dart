import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/discount/discount_bloc.dart';
import '../blocs/discount/discount_event.dart';
import '../blocs/discount/discount_state.dart';
import '../blocs/order/order_bloc.dart';
import '../blocs/order/order_event.dart';
import '../constants/constants.dart';
import '../models/address_book.dart';
import '../models/book.dart';
import '../utils/format_rules.dart';
import '../widgets/book_cart_item.dart';
import '../widgets/book_search_delegate.dart';
import 'choose_address_book_screen.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  const CartScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin<CartScreen> {
  var _discountTextFieldController = TextEditingController();
  var _appliedDiscount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.read<DiscountBloc>().add(DiscountRequested());
    context.read<CartBloc>().add(CartDetailRequested(userId: widget.userId));
    return Scaffold(
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
                  showSearch(context: context, delegate: BookSearchDelegate());
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
                      if (bookList[i].discountRatio == 0) {
                        totalPrice += bookList[i].price * quantity[i];
                      } else {
                        totalPrice += bookList[i].price *
                            (100 - bookList[i].discountRatio) *
                            quantity[i] ~/
                            100;
                      }
                    }
                    totalPrice -= _appliedDiscount;

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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BlocBuilder<DiscountBloc, DiscountState>(
                                  builder: (context, state) {
                                    if (state is DiscountLoadSuccess) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      4.0, 0, 4.0, 0),
                                              child: SizedBox(
                                                height: 35,
                                                child: TextField(
                                                  controller:
                                                      _discountTextFieldController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Discount code',
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: ColorsConstant
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                if (_appliedDiscount == 0) {
                                                  if (state.discounts!
                                                      .map((e) => e.code)
                                                      .contains(
                                                          _discountTextFieldController
                                                              .text
                                                              .trim())) {
                                                    if (DateTime.now()
                                                            .compareTo(state
                                                                .discounts!
                                                                .where((e) =>
                                                                    e.code ==
                                                                    _discountTextFieldController
                                                                        .text
                                                                        .trim())
                                                                .first
                                                                .expiredDate) <
                                                        0) {
                                                      setState(() {
                                                        _appliedDiscount = state
                                                            .discounts!
                                                            .where((e) =>
                                                                e.code ==
                                                                _discountTextFieldController
                                                                    .text
                                                                    .trim())
                                                            .first
                                                            .value;
                                                      });
                                                    } else {
                                                      _discountTextFieldController
                                                          .clear();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  'This code is not valid or out of date')));
                                                    }
                                                  } else {
                                                    _discountTextFieldController
                                                        .clear();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                'This code is not valid or out of date')));
                                                  }
                                                } else {
                                                  _discountTextFieldController
                                                      .clear();
                                                  setState(() {
                                                    _appliedDiscount = 0;
                                                  });
                                                }
                                              },
                                              style: ButtonStyle(
                                                elevation: MaterialStateProperty
                                                    .all<double>(0),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                )),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        ColorsConstant
                                                            .primaryColor),
                                              ),
                                              child: _appliedDiscount == 0
                                                  ? Text('Apply')
                                                  : Text('Clear')),
                                        ],
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Visibility(
                                  visible: _appliedDiscount != 0,
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                        '-${FormatRules.formatPrice(_appliedDiscount)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
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
                                      FormatRules.formatPrice(totalPrice),
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
                                          MaterialStateProperty.all<Color>(
                                              ColorsConstant.primaryColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                    ),
                                    onPressed: () async {
                                      AddressBook? addressBook =
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ChooseAddressBookScreen(
                                                          userId:
                                                              widget.userId)));

                                      if (addressBook != null) {
                                        context.read<OrderBloc>().add(
                                            OrderCreated(
                                                userId: widget.userId,
                                                discountPrice: _appliedDiscount,
                                                addressBook: addressBook));
                                        context.read<OrderBloc>().add(
                                            OrderRequested(
                                                userId: widget.userId));
                                      }
                                    },
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
                          ))
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
