import 'package:client/src/blocs/book/book_bloc.dart';
import 'package:client/src/blocs/book/book_event.dart';
import 'package:client/src/blocs/book/book_state.dart';
import 'package:client/src/blocs/category/category_bloc.dart';
import 'package:client/src/blocs/category/category_event.dart';
import 'package:client/src/blocs/category/category_state.dart';
import 'package:client/src/constants/constants.dart';
import 'package:client/src/models/book.dart';
import 'package:client/src/models/category.dart';
import 'package:client/src/screens/feedback_screen.dart';
import 'package:client/src/widgets/category_card.dart';
import 'package:client/src/widgets/squared_book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _textEditingController = TextEditingController();

  List<Widget> messageWidgetList = [];

  @override
  void initState() {
    messageWidgetList = [
      // buildCategoryChatItem(text: 'abc', categoryIdList: [
      //   '61ac6c718d6ffbc17cff576e',
      //   '61ac6cbf8d6ffbc17cff5774',
      //   '61ac6c788d6ffbc17cff5771'
      // ]),
      // buildCategoryChatItem(text: 'abc', categoryIdList: [
      //   '61ac6c718d6ffbc17cff576e',
      //   '61ac6cbf8d6ffbc17cff5774',
      //   '61ac6c788d6ffbc17cff5771'
      // ]),
      // buildCategoryChatItem(text: 'abc', categoryIdList: [
      //   '61ac6c718d6ffbc17cff576e',
      //   '61ac6cbf8d6ffbc17cff5774',
      //   '61ac6c788d6ffbc17cff5771'
      // ]),
      // buildTextChatItem(text: 'abc', yourMsg: true),
      // buildTextChatItem(text: 'abc', yourMsg: false)
    ];
    super.initState();
  }

  @override
  void dispose() {
    messageWidgetList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<BookBloc>().add(BookRequested());
    context.read<CategoryBloc>().add(CategoryRequested());

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text(
          'ABook Chatbot',
          style: Theme.of(context).textTheme.headline4?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsConstant.primaryColor,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => FeedbackScreen()));
              },
              icon: Icon(Icons.feedback))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => messageWidgetList[index],
              reverse: true,
              itemCount: messageWidgetList.length,
            ),
          ),
          buildInput()
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Row(
          children: <Widget>[
            // Edit text
            Flexible(
              child: Container(
                child: TextField(
                  onSubmitted: (value) {
                    onSendMessage(_textEditingController.text);
                  },
                  style: TextStyle(color: Colors.blue, fontSize: 15.0),
                  controller: _textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),

            // Button send message
            Material(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    onSendMessage(_textEditingController.text);
                  },
                  color: Colors.blue,
                ),
              ),
              color: Colors.white,
            ),
          ],
        ),
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.blue, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildTextChatItem({required String text, required bool yourMsg}) {
    return Row(
        mainAxisAlignment:
            yourMsg ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            constraints: BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
                color: yourMsg ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
          ),
        ]);
  }

  Widget buildBookChatItem(
      {required String text, required List<String> bookIdList}) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 150,
              child: BlocBuilder<BookBloc, BookState>(
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

                      bookList.removeWhere((a) => !bookIdList.contains(a.id));
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: bookList.length,
                        itemBuilder: (context, index) => SquaredBookCard(
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
              ),
            )
          ],
        ),
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        constraints: BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
      ),
    ]);
  }

  Widget buildCategoryChatItem(
      {required String text, required List<String> categoryIdList}) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 150,
              child: BlocBuilder<CategoryBloc, CategoryState>(
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
                      List<Category> categoryList = [];
                      for (var i = 0; i < state.categories!.length; i++) {
                        categoryList.add(state.categories![i]);
                      }

                      categoryList
                          .removeWhere((a) => !categoryIdList.contains(a.id));

                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            CategoryCard(category: categoryList[index]),
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
              ),
            )
          ],
        ),
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        constraints: BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
      ),
    ]);
  }

  void onSendMessage(String text) {
    if (text.trim() != '') {
      setState(() {
        messageWidgetList.insert(
            0, buildTextChatItem(text: text, yourMsg: true));
        _textEditingController.clear();
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Nothing to send')));
    }
  }
}
