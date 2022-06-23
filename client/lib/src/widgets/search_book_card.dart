import 'package:flutter/material.dart';

import '../config/app_constants.dart' as app_constants;
import '../models/book.dart';

class SearchBookCard extends StatelessWidget {
  final Book book;

  const SearchBookCard({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 100,
      child: InkWell(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).popAndPushNamed(
                  app_constants.RouteNames.bookDetail,
                  arguments: book);
            }
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  book.imageUrl,
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
                      book.name,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      book.author,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                    ),
                    Spacer(),
                    Text(
                      '${book.price} VNĐ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
