import 'package:intl/intl.dart';

class FormatRules {
  static String formatPrice(int price) {
    return NumberFormat('#,##0 VND').format(price).toString();
  }
}
