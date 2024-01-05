import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String colonFormat(double amount) {
    var formatter = NumberFormat.currency(locale: 'es_CR', symbol: '');
    String value = formatter.format(amount);
    return value;
  }
}
