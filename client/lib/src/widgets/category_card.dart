import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../config/app_constants.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(RouteNames.bookListByCategory, arguments: category);
        },
        child: Container(
          width: 125,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  category.imageUrl,
                ),
                fit: BoxFit.fill,
              )),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black.withOpacity(0.3)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  category.categoryName,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
        // child: Column(
        //   children: [
        //     Expanded(
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(8.0),
        //         child: CachedNetworkImage(
        //           imageUrl: category.imageUrl,
        //           placeholder: (context, url) =>
        //               Center(child: CircularProgressIndicator()),
        //           errorWidget: (context, url, error) => Icon(Icons.error),
        //           width: 100,
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     Text(category.categoryName)
        //   ],
        // ),
      ),
    );
  }
}
