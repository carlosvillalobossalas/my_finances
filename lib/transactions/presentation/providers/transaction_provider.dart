import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/entities/domain/repositories/entity_repository.dart';
import 'package:my_finances/entities/presentation/providers/entity_repository_provider.dart';
import 'package:my_finances/helpers/group_tags.dart';
import 'package:my_finances/tags/domain/entities/grouped_tag.dart';
import 'package:my_finances/tags/domain/repositories/tag_repository.dart';
import 'package:my_finances/tags/presentation/providers/tag_repository_provider.dart';
import 'package:my_finances/transactions/domain/entities/transaction.dart';
import 'package:my_finances/transactions/domain/repositories/transaction_repository.dart';
import 'package:my_finances/transactions/presentation/providers/transaction_repository_provider.dart';

class TransactionState {
  final bool isLoading;
  final List<ETransaction> transactions;
  final List<GroupedTag> groupedTransactions;
  final DateTime? initialDate;
  final DateTime? endDate;
  final double expenses;
  final double income;
  final double balance;

  final bool transactionView;

  TransactionState(
      {this.isLoading = false,
      this.transactions = const [],
      this.groupedTransactions = const [],
      this.expenses = 0,
      this.income = 0,
      this.balance = 0,
      this.initialDate,
      this.endDate,
      this.transactionView = true});

  TransactionState copyWith({
    bool? isLoading,
    List<ETransaction>? transactions,
    List<GroupedTag>? groupedTransactions,
    DateTime? initialDate,
    DateTime? endDate,
    double? expenses,
    double? income,
    double? balance,
    bool? transactionView,
  }) =>
      TransactionState(
          isLoading: isLoading ?? this.isLoading,
          transactions: transactions ?? this.transactions,
          groupedTransactions: groupedTransactions ?? this.groupedTransactions,
          initialDate: initialDate ?? this.initialDate,
          endDate: endDate ?? this.endDate,
          expenses: expenses ?? this.expenses,
          income: income ?? this.income,
          balance: balance ?? this.balance,
          transactionView: transactionView ?? this.transactionView);
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  final TransactionRepository transactionRepository;
  final TagRepository tagRepository;
  final EntityRepository entityRepository;
  final TextEditingController initialDateTxtController =
      TextEditingController();
  final TextEditingController endDateTxtController = TextEditingController();

  TransactionNotifier(
      {required this.transactionRepository,
      required this.tagRepository,
      required this.entityRepository})
      : super(TransactionState()) {
    final today = DateTime.now();
    final aMonthAgo = today.subtract(const Duration(days: 30));
    loadTransaction(aMonthAgo, today);
  }

  Future loadTransaction(DateTime initialDate, DateTime endDate) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    final tags = await tagRepository.getTags();
    final entities = await entityRepository.getEntities();
    initialDateTxtController.text = initialDate.toIso8601String().split('T')[0];
    endDateTxtController.text = endDate.toIso8601String().split('T')[0];

    final transactions = await transactionRepository.getTransactions(
        tags, entities, initialDate, endDate);
    double expenses = 0;
    double income = 0;
    for (var transaction in transactions) {
      if (transaction.type == 'Gastos') {
        expenses += transaction.amount;
      } else {
        income += transaction.amount;
      }
    }

    List<GroupedTag> groupedTransactions =
        GroupTags.groupTransactionsByTag(transactions);
    state = state.copyWith(
        transactions: transactions,
        groupedTransactions: groupedTransactions,
        isLoading: false,
        income: income,
        expenses: expenses,
        balance: income + expenses,
        endDate: endDate,
        initialDate: initialDate);
  }

  Future onInitialDateChange(DateTime value) async {
    // state = state.copyWith(initialDate: value);
    await loadTransaction(value, state.endDate!);
    initialDateTxtController.text = value.toIso8601String().split('T')[0];
  }

  Future onEndDateChange(DateTime value) async {
    await loadTransaction(state.initialDate!, value);

    endDateTxtController.text = value.toIso8601String().split('T')[0];
  }

  void onTransactionViewChange() {
    state = state.copyWith(transactionView: !state.transactionView);
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
