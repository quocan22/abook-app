import './category.dart';
import './book.dart';

class Message {
  Message(
      {required this.type,
      required this.text,
      this.listBook,
      this.listCategory,
      this.isYourMsg});

  int type;
  bool? isYourMsg;
  String text;
  List<Book>? listBook;
  List<Category>? listCategory;
}
