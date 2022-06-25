import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../config/app_constants.dart' as app_constants;
import '../models/book.dart';

class AutoSlideBookCard extends StatelessWidget {
  final Book book;

  const AutoSlideBookCard({
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
                  CachedNetworkImage(
                    imageUrl: book.imageUrl,
                    width: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  // Image.network(
                  //   book.imageUrl,
                  //   width: 200,
                  //   fit: BoxFit.cover,
                  // ),
                ],
              ))),
    );
  }
}
