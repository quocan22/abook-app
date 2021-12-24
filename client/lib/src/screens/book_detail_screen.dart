import 'package:client/src/constants/constants.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({Key? key}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.all(25),
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
                        'https://images.unsplash.com/photo-1621351183012-e2f9972dd9bf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGJvb2slMjBjb3ZlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The two towers',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Tolkien',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Icon(
                              Icons.star_border,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          '19.000 VNĐ',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                      ],
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
                'Book Descriptions',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam odio mauris, auctor et iaculis sed, tempus at ex. Aliquam erat volutpat. Etiam ac arcu arcu. Nunc sollicitudin lobortis dolor ac pulvinar. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam odio mauris, auctor et iaculis sed, tempus at ex. Aliquam erat volutpat. Etiam ac arcu arcu. Nunc sollicitudin lobortis dolor ac pulvinar.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam odio mauris, auctor et iaculis sed, tempus at ex. Aliquam erat volutpat. Etiam ac arcu arcu. Nunc sollicitudin lobortis dolor ac pulvinar.',
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
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: const CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: NetworkImage(
                                      'https://images.unsplash.com/photo-1617975251517-b90ff061b52e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80')),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'QuocAn Phan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                  ),
                                  Text(
                                    'I really like the book. Which I reading it every night.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                  ),
                                  Text(
                                    'Today 08:54 AM',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
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
                  itemCount: 30)
            ],
          ),
        ),
      ),
    );
  }
}
