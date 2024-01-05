import 'package:my_finances/csv/domain/entities/transaction.dart';

class Tag {
  final String name;
  final List<Transaction> transactions;
  final double totalAmount;

  Tag(
      {required this.name,
      required this.transactions,
      required this.totalAmount});
}
