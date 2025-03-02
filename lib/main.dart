import 'package:flutter/material.dart';
import 'pages/cable_calculator_page.dart';
import 'pages/short_circuit_current_calculator_page.dart';
import 'pages/substation_short_circuit_calculator_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    CableCalculatorPage(),
    ShortCircuitCurrentCalculatorPage(),
    SubstationShortCircuitCalculatorPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор струму КЗ'),
        actions: [
          TextButton(
            onPressed: () => _onTabTapped(0),
            child: Text(
              'Завдання 1',
              style: TextStyle(
                color: _selectedIndex == 0 ? Colors.black : Colors.blue,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _onTabTapped(1),
            child: Text(
              'Завдання 2',
              style: TextStyle(
                color: _selectedIndex == 1 ? Colors.black : Colors.blue,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _onTabTapped(2),
            child: Text(
              'Завдання 3',
              style: TextStyle(
                color: _selectedIndex == 2 ? Colors.black : Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
