import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/csv/domain/entities/tag.dart';
import 'package:my_finances/csv/domain/repositories/csv_repository.dart';
import 'package:my_finances/csv/presentation/providers/csv_repository_provider.dart';

class CsvState {
  final bool isLoading;
  final List<Tag> tags;
  final RangeValues rangeValues;

  CsvState(
      {this.isLoading = false,
      this.tags = const [],
      this.rangeValues = const RangeValues(30000, 300000)});

  CsvState copyWith(
          {bool? isLoading, List<Tag>? tags, RangeValues? rangeValues}) =>
      CsvState(
          isLoading: isLoading ?? this.isLoading,
          tags: tags ?? this.tags,
          rangeValues: rangeValues ?? this.rangeValues);
}

class CsvNotifier extends StateNotifier<CsvState> {
  final CsvRepository csvRepository;
  CsvNotifier({required this.csvRepository}) : super(CsvState()) {
    loadCsvTags();
  }

  Future loadCsvTags() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    final tags = await csvRepository.getCsvTags();
    state = state.copyWith(isLoading: false, tags: tags);
  }

  void updateRangeValues(RangeValues values) {
    state = state.copyWith(rangeValues: values);
  }
}

final csvProvider =
    StateNotifierProvider.autoDispose<CsvNotifier, CsvState>((ref) {
  final csvRepository = ref.watch(csvRepositoryProvider);
  return CsvNotifier(csvRepository: csvRepository);
});
