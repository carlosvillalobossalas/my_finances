import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/transactions/presentation/screens/add_transaction_screen.dart';
import 'package:my_finances/transactions/presentation/screens/list_transaction_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ListTransactionScreen(),
    const AddTransactionScreen(),
    const Placeholder(),
    const Placeholder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: const Icon(
          Icons.monetization_on,
          color: Colors.white,
          size: 30,
        ),
        title: const Text(
          'Gastos App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: colors.primary,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: 'Transacciones'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Agregar'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menú')
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
