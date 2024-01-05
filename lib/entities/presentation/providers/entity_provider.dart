import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/entities/domain/entities/entity.dart';
import 'package:my_finances/entities/domain/repositories/entity_repository.dart';
import 'package:my_finances/entities/presentation/providers/entity_repository_provider.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';

class EntityState {
  final bool isLoading;
  final List<Entity> entities;

  final String name;
  final Tag? tag;

  EntityState(
      {this.isLoading = false,
      this.entities = const [],
      this.name = '',
      this.tag});

  EntityState copyWith(
          {bool? isLoading, List<Entity>? entities, String? name, Tag? tag}) =>
      EntityState(
          isLoading: isLoading ?? this.isLoading,
          entities: entities ?? this.entities,
          name: name ?? this.name,
          tag: tag ?? this.tag);
}

class EntitiesNotifier extends StateNotifier<EntityState> {
  final EntityRepository entityRepository;

  EntitiesNotifier({required this.entityRepository}) : super(EntityState()) {
    loadEntities();
  }

  Future loadEntities() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    final tags = await entityRepository.getEntities();
    state = state.copyWith(entities: tags, isLoading: false);
  }

  void onNameChanged(String value) {
    state = state.copyWith(name: value);
  }

  void onTagChanged(Tag tag) {
    state = state.copyWith(tag: tag);
  }

  Future<bool> saveEntity() async {
    state = state.copyWith(isLoading: true);

    final response = await entityRepository
        .saveEntity(Entity(id: '', name: state.name, tag: state.tag?.id ?? ''));

    state = state.copyWith(isLoading: false);

    return response;
  }
}

final entityProvider =
    StateNotifierProvider.autoDispose<EntitiesNotifier, EntityState>((ref) {
  final entityRepository = ref.watch(entityRepositoryProvider);
  return EntitiesNotifier(entityRepository: entityRepository);
});
