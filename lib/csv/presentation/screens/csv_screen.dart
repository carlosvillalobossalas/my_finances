import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/csv/presentation/providers/csv_provider.dart';
import 'package:my_finances/csv/presentation/widgets/pie_chart.dart';

class CsvScreen extends ConsumerWidget {
  const CsvScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final csvState = ref.watch(csvProvider);

    return csvState.isLoading
        ? const Scaffold(
            body: Text('Cargando'),
          )
        : const MyPieChart();
  }
}
