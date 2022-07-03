import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';
import '../blocs/book/book_state.dart';
import '../blocs/user_claim/user_claim_bloc.dart';
import '../blocs/user_claim/user_claim_event.dart';
import '../blocs/user_claim/user_claim_state.dart';
import '../constants/constants.dart';
import '../models/book.dart';
import '../widgets/book_search_delegate.dart';
import '../widgets/fav_book_item.dart';

class FavoriteScreen extends StatefulWidget {
  final String userId;

  const FavoriteScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with AutomaticKeepAliveClientMixin<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    context
        .read<UserClaimBloc>()
        .add(UserClaimRequested(userId: widget.userId));
    context.read<BookBloc>().add(BookRequested());

    return Scaffold(
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
                onTap: () {
                  showSearch(context: context, delegate: BookSearchDelegate());
                },
                child: Icon(Icons.search, color: Colors.black))
          ],
        ),
      ),
      body: BlocBuilder<UserClaimBloc, UserClaimState>(
        builder: (context, state) {
          if (state is UserClaimLoadInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          } else if (state is UserClaimLoadSuccess) {
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
                          itemCount: favBook.length,
                          itemBuilder: (context, index) {
                            return FavBookItem(book: favBook.elementAt(index));
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
