import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_finances/entities/presentation/providers/entity_provider.dart';
import 'package:my_finances/tags/domain/entities/tag.dart';
import 'package:my_finances/tags/presentation/providers/tag_provider.dart';
import 'package:my_finances/transactions/presentation/providers/add_transaction_form_provider.dart';

class AddEntityScreen extends ConsumerWidget {
  const AddEntityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsState = ref.watch(tagProvider);
    final entityState = ref.watch(entityProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Agregar Comercio'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: colors.primary,
        leading: IconButton(
            onPressed: () {
              // ref.read(orderFormProvider.notifier).clearForm();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              // controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Nombre'),
              onChanged: (value) {
                ref.read(entityProvider.notifier).onNameChanged(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownSearch<Tag>(
              popupProps: const PopupProps.dialog(
                  // showSearchBox: true,
                  fit: FlexFit.loose,
                  searchFieldProps: TextFieldProps(
                      decoration:
                          InputDecoration(border: UnderlineInputBorder()))),
              items: tagsState.tags,
              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem?.name ?? 'Seleccionar Etiqueta',
                  style: const TextStyle(fontSize: 18),
                );
              },
              itemAsString: (item) => item.name,
              selectedItem: entityState.tag,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              onChanged: (value) {
                if (value != null) {
                  ref.read(entityProvider.notifier).onTagChanged(value);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
                onPressed: () {
                  ref.read(entityProvider.notifier).saveEntity().then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Comercio guardado correctamente')));
                      ref
                          .read(addTransactionFormProvider.notifier)
                          .loadTagsAndEntities()
                          .then((value) => context.pop());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hubo un error')));
                    }
                  });
                },
                child: const Text('Agregar')),
          )
        ],
      ),
    );
  }
}
