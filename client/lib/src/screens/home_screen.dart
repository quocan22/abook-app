import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/best_seller_book/best_seller_book_bloc.dart';
import '../blocs/best_seller_book/best_seller_book_event.dart';
import '../blocs/best_seller_book/best_seller_book_state.dart';
import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';
import '../blocs/book/book_state.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';
import '../blocs/category/category_state.dart';
import '../constants/constants.dart';
import '../models/book.dart';
import '../widgets/auto_slide_book_card.dart';
import '../widgets/best_seller_book_item.dart';
import '../widgets/book_search_delegate.dart';
import '../widgets/category_card.dart';
import '../widgets/squared_book_card_with_discount.dart';
import './chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  Widget _buildCarouselBookList() {
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
            List<Book> newBooks = [];
            for (var i = 0; i < 10; i++) {
              newBooks.add(state.books!.elementAt(i));
            }
            //state.books!.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
            return CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 2.0,
                autoPlay: true,
                enlargeCenterPage: false,
                viewportFraction: 0.3,
              ),
              items: newBooks
                  .map((i) => AutoSlideBookCard(
                        book: i,
                      ))
                  .toList(),
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
            List<Book> bookList = [];
            for (var i = 0; i < state.books!.length; i++) {
              bookList.add(state.books![i]);
            }
            bookList.removeWhere((a) => (a.discountRatio == 0));
            bookList.sort((a, b) => b.discountRatio.compareTo(a.discountRatio));
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: bookList.length,
              itemBuilder: (context, index) => SquaredBookCardWithDiscount(
                book: bookList[index],
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

  Widget _buildBestSellerBookList() {
    return BlocBuilder<BestSellerBookBloc, BestSellerBookState>(
      builder: (context, state) {
        if (state is BestSellerBookLoadInProgress) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
        if (state is BestSellerBookLoadFailure) {
          return const Center(child: Text('fail'));
        }
        if (state is BestSellerBookLoadSuccess) {
          if (state.bookList != null) {
            return CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 2.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.5,
              ),
              items: state.bookList!
                  .map((i) => BestSellerBookItem(
                        book: i,
                      ))
                  .toList(),
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
    super.build(context);
    context.read<BookBloc>().add(BookRequested());
    context.read<CategoryBloc>().add(CategoryRequested());
    context.read<BestSellerBookBloc>().add(BestSellerBookRequested());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ChatbotScreen()));
        },
        child: Icon(Icons.question_answer),
      ),
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
                  showSearch(context: context, delegate: BookSearchDelegate());
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
            context.read<BestSellerBookBloc>().add(BestSellerBookRequested());
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'New Book',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                SizedBox(height: 120, child: _buildCarouselBookList()),
                Text(
                  'Best Seller',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                SizedBox(height: 200, child: _buildBestSellerBookList()),
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
                  'On Sale',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                SizedBox(height: 200, child: _buildBookList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
