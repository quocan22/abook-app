import 'package:client/src/blocs/category/category_bloc.dart';
import 'package:client/src/blocs/category/category_event.dart';
import 'package:client/src/blocs/category/category_state.dart';
import 'package:client/src/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';
import '../blocs/book/book_state.dart';
import '../constants/constants.dart';
import '../widgets/book_search_delegate.dart';
import '../widgets/squared_book_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _buildBookList() {
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
            //state.books!.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.8),
              itemCount: state.books!.length,
              itemBuilder: (context, index) => SquaredBookCard(
                book: state.books![index],
              ),
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

  Widget _buildCategoryList() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
        if (state is CategoryLoadFailure) {
          return const Center(child: Text('fail'));
        }
        if (state is CategoryLoadSuccess) {
          if (state.categories != null) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.categories!.length,
              itemBuilder: (BuildContext context, int index) =>
                  CategoryCard(category: state.categories![index]),
            );
          } else {
            //temp screen
            return const Center(
              child: Text('CATEGORIES NULL'),
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
    context.read<BookBloc>().add(BookRequested());
    context.read<CategoryBloc>().add(CategoryRequested());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
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
                AppConstants.appName,
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsConstant.primaryColor,
                    ),
              ),
              InkWell(
                  onTap: () {
                    showSearch(
                        context: context, delegate: BookSearchDelegate());
                  },
                  child: Icon(Icons.search, color: Colors.black))
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<BookBloc>().add(BookRequested());
              context.read<CategoryBloc>().add(CategoryRequested());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                SizedBox(
                  child: _buildCategoryList(),
                  height: 150,
                ),
                Text(
                  'Recommended',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                Expanded(child: _buildBookList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
