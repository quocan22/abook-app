import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/src/config/app_constants.dart';
import 'package:client/src/models/category.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(RouteNames.bookListByCategory, arguments: category);
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: category.imageUrl,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 100,
                  fit: BoxFit.cover,
                ),
                // Image.network(
                //   category.imageUrl,
                //   width: 100,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(category.categoryName)
          ],
        ),
      ),
    );
  }
}
