import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/ui/money_record_chart_screen.dart';
import 'package:money_watcher/dashboard/ui/money_record_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabScreenList = [
    const MoneyRecordListScreen(),
    const MoneyRecordChartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
              setState(() {
              });
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              label: 'Money Record',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Chart',
            ),
          ],
        ),
        body: _tabScreenList[_selectedIndex],
      ),
    );
  }
}
