import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/transactions/domain/entities/transaction.dart';

class GroupedTag {
  final String id;
  final Tag tag;
  final List<ETransaction> transactions;
  final double totalAmount;

  GroupedTag(
      {required this.id,
      required this.tag,
      required this.transactions,
      required this.totalAmount});
}
