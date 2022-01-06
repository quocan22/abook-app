import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiengviet/tiengviet.dart';

import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';
import '../blocs/book/book_state.dart';
import '../models/book.dart';
import './search_book_card.dart';

class BookSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () => query = '',
          icon: const Icon(
            Icons.close,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back,
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    context.read<BookBloc>().add(BookRequested());
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state is BookLoadInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
        if (state is BookLoadFailure) {
          return const Center(child: Text('fail'));
        }
        if (state is BookLoadSuccess) {
          if (state.books != null) {
            final String lowerQuery = TiengViet.parse(query.toLowerCase());
            Iterable<Book> filterList = state.books!.where(
                (shortenedCategory) =>
                    TiengViet.parse(shortenedCategory.name.toLowerCase())
                        .contains(lowerQuery));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                  itemBuilder: (context, index) => SearchBookCard(
                        book: filterList.elementAt(index),
                      ),
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  shrinkWrap: true,
                  itemCount: filterList.length),
            );
          } else {
            //temp screen
            return const Center(
              child: Text('BOOKS NULL'),
            );
          }
        }
        //temp screen
        return const Center(
          child: Text('BLOC NO STATE'),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }
}
