import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../config/app_constants.dart' as app_constants;
import '../models/book.dart';
import '../utils/format_rules.dart';

class SquaredBookCardWithDiscount extends StatelessWidget {
  final Book book;

  const SquaredBookCardWithDiscount({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
          onTap: () async {
            Navigator.of(context).pushNamed(app_constants.RouteNames.bookDetail,
                arguments: book);
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Stack(
                fit: StackFit.loose,
                alignment: Alignment.topRight,
                children: [
                  Stack(
                    fit: StackFit.loose,
                    alignment: Alignment.bottomCenter,
                    children: [
                      CachedNetworkImage(
                        imageUrl: book.imageUrl,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                      // Image.network(
                      //   book.imageUrl,
                      //   width: 150,
                      //   fit: BoxFit.cover,
                      // ),
                      ColoredBox(
                        color: Colors.white.withOpacity(0.9),
                        child: SizedBox(
                          width: 150,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                        (book.avgRate >= 1)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 15),
                                    Icon(
                                        (book.avgRate >= 2)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 15),
                                    Icon(
                                        (book.avgRate >= 3)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 15),
                                    Icon(
                                        (book.avgRate >= 4)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 15),
                                    Icon(
                                        (book.avgRate == 5)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 15),
                                  ],
                                ),
                                Text(
                                  book.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  FormatRules.formatPrice(book.price),
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  FormatRules.formatPrice(book.price *
                                      (100 - book.discountRatio) ~/
                                      100),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      height: 30,
                      width: 50,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                          child: Center(
                            child: Text(
                              "- ${book.discountRatio}%",
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                  )
                ],
              ))),
    );
  }
}
