import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
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
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          book.imageUrl,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                            Text(
                              book.author,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                    (book.avgRate >= 1)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.yellow),
                                Icon(
                                    (book.avgRate >= 2)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.yellow),
                                Icon(
                                    (book.avgRate >= 3)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.yellow),
                                Icon(
                                    (book.avgRate >= 4)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.yellow),
                                Icon(
                                    (book.avgRate == 5)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.yellow),
                                Text('(${book.comments.length})',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ))
                              ],
                            ),
                            Spacer(),
                            Text(
                              '${book.price} VNĐ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
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
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Spacer(),
                    MaterialButton(
                      onPressed: () {},
                      color: ColorsConstant.primaryColor,
                      textColor: Colors.white,
                      child: Text('Buy'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    MaterialButton(
                      onPressed: () {},
                      color: ColorsConstant.primaryColor,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.favorite_border,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Descriptions',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                Text(
                  book.description,
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Ratings & Review',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage:
                                        NetworkImage('userInfo.avatarUrl')),
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'userInfo.displayName',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                    ),
                                    Text(
                                      book.comments[index]['review'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          (book.comments[index]['rate'] >= 1)
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.yellow,
                                          size: 17,
                                        ),
                                        Icon(
                                            (book.comments[index]['rate'] >= 2)
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow,
                                            size: 17),
                                        Icon(
                                            (book.comments[index]['rate'] >= 3)
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow,
                                            size: 17),
                                        Icon(
                                            (book.comments[index]['rate'] >= 4)
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow,
                                            size: 17),
                                        Icon(
                                            (book.comments[index]['rate'] == 5)
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.yellow,
                                            size: 17),
                                      ],
                                    ),
                                    Text(
                                      commentDate(
                                          book.comments[index]['commentDate']),
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    shrinkWrap: true,
                    itemCount: book.comments.length)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
