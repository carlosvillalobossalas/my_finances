import 'package:my_finances/tags/domain/entities/grouped_tag.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/transactions/domain/entities/transaction.dart';

class GroupTags {
  static List<GroupedTag> groupTransactionsByTag(
      List<ETransaction> transactions) {
    final Map<String, GroupedTag> groupedTransactions = transactions
        .fold(<String, GroupedTag>{},
            (Map<String, GroupedTag> grouped, ETransaction transaction) {
      final String tagId = transaction.tag.id;
      final String groupId = transaction.tag.id;
      // final String groupName = transaction.tag.name;
      final Tag tag = transaction.tag;
      final List<ETransaction> groupTransactions = [
        ...(grouped[tagId]?.transactions ?? []),
        transaction
      ];
      final double totalAmount =
          groupTransactions.map((t) => t.amount).fold(0, (a, b) => a + b);

      grouped[tagId] = GroupedTag(
          id: groupId,
          tag: tag,
          transactions: groupTransactions,
          totalAmount: totalAmount);
      return grouped;
    });

    // Devolver la lista de GroupedTag
    return groupedTransactions.values.toList();
  }
}
