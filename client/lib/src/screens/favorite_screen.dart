import 'package:client/src/blocs/book/book_bloc.dart';
import 'package:client/src/blocs/book/book_state.dart';
import 'package:client/src/blocs/user_claim/user_claim_bloc.dart';
import 'package:client/src/blocs/user_claim/user_claim_event.dart';
import 'package:client/src/blocs/user_claim/user_claim_state.dart';
import 'package:client/src/models/book.dart';
import 'package:client/src/screens/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart';

class FavoriteScreen extends StatefulWidget {
  final String userId;

  const FavoriteScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    context
        .read<UserClaimBloc>()
        .add(UserClaimRequested(userId: widget.userId));

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
        body: BlocBuilder<UserClaimBloc, UserClaimState>(
          builder: (context, state) {
            if (state is UserClaimLoadSuccess) {
              if (state.userClaim!.favorite.isEmpty) {
                return Center(
                  child: Text('You don\'t have any book in your favorite'),
                );
              } else {
                return BlocBuilder<BookBloc, BookState>(
                  builder: (context, bookState) {
                    if (bookState is BookLoadSuccess) {
                      List<Book> favBook = [];
                      for (var book in bookState.books!) {
                        if (state.userClaim!.favorite.contains(book.id)) {
                          favBook.add(book);
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: state.userClaim!.favorite.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    bool? isFavChange = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => BookDetailScreen(
                                                book: favBook[index])));
                                    if (isFavChange != null) {
                                      if (isFavChange == true) {
                                        setState(() {});
                                      }
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            favBook[index].imageUrl,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                              (favBook[index].avgRate >= 1)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.yellow),
                                          Icon(
                                              (favBook[index].avgRate >= 2)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.yellow),
                                          Icon(
                                              (favBook[index].avgRate >= 3)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.yellow),
                                          Icon(
                                              (favBook[index].avgRate >= 4)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.yellow),
                                          Icon(
                                              (favBook[index].avgRate == 5)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.yellow)
                                        ],
                                      ),
                                      Text(
                                        favBook[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${favBook[index].price} VNĐ',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
