import 'package:easy_localization/easy_localization.dart';

class FormatRules {
  static String formatPrice(int price) {
    return NumberFormat('#,##0 ').format(price).toString() +
        'currencyLabel'.tr();
  }
}
