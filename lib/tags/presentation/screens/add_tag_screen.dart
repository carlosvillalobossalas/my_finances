import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_finances/tags/presentation/providers/tag_provider.dart';
import 'package:my_finances/transactions/presentation/providers/add_transaction_form_provider.dart';

class AddTagScreen extends ConsumerWidget {
  const AddTagScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addTagState = ref.watch(tagProvider);

    final nameController = ref.watch(tagProvider.notifier).nameTxtController;
    final colors = Theme.of(context).colorScheme;

    Future<void> openColorPicker() async {
      await ColorPicker(
        heading: const Text('Seleccione un color'),
        color: addTagState.color,
        onColorChanged: (value) {
          ref.read(tagProvider.notifier).onColorChanged(value);
        },
      ).showPickerDialog(context);
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Agregar Etiqueta'),
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
              controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Nombre'),
              onChanged: (value) {
                ref.read(tagProvider.notifier).onNameChanged(value);
              },
            ),
          ),
          ElevatedButton(
              onPressed: openColorPicker,
              child: const Text('Seleccionar color para etiqueta')),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: addTagState.color,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
                onPressed: () {
                  ref.read(tagProvider.notifier).saveTag().then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Etiqueta guardada correctamente')));
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
