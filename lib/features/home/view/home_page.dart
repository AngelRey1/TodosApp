import 'package:flutter/material.dart';
import 'package:javerage_todos/features/stats/view/stats_page.dart';
import 'package:javerage_todos/features/todos_overview/view/todos_overview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        Scaffold(
          body: const TodosOverviewPage(),
          bottomNavigationBar: _buildBottomNav(),
        ),
        Scaffold(
          body: const StatsPage(),
          bottomNavigationBar: _buildBottomNav(),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list_rounded),
          label: 'Todos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart_rounded),
          label: 'Stats',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
