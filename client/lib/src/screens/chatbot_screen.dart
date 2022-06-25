import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/book/book_bloc.dart';
import '../blocs/book/book_event.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';
import '../blocs/chatbot/chatbot_bloc.dart';
import '../blocs/chatbot/chatbot_event.dart';
import '../blocs/chatbot/chatbot_state.dart';
import '../constants/constants.dart';
import '../models/book.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import '../widgets/squared_book_card.dart';
import '../widgets/squared_book_card_with_discount.dart';
import './feedback_screen.dart';

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
    messageWidgetList = [];
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            messageWidgetList.clear();
            Navigator.of(context).maybePop();
          },
        ),
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
          Expanded(child: BlocBuilder<ChatbotBloc, ChatbotState>(
            builder: (context, state) {
              if (state is ChatbotLoadInProgress) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              }
              if (state is ChatbotLoadFailure) {
                return const Center(child: Text('fail'));
              }
              if (state is ChatbotLoadSuccess) {
                if (messageWidgetList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child:
                          Image.asset('assets/images/ABook_chatbot_logo.png'),
                    ),
                  );
                } else {
                  if (state.type == 1) {
                    messageWidgetList.insert(0,
                        buildTextChatItem(text: state.text!, yourMsg: false));
                  } else if (state.type == 2) {
                    messageWidgetList.insert(
                        0,
                        buildBookChatItem(
                            text: state.text!, bookList: state.listBook!));
                  } else {
                    messageWidgetList.insert(
                        0,
                        buildCategoryChatItem(
                            text: state.text!,
                            categoryList: state.listCategory!));
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) => messageWidgetList[index],
                    reverse: true,
                    itemCount: messageWidgetList.length,
                  );
                }
              }
              //temp screen
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image.asset('assets/images/ABook_chatbot_logo.png'),
                ),
              );
            },
          )),
          buildInput()
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
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
                    hintText: '  Type your message...',
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
      {required String text, required List<Book> bookList}) {
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
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: bookList.length,
                itemBuilder: (context, index) =>
                    (bookList[index].discountRatio != 0)
                        ? SquaredBookCardWithDiscount(
                            book: bookList[index],
                          )
                        : SquaredBookCard(
                            book: bookList[index],
                          ),
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
      {required String text, required List<Category> categoryList}) {
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
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (BuildContext context, int index) =>
                    CategoryCard(category: categoryList[index]),
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
    FocusManager.instance.primaryFocus?.unfocus();
    if (text.trim() != '') {
      setState(() {
        messageWidgetList.insert(
            0, buildTextChatItem(text: text, yourMsg: true));
        context.read<ChatbotBloc>().add(ChatbotMessageSent(msg: text));
        _textEditingController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Nothing to send'),
        duration: Duration(seconds: 1),
      ));
    }
  }
}
