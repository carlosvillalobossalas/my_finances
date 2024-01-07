import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      children: [
        ElevatedButton(
          onPressed: () {
            context.push('/chart/pie');
          },
          child: const Text('Graficos'),
        )
      ],
    );
  }
}
