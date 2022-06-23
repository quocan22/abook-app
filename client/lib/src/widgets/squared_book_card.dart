import 'package:flutter/material.dart';

import '../config/app_constants.dart' as app_constants;
import '../models/book.dart';

class SquaredBookCard extends StatelessWidget {
  final Book book;

  const SquaredBookCard({
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
                alignment: Alignment.bottomCenter,
                children: [
                  Image.network(
                    book.imageUrl,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  ColoredBox(
                    color: Colors.white.withOpacity(0.9),
                    child: SizedBox(
                      width: 150,
                      height: 61,
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
                              '${book.price} VNĐ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ))),
    );
  }
}
