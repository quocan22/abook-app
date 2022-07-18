import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:easy_localization/easy_localization.dart';

import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';
import '../blocs/book/book_state.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';
import '../blocs/category/category_state.dart';
import '../models/book.dart';
import '../models/category.dart';
import './search_book_card.dart';

class BookSearchDelegate extends SearchDelegate {
  List<bool> filters = [true, false, false, false];

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
    // context.read<BookBloc>().add(BookRequested());
    // context.read<CategoryBloc>().add(CategoryRequested());

    return Column(children: [
      SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: FilterChip(
                      selectedColor: Colors.blue,
                      selected: filters[0],
                      label: Text('bookSearchDelegate.name'.tr()),
                      onSelected: (_) {
                        filters = [true, false, false, false];
                        query = query.trim();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: FilterChip(
                      label: Text('bookSearchDelegate.author'.tr()),
                      selectedColor: Colors.blue,
                      selected: filters[1],
                      onSelected: (_) {
                        filters = [false, true, false, false];
                        query = query.trim();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: FilterChip(
                      selectedColor: Colors.blue,
                      selected: filters[2],
                      label: Text('bookSearchDelegate.price'.tr()),
                      onSelected: (_) {
                        filters = [false, false, true, false];
                        query = query.trim();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: FilterChip(
                      selectedColor: Colors.blue,
                      selected: filters[3],
                      label: Text('bookSearchDelegate.category'.tr()),
                      onSelected: (_) {
                        filters = [false, false, false, true];
                        query = query.trim();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoadInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is BookLoadFailure) {
              return const Center(child: Text('Failed'));
            }
            if (state is BookLoadSuccess) {
              if (state.books != null) {
                final String lowerQuery = TiengViet.parse(query.toLowerCase());
                Iterable<Book> filterList = [];

                for (var i = 0; i < 4; i++) {
                  if (filters[i] == true) {
                    if (i == 0) {
                      filterList = state.books!.where((b) =>
                          TiengViet.parse(b.name.toLowerCase())
                              .contains(lowerQuery));
                    } else if (i == 1) {
                      filterList = state.books!.where((b) =>
                          TiengViet.parse(b.author.toLowerCase())
                              .contains(lowerQuery));
                    } else if (i == 3) {
                      Iterable<Category> filterdCategory = [];
                      List<Category> categoryList = getCategoryList(context);
                      filterdCategory = categoryList.where((c) =>
                          TiengViet.parse(c.categoryName.toLowerCase())
                              .contains(lowerQuery));
                      List<String> a =
                          filterdCategory.map((e) => e.id).toList();
                      filterList =
                          state.books!.where((b) => a.contains(b.categoryId));
                    } else {
                      filterList = state.books!.where((b) =>
                          TiengViet.parse(b.price.toString().toLowerCase())
                              .contains(lowerQuery));
                    }
                  }
                }

                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<BookBloc>().add(BookRequested());
                          context.read<CategoryBloc>().add(CategoryRequested());
                        },
                        child: Padding(
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
                        ),
                      ),
                    )
                  ],
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
        ),
      ),
    ]);
  }

  List<Category> getCategoryList(BuildContext context) {
    List<Category> categoryList = [];
    final state = context.watch<CategoryBloc>().state;
    if (state is CategoryLoadSuccess) {
      categoryList = state.categories!;
    }
    return categoryList;
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }
}
