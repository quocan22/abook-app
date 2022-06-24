import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/book_search_delegate.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        body: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return BookCartItem();
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  shrinkWrap: true,
                  itemCount: 30)),
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
                  children: [
                    Row(
                      children: [
                        Text(
                          'Total price',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                        Spacer(),
                        Text(
                          '1 250 000 VNĐ',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorsConstant.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Check Out',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}

class BookCartItem extends StatefulWidget {
  const BookCartItem({
    Key? key,
  }) : super(key: key);

  @override
  State<BookCartItem> createState() => _BookCartItemState();
}

class _BookCartItemState extends State<BookCartItem> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 100,
      child: InkWell(
          onTap: () {},
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  'https://images.unsplash.com/photo-1621351183012-e2f9972dd9bf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGJvb2slMjBjb3ZlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The two towers',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    'Tolkien',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                  ),
                  Spacer(),
                  Text(
                    '250 000 VNĐ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  Text(
                    quantity.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (quantity > 0) {
                          quantity--;
                        }
                      });
                    },
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.grey,
                      size: 20,
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
