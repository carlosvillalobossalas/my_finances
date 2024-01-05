import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/entities/domain/entities/entity.dart';
import 'package:my_finances/entities/domain/repositories/entity_repository.dart';
import 'package:my_finances/entities/presentation/providers/entity_repository_provider.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/tags/domain/repositories/tag_repository.dart';
import 'package:my_finances/tags/presentation/providers/tag_repository_provider.dart';
import 'package:my_finances/transactions/domain/entities/transaction.dart';
import 'package:my_finances/transactions/domain/repositories/transaction_repository.dart';
import 'package:my_finances/transactions/presentation/providers/transaction_repository_provider.dart';

class AddTransactionFormState {
  final bool isLoading;
  final List<Tag> tags;
  final List<Entity> entities;

  final Tag? selectedTag;
  final Entity? selectedEntity;
  final double amount;
  final String? detail;
  final DateTime? date;
  final String type;

  AddTransactionFormState(
      {this.isLoading = false,
      this.tags = const [],
      this.entities = const [],
      this.selectedTag,
      this.selectedEntity,
      this.amount = 0,
      this.detail,
      this.date,
      this.type = 'Gastos'});

  AddTransactionFormState copyWith({
    bool? isLoading,
    List<Tag>? tags,
    List<Entity>? entities,
    Tag? selectedTag,
    Entity? selectedEntity,
    double? amount,
    String? detail,
    DateTime? date,
    String? type,
  }) =>
      AddTransactionFormState(
        isLoading: isLoading ?? this.isLoading,
        tags: tags ?? this.tags,
        entities: entities ?? this.entities,
        selectedTag: selectedTag ?? this.selectedTag,
        selectedEntity: selectedEntity ?? this.selectedEntity,
        amount: amount ?? this.amount,
        detail: detail ?? this.detail,
        date: date ?? this.date,
        type: type ?? this.type,
      );
}

class AddTransactionFormNotifier
    extends StateNotifier<AddTransactionFormState> {
  final TransactionRepository transactionRepository;
  final TagRepository tagRepository;
  final EntityRepository entityRepository;
  final TextEditingController amountTxtController = TextEditingController();
  final TextEditingController detailTxtController = TextEditingController();
  final TextEditingController dateTxtController = TextEditingController();

  AddTransactionFormNotifier(
      {required this.transactionRepository,
      required this.tagRepository,
      required this.entityRepository})
      : super(AddTransactionFormState()) {
    loadTagsAndEntities();
  }

  Future loadTagsAndEntities() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    final tags = await tagRepository.getTags();
    final entities = await entityRepository.getEntities();

    state = state.copyWith(isLoading: false, tags: tags, entities: entities);
  }

  void onSelectedTagChanged(Tag value) {
    state = state.copyWith(selectedTag: value);
  }

  void onSelectedEntityChanged(Entity value) {
    state = state.copyWith(selectedEntity: value);
  }

  void onAmountChange(String value) {
    state = state.copyWith(amount: double.parse(value));
  }

  void onDetailChange(String value) {
    state = state.copyWith(detail: value);
  }

  void onDateChange(DateTime value) {
    state = state.copyWith(date: value);
    dateTxtController.text = value.toIso8601String().split('T')[0];
  }

  void onTypeChanged(String value) {
    state = state.copyWith(type: value);
  }

  Future<bool> onSubmit() async {
    state = state.copyWith(isLoading: true);
    final transaction = ETransaction(
        id: 'i',
        tag: state.selectedTag!,
        entity: state.selectedEntity!,
        detail: state.detail!,
        amount: state.amount,
        date: state.date!,
        type: state.type);
    final response = await transactionRepository.saveTransaction(transaction);
    if (response) {
      dateTxtController.clear();
      amountTxtController.clear();
      detailTxtController.clear();
      state = AddTransactionFormState();
    }
    state = state.copyWith(isLoading: false);
    return response;
  }
}

final addTransactionFormProvider = StateNotifierProvider.autoDispose<
    AddTransactionFormNotifier, AddTransactionFormState>((ref) {
  final tagRepository = ref.watch(tagRepositoryProvider);
  final entityRepository = ref.watch(entityRepositoryProvider);
  final transactionRepository = ref.watch(transactionRepositoryProvider);

  return AddTransactionFormNotifier(
      transactionRepository: transactionRepository,
      tagRepository: tagRepository,
      entityRepository: entityRepository);
});
