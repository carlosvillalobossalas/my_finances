import 'package:my_finances/entities/domain/entities/entity.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/transactions/domain/entities/transaction.dart';

abstract class TransactionDataSource {
  Future<List<ETransaction>> getTransactions(
      List<Tag> tags, List<Entity> entities);
  Future<bool> saveTransaction(ETransaction transaction);
}
