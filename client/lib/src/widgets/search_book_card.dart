import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../config/app_constants.dart' as app_constants;
import '../models/book.dart';
import '../utils/format_rules.dart';

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
              SizedBox(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: book.imageUrl,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                  // Image.network(
                  //   book.imageUrl,
                  //   fit: BoxFit.cover,
                  // ),
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
                      overflow: TextOverflow.ellipsis,
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
                      FormatRules.formatPrice(book.price),
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
