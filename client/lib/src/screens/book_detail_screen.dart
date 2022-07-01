import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/book_detail/book_detail_bloc.dart';
import '../blocs/book_detail/book_detail_event.dart';
import '../blocs/book_detail/book_detail_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/user_claim/user_claim_bloc.dart';
import '../blocs/user_claim/user_claim_event.dart';
import '../blocs/user_claim/user_claim_state.dart';
import '../config/app_constants.dart';
import '../constants/constants.dart';
import '../models/book.dart';
import '../utils/format_rules.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int userRate = 0;
  var _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String commentDate(String jsonCommentDate) {
    DateTime now = DateTime.now();

    DateTime? commentDate = DateTime.tryParse(jsonCommentDate);
    if (commentDate == null) return '';

    if (now == commentDate) {
      return 'Today ${commentDate.timeZoneName}';
    } else if (DateTime(now.year, now.month, now.day - 1) == commentDate) {
      return 'Yesterday ${commentDate.timeZoneName}';
    } else {
      return '${commentDate.day}/${commentDate.month} ${commentDate.hour}:${commentDate.minute}';
    }
  }

  String? userId;

  Future<bool> _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    if (token == null) {
      return false;
    } else {
      userId = prefs.getString('id');
      return true;
    }
  }

  Future<void> _showLoginDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You need to login before using this feature'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Go to Login'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteNames.login, (route) => false);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<BookDetailBloc>()
        .add(BookDetailRequestedById(bookId: widget.book.id));

    var _sigmaXOfBackgroudImage = 10.0;
    var _sigmaYOfBackgroudImage = 10.0;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: CachedNetworkImageProvider(
          widget.book.imageUrl,
        ),
        fit: BoxFit.fitHeight,
      )),
      child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: _sigmaXOfBackgroudImage, sigmaY: _sigmaYOfBackgroudImage),
          child: Scaffold(
              backgroundColor: Colors.white.withOpacity(0.5),
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: true,
                title: Text(
                  'Detail',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorsConstant.primaryColor,
                      ),
                ),
                centerTitle: true,
              ),
              body: BlocBuilder<BookDetailBloc, BookDetailState>(
                builder: (context, state) {
                  if (state is BookDetailLoadSuccess) {
                    Book currentBook = state.book!;

                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: CachedNetworkImage(
                                            imageUrl: state.book!.imageUrl,
                                            width: 150,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                          // Image.network(
                                          //   book.imageUrl,
                                          //   width: 150,
                                          //   fit: BoxFit.cover,
                                          // ),
                                        ),
                                        SizedBox(
                                          width: 16.0,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.book!.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                              ),
                                              Text(
                                                state.book!.author,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black,
                                                    ),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                      (state.book!.avgRate >= 1)
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      color: Colors.yellow),
                                                  Icon(
                                                      (state.book!.avgRate >= 2)
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      color: Colors.yellow),
                                                  Icon(
                                                      (state.book!.avgRate >= 3)
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      color: Colors.yellow),
                                                  Icon(
                                                      (state.book!.avgRate >= 4)
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      color: Colors.yellow),
                                                  Icon(
                                                      (state.book!.avgRate == 5)
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      color: Colors.yellow),
                                                  Text(
                                                      '(${state.book!.comments.length})',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ))
                                                ],
                                              ),
                                              Spacer(),
                                              Text(
                                                FormatRules.formatPrice(
                                                    state.book!.price),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: [
                                      MaterialButton(
                                        onPressed: () {},
                                        color: ColorsConstant.primaryColor,
                                        textColor: Colors.white,
                                        child: Icon(
                                          Icons.share,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      Spacer(),
                                      BlocBuilder<CartBloc, CartState>(
                                        builder: (context, state) {
                                          if (state is CartLoadSuccess &&
                                              state.cartDetailList!
                                                  .map((e) => e['bookId'])
                                                  .contains(widget.book.id)) {
                                            return MaterialButton(
                                              onPressed: () async {
                                                bool isLoggedIn =
                                                    await _checkLogin();
                                                if (isLoggedIn == false) {
                                                  _showLoginDialog();
                                                  return;
                                                }
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'This book is already added in your cart')));
                                              },
                                              color:
                                                  ColorsConstant.primaryColor,
                                              textColor: Colors.white,
                                              child: Text('Buy'),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            );
                                          } else {
                                            return MaterialButton(
                                              onPressed: () async {
                                                bool isLoggedIn =
                                                    await _checkLogin();
                                                if (isLoggedIn == false) {
                                                  _showLoginDialog();
                                                  return;
                                                }
                                                context.read<CartBloc>().add(
                                                    CartBookAdded(
                                                        userId: userId!,
                                                        bookId: widget.book.id,
                                                        quantity: 1));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Added book to your cart')));
                                                Navigator.of(context)
                                                    .maybePop();
                                              },
                                              color:
                                                  ColorsConstant.primaryColor,
                                              textColor: Colors.white,
                                              child: Text('Buy'),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      BlocBuilder<UserClaimBloc,
                                          UserClaimState>(
                                        builder: (context, state) {
                                          return MaterialButton(
                                            onPressed: () async {
                                              bool isLoggedIn =
                                                  await _checkLogin();
                                              if (isLoggedIn == false) {
                                                _showLoginDialog();
                                                return;
                                              }

                                              if (state
                                                  is UserClaimLoadSuccess) {
                                                if (state.userClaim!.favorite
                                                    .contains(widget.book.id)) {
                                                  context
                                                      .read<UserClaimBloc>()
                                                      .add(BookRemovedFav(
                                                          bookId:
                                                              widget.book.id));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Removed from your favorite books')));
                                                } else {
                                                  context
                                                      .read<UserClaimBloc>()
                                                      .add(BookAddedFav(
                                                          bookId:
                                                              widget.book.id));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Added to your favorite books')));
                                                }

                                                Navigator.maybePop(
                                                    context, true);
                                              }
                                            },
                                            color: ColorsConstant.primaryColor,
                                            textColor: Colors.white,
                                            child: Icon(
                                              (state is UserClaimLoadSuccess)
                                                  ? ((state.userClaim!.favorite
                                                          .contains(
                                                              widget.book.id))
                                                      ? Icons.favorite
                                                      : Icons.favorite_border)
                                                  : Icons.favorite_border,
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Descriptions',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                  ),
                                  Text(
                                    state.book!.description,
                                    maxLines: 7,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Ratings & Review',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                  ),
                                  currentBook.comments.isEmpty
                                      ? Center(
                                          child: Text(
                                            'This book has no any reviews',
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                          ),
                                        )
                                      : ListView.separated(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    child: CircleAvatar(
                                                        radius: 50.0,
                                                        backgroundImage:
                                                            NetworkImage(currentBook
                                                                        .comments[
                                                                    index]
                                                                ['avatarUrl'])),
                                                  ),
                                                  SizedBox(
                                                    width: 16.0,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          currentBook.comments[
                                                                  index]
                                                              ['displayName'],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                        ),
                                                        Text(
                                                          currentBook.comments[
                                                              index]['review'],
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline5
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Icon(
                                                              (currentBook.comments[
                                                                              index]
                                                                          [
                                                                          'rate'] >=
                                                                      1)
                                                                  ? Icons.star
                                                                  : Icons
                                                                      .star_border,
                                                              color:
                                                                  Colors.yellow,
                                                              size: 17,
                                                            ),
                                                            Icon(
                                                                (currentBook.comments[index]
                                                                            [
                                                                            'rate'] >=
                                                                        2)
                                                                    ? Icons.star
                                                                    : Icons
                                                                        .star_border,
                                                                color: Colors
                                                                    .yellow,
                                                                size: 17),
                                                            Icon(
                                                                (currentBook.comments[index]
                                                                            [
                                                                            'rate'] >=
                                                                        3)
                                                                    ? Icons.star
                                                                    : Icons
                                                                        .star_border,
                                                                color: Colors
                                                                    .yellow,
                                                                size: 17),
                                                            Icon(
                                                                (currentBook.comments[index]
                                                                            [
                                                                            'rate'] >=
                                                                        4)
                                                                    ? Icons.star
                                                                    : Icons
                                                                        .star_border,
                                                                color: Colors
                                                                    .yellow,
                                                                size: 17),
                                                            Icon(
                                                                (currentBook.comments[index]
                                                                            [
                                                                            'rate'] ==
                                                                        5)
                                                                    ? Icons.star
                                                                    : Icons
                                                                        .star_border,
                                                                color: Colors
                                                                    .yellow,
                                                                size: 17),
                                                          ],
                                                        ),
                                                        Text(
                                                          commentDate(currentBook
                                                                      .comments[
                                                                  index]
                                                              ['commentDate']),
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return Divider();
                                          },
                                          shrinkWrap: true,
                                          itemCount:
                                              currentBook.comments.length),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: buildCommentInput())
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ))),
    );
  }

  Widget buildCommentInput() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      userRate = 1;
                    });
                  },
                  child: Icon(
                    (userRate > 0) ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      userRate = 2;
                    });
                  },
                  child: Icon(
                    (userRate > 1) ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      userRate = 3;
                    });
                  },
                  child: Icon(
                    (userRate > 2) ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      userRate = 4;
                    });
                  },
                  child: Icon(
                    (userRate > 3) ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      userRate = 5;
                    });
                  },
                  child: Icon(
                    (userRate > 4) ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 8.0,
              ),

              // Edit text
              Flexible(
                child: Container(
                  child: TextField(
                    onSubmitted: (value) {},
                    style: TextStyle(color: Colors.blue, fontSize: 15.0),
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type your review...',
                      hintStyle: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),

              // Button send message
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      onSendComment(_textEditingController.text);
                    },
                    color: Colors.blue,
                  ),
                ),
                color: Colors.transparent,
              ),
            ],
          )
        ],
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.blue, width: 0.5)),
        color: Colors.white.withOpacity(0.5),
      ),
    );
  }

  onSendComment(String text) async {
    if (userRate == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please rate before review')));
      return;
    }
    bool isLoggedIn = await _checkLogin();
    if (isLoggedIn == false) {
      _showLoginDialog();
      return;
    }
    context.read<BookDetailBloc>().add(BookSentComment(
        bookId: widget.book.id,
        userId: userId!,
        rate: userRate,
        review: _textEditingController.text));
  }
}
