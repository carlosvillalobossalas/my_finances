import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_finances/entities/domain/entities/entity.dart';
import 'package:my_finances/full_screen_loader.dart';
import 'package:my_finances/transactions/presentation/providers/add_transaction_form_provider.dart';

class AddTransactionScreen extends ConsumerWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addTransactionFormState = ref.watch(addTransactionFormProvider);
    final amountController =
        ref.watch(addTransactionFormProvider.notifier).amountTxtController;
    final detailController =
        ref.watch(addTransactionFormProvider.notifier).detailTxtController;
    final dateController =
        ref.watch(addTransactionFormProvider.notifier).dateTxtController;
    return addTransactionFormState.isLoading
        ? const FullScreenLoader()
        : ListView(
            children: [
              ExpansionTile(
                title: const Text('Etiqueta'),
                subtitle: Text(
                    addTransactionFormState.selectedTag?.name ?? 'Sin escoger'),
                children: [
                  ...addTransactionFormState.tags.map(
                    (tag) => RadioListTile(
                        title: Text(
                          tag.name,
                          style: TextStyle(
                              color: Color(int.parse('0x${tag.color}'))),
                        ),
                        value: tag,
                        groupValue: addTransactionFormState.selectedTag,
                        onChanged: (value) {
                          if (value != null) {
                            ref
                                .read(addTransactionFormProvider.notifier)
                                .onSelectedTagChanged(value);
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton(
                        onPressed: () {
                          context.push('/add/tag');
                        },
                        child: const Text('Agregar')),
                  )
                ],
              ),
              ExpansionTile(
                title: const Text('Comercio'),
                subtitle: Text(addTransactionFormState.selectedEntity?.name ??
                    'Sin escoger'),
                children: [
                  ...addTransactionFormState.entities
                      .where((entity) =>
                          entity.tag == addTransactionFormState.selectedTag?.id)
                      .map(
                        (entity) => RadioListTile(
                            title: Text(entity.name),
                            value: entity,
                            groupValue: addTransactionFormState.selectedEntity,
                            onChanged:
                                addTransactionFormState.selectedTag != null
                                    ? (value) {
                                        if (value != null) {
                                          ref
                                              .read(addTransactionFormProvider
                                                  .notifier)
                                              .onSelectedEntityChanged(
                                                  value as Entity);
                                        }
                                      }
                                    : null),
                      ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton(
                        onPressed: () => {context.push('/add/entity')},
                        child: const Text('Agregar')),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: amountController,
                  onChanged: (value) {
                    ref
                        .read(addTransactionFormProvider.notifier)
                        .onAmountChange(value);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Monto',
                    prefixText: '₡',
                  ),
                  keyboardType: TextInputType.number,
                  onTap: () {
                    if (amountController.text == '0') {
                      amountController.text = '';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: detailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Detalle'),
                  onChanged: (value) {
                    ref
                        .read(addTransactionFormProvider.notifier)
                        .onDetailChange(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextSelectionTheme(
                  data: const TextSelectionThemeData(
                      selectionColor: Colors.transparent),
                  child: TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelStyle: TextStyle(fontSize: 19),
                        labelText: 'Fecha'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        ref
                            .read(addTransactionFormProvider.notifier)
                            .onDateChange(pickedDate);
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: FilledButton(
                    onPressed: () {
                      if (addTransactionFormState.selectedEntity != null &&
                          addTransactionFormState.selectedTag != null &&
                          addTransactionFormState.amount != 0 &&
                          addTransactionFormState.date != null) {
                        ref
                            .read(addTransactionFormProvider.notifier)
                            .onSubmit()
                            .then((value) {
                          if (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Transacción guardada correctamente')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('HUbo un error')));
                          }
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())));
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Hay campos vacíos')));
                      }
                    },
                    child: const Text('Confirmar')),
              )
            ],
          );
  }
}
