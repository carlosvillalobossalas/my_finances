import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/entities/domain/repositories/entity_repository.dart';
import 'package:my_finances/entities/presentation/providers/entity_repository_provider.dart';
import 'package:my_finances/tags/domain/repositories/tag_repository.dart';
import 'package:my_finances/tags/presentation/providers/tag_repository_provider.dart';
import 'package:my_finances/transactions/domain/entities/transaction.dart';
import 'package:my_finances/transactions/domain/repositories/transaction_repository.dart';
import 'package:my_finances/transactions/presentation/providers/transaction_repository_provider.dart';

class TransactionState {
  final bool isLoading;
  final List<ETransaction> transactions;

  TransactionState({this.isLoading = false, this.transactions = const []});

  TransactionState copyWith(
          {bool? isLoading, List<ETransaction>? transactions}) =>
      TransactionState(
          isLoading: isLoading ?? this.isLoading,
          transactions: transactions ?? this.transactions);
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  final TransactionRepository transactionRepository;
  final TagRepository tagRepository;
  final EntityRepository entityRepository;

  TransactionNotifier(
      {required this.transactionRepository,
      required this.tagRepository,
      required this.entityRepository})
      : super(TransactionState()) {
    loadTransaction();
  }

  Future loadTransaction() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    final tags = await tagRepository.getTags();
    final entities = await entityRepository.getEntities();
    final transactions =
        await transactionRepository.getTransactions(tags, entities);
    state = state.copyWith(transactions: transactions, isLoading: false);
  }
}

final transactionProvider =
    StateNotifierProvider.autoDispose<TransactionNotifier, TransactionState>(
        (ref) {
  final tagRepository = ref.watch(tagRepositoryProvider);
  final entityRepository = ref.watch(entityRepositoryProvider);
  final transactionRepository = ref.watch(transactionRepositoryProvider);

  return TransactionNotifier(
      transactionRepository: transactionRepository,
      tagRepository: tagRepository,
      entityRepository: entityRepository);
});
