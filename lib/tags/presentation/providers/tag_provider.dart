import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/tags/domain/repositories/tag_repository.dart';
import 'package:my_finances/tags/presentation/providers/tag_repository_provider.dart';

class TagState {
  final bool isLoading;
  final List<Tag> tags;

  final String name;
  final Color color;

  TagState(
      {this.isLoading = false,
      this.tags = const [],
      this.name = '',
      this.color = Colors.blue});

  TagState copyWith(
          {bool? isLoading, List<Tag>? tags, String? name, Color? color}) =>
      TagState(
          isLoading: isLoading ?? this.isLoading,
          tags: tags ?? this.tags,
          name: name ?? this.name,
          color: color ?? this.color);
}

class TagNotifier extends StateNotifier<TagState> {
  final TagRepository tagRepository;
  final TextEditingController nameTxtController = TextEditingController();

  TagNotifier({required this.tagRepository}) : super(TagState()) {
    loadTags();
  }

  Future loadTags() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    final tags = await tagRepository.getTags();
    state = state.copyWith(tags: tags, isLoading: false);
  }

  Future<bool> saveTag() async {
    state = state.copyWith(isLoading: true);

    final response = await tagRepository
        .saveTag(Tag(id: '', name: state.name, color: state.color.hexAlpha));

    state = state.copyWith(isLoading: false);

    return response;
  }

  void onNameChanged(String value) {
    state = state.copyWith(name: value);
  }

  void onColorChanged(Color value) {
    state = state.copyWith(color: value);
  }
}

final tagProvider =
    StateNotifierProvider.autoDispose<TagNotifier, TagState>((ref) {
  final tagRepository = ref.watch(tagRepositoryProvider);
  return TagNotifier(tagRepository: tagRepository);
});
