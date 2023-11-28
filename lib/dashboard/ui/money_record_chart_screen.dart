import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:money_watcher/dashboard/ui/money_record_fitter_screen.dart';
import 'package:provider/provider.dart';

class MoneyRecordChartScreen extends StatefulWidget {
  const MoneyRecordChartScreen({Key? key}) : super(key: key);

  @override
  State<MoneyRecordChartScreen> createState() => _MoneyRecordChartScreenState();
}

class _MoneyRecordChartScreenState extends State<MoneyRecordChartScreen> {
  List<MoneyRecord> recordList = [];
  MoneyRecordType selectedType = MoneyRecordType.expense;
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    fetchMoneyRecord(context);
  }

  Future<void> fetchMoneyRecord(BuildContext context) async {
    final moneyProvider = Provider.of<MoneyRecordProvider>(
        context, listen: false);
    recordList = moneyProvider.moneyRecordList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Record Chart'),
        actions: [
          IconButton(
            onPressed: () {
              _openFilterScreen(context);
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: PieChart(
                    swapAnimationDuration: const Duration(milliseconds: 150),
                    swapAnimationCurve: Curves.linear,
                    PieChartData(
                      sections: getExpenseSections(),
                      borderData: FlBorderData(show: true),
                      centerSpaceRadius: 40,
                      sectionsSpace: 0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: getFilteredRecords().map((record) {
                  return ListTile(
                    leading: Container(
                      width: 20,
                      height: 20,
                      color: getRandomColor(),
                    ),
                    title: Text(record.category),
                    subtitle: Text('Amount: ${record.amount}'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> getExpenseSections() {
    Map<String, double> expensesByCategory = getExpensesByCategory(
        recordList, selectedType, selectedCategory);
    List<PieChartSectionData> sections = [];

    expensesByCategory.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          color: getRandomColor(),
          value: amount,
          title: '$category\n$amount',
          showTitle: true,
          radius: 100,
          titleStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    });

    return sections;
  }

  List<MoneyRecord> getFilteredRecords() {
    return recordList
        .where((record) =>
    record.type == selectedType &&
        (selectedCategory.isEmpty || record.category == selectedCategory))
        .toList();
  }

  Color getRandomColor() {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange
    ];
    return colors[DateTime
        .now()
        .millisecondsSinceEpoch % colors.length];
  }

  void _openFilterScreen(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MoneyRecordFilterScreen(
          onFilterChanged: (MoneyRecordType type, String category) {
            _handleFilterChanged(type, category);
            Navigator.pop(context);
          },
          initialSelectedType: selectedType,
          initialSelectedCategory: selectedCategory,
        );
      },
    );
  }

  void _handleFilterChanged(MoneyRecordType type, String category) {
    setState(() {
      selectedType = type;
      selectedCategory = category;
    });
  }
  Map<String, double> getExpensesByCategory(
      List<MoneyRecord> records, MoneyRecordType type, String category) {
    Map<String, double> expensesByCategory = {};
    for (MoneyRecord record in records) {
      if (record.type == type &&
          (category.isEmpty || record.category == category)) {
        String recordCategory = record.category;

        if (expensesByCategory.containsKey(recordCategory)) {
          expensesByCategory[recordCategory] =
              record.amount;
        } else {
          expensesByCategory[recordCategory] = record.amount;
        }
      }
    }
    return expensesByCategory;
  }
}
