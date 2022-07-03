import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/book_by_category/book_by_category_bloc.dart';
import '../blocs/book_by_category/book_by_category_event.dart';
import '../blocs/book_by_category/book_by_category_state.dart';
import '../constants/constants.dart';
import '../models/category.dart';
import '../widgets/search_book_card.dart';

class BookListByCategoryScreen extends StatelessWidget {
  final Category category;

  const BookListByCategoryScreen({Key? key, required this.category})
      : super(key: key);

  Widget _buildBookList() {
    return BlocBuilder<BookByCategoryBloc, BookByCategoryState>(
      builder: (context, state) {
        if (state is BookByCategoryLoadInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
        if (state is BookByCategoryLoadFailure) {
          return const Center(child: Text('fail'));
        }
        if (state is BookByCategoryLoadSuccess) {
          if (state.books != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                  itemBuilder: (context, index) => SearchBookCard(
                        book: state.books![index],
                      ),
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  shrinkWrap: true,
                  itemCount: state.books!.length),
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
  Widget build(BuildContext context) {
    context
        .read<BookByCategoryBloc>()
        .add(BookListByCategoryIdRequested(categoryId: category.id));
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text(
          category.categoryName,
          style: Theme.of(context).textTheme.headline4?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsConstant.primaryColor,
              ),
        ),
        centerTitle: true,
      ),
      body: _buildBookList(),
    );
  }
}
