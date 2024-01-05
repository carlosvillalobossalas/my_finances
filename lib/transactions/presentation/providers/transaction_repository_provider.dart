import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/transactions/domain/repositories/transaction_repository.dart';
import 'package:my_finances/transactions/infrastucture/datasources/transaction_datasource_impl.dart';
import 'package:my_finances/transactions/infrastucture/repositories/transaction_repository_impl.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final transactionRepository =
      TransactionRepositoryImpl(TransactionDataSourceImpl());
  return transactionRepository;
});
