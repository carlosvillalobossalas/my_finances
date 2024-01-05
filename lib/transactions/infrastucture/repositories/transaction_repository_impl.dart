import 'package:my_finances/entities/domain/entities/entity.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/transactions/domain/datasources/transaction_datasource.dart';
import 'package:my_finances/transactions/domain/entities/transaction.dart';
import 'package:my_finances/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl extends TransactionRepository {
  final TransactionDataSource dataSource;

  TransactionRepositoryImpl(this.dataSource);

  @override
  Future<List<ETransaction>> getTransactions(
      List<Tag> tags, List<Entity> entities) {
    return dataSource.getTransactions(tags, entities);
  }

  @override
  Future<bool> saveTransaction(ETransaction transaction) {
    return dataSource.saveTransaction(transaction);
  }
}
