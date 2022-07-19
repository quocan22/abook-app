import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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

  bool _speechEnabled = false;
  SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    _initSpeech();
    context
        .read<ChatbotBloc>()
        .add(ChatbotEventSent(eventName: 'welcomeToAbook'));
  }

  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize();
    } catch (e) {
      _speechEnabled = false;
    }
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
        onResult: _onSpeechResult, localeId: 'languageCode'.tr());
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _textEditingController.text = result.recognizedWords;
    });
    EasyDebounce.debounce('delay-send-msg', Duration(milliseconds: 500), () {
      if (_speechToText.isNotListening) {
        onSendMessage(result.recognizedWords.trim());
      }
    });
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
            context.read<ChatbotBloc>().add(ChatbotStateReset());
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
              if (state is ChatbotLoadFailure) {
                return Center(
                    child: Text('chatbotScreen.errorWithChatbot'.tr()));
              }
              if (state is ChatbotLoadSuccess) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    switch (state.msgList!
                        .elementAt(state.msgList!.length - index - 1)
                        .type) {
                      case 1:
                        if (state.msgList!
                                    .elementAt(
                                        state.msgList!.length - index - 1)
                                    .isYourMsg !=
                                null &&
                            state.msgList!
                                .elementAt(state.msgList!.length - index - 1)
                                .isYourMsg!) {
                          return buildTextChatItem(
                              text: state.msgList!
                                  .elementAt(state.msgList!.length - index - 1)
                                  .text,
                              yourMsg: true);
                        }
                        return buildTextChatItem(
                            text: state.msgList!
                                .elementAt(state.msgList!.length - index - 1)
                                .text,
                            yourMsg: false);
                      case 2:
                        return buildBookChatItem(
                            text: state.msgList!
                                .elementAt(state.msgList!.length - index - 1)
                                .text,
                            bookList: state.msgList!
                                .elementAt(state.msgList!.length - index - 1)
                                .listBook!);
                      case 3:
                        return buildCategoryChatItem(
                            text: state.msgList!
                                .elementAt(state.msgList!.length - index - 1)
                                .text,
                            categoryList: state.msgList!
                                .elementAt(state.msgList!.length - index - 1)
                                .listCategory!);
                      default:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  },
                  itemCount: state.msgList!.length,
                  reverse: true,
                );
              }
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
            // Button voice
            Visibility(
              visible: _speechEnabled,
              child: Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: Icon(_speechToText.isNotListening
                        ? Icons.mic_off
                        : Icons.mic),
                    onPressed: _speechToText.isNotListening
                        ? _startListening
                        : _stopListening,
                    color: Colors.blue,
                  ),
                ),
                color: Colors.white,
              ),
            ),

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
                    hintText: 'chatbotScreen.typeYourMessage'.tr(),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Visibility(
              visible: !yourMsg,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      AssetImage('assets/images/app_logo_no_bg.png'),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
              )),
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/app_logo_no_bg.png'),
              backgroundColor: Colors.blue.withOpacity(0.1),
            ),
          ),
          Expanded(
            child: Container(
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
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 50.0),
            ),
          ),
        ]);
  }

  Widget buildCategoryChatItem(
      {required String text, required List<Category> categoryList}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/app_logo_no_bg.png'),
              backgroundColor: Colors.blue.withOpacity(0.1),
            ),
          ),
          Expanded(
            child: Container(
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
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 50.0),
            ),
          ),
        ]);
  }

  void onSendMessage(String text) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (text.trim() != '') {
      // setState(() {
      context.read<ChatbotBloc>().add(ChatbotMessageSent(msg: text));
      _textEditingController.clear();
      // });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('chatbotScreen.nothingToSend'.tr()),
        duration: Duration(seconds: 1),
      ));
    }
  }
}
