import 'package:flutter/material.dart';

import '../constants/constants.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

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
                'My favorites',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsConstant.primaryColor,
                    ),
              ),
              InkWell(
                  onTap: () {}, child: Icon(Icons.search, color: Colors.black))
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: 15,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (_) => BookDetailScreen()));
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1621351183012-e2f9972dd9bf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGJvb2slMjBjb3ZlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 15),
                        Icon(Icons.star, color: Colors.yellow, size: 15),
                        Icon(Icons.star, color: Colors.yellow, size: 15),
                        Icon(Icons.star, color: Colors.yellow, size: 15),
                        Icon(Icons.star_border, color: Colors.yellow, size: 15),
                      ],
                    ),
                    Text(
                      'The two towers',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '250 000 VNĐ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
