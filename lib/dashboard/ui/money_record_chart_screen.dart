import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:provider/provider.dart';

class MoneyRecordChartScreen extends StatefulWidget {
  const MoneyRecordChartScreen({Key? key}) : super(key: key);

  @override
  State<MoneyRecordChartScreen> createState() => _MoneyRecordChartScreenState();
}

class _MoneyRecordChartScreenState extends State<MoneyRecordChartScreen> {
  List<MoneyRecord> recordList = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchMoneyRecord(context);
    });
    super.initState();
  }

  Future fetchMoneyRecord(BuildContext context) async {
    final moneyProvider = Provider.of<MoneyRecordProvider>(context, listen: false);
    recordList = moneyProvider.moneyRecordList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> expensesByCategory = getExpensesByCategory(recordList);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Record Chart'),
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
                      sections: getExpenseSections(expensesByCategory),
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
                children: expensesByCategory.keys.map((category) {
                  return ListTile(
                    leading: Container(
                      width: 20,
                      height: 20,
                      color: getRandomColor(),
                    ),
                    title: Text(category),
                    subtitle: Text('Amount: ${expensesByCategory[category]}'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> getExpenseSections(Map<String, double> expensesByCategory) {
    List<PieChartSectionData> sections = [];

    expensesByCategory.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          color: getRandomColor(),
          value: amount,
          title: '$category\n$amount',
          showTitle: true,
          radius: 100,
          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    });

    return sections;
  }

  Color getRandomColor() {
    List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange];
    return colors[DateTime.now().millisecondsSinceEpoch % colors.length];
  }

  Map<String, double> getExpensesByCategory(List<MoneyRecord> records) {
    Map<String, double> expensesByCategory = {};

    for (MoneyRecord record in records) {
      if (record.type == MoneyRecordType.expense) {
        String category = record.category;

        if (expensesByCategory.containsKey(category)) {
          expensesByCategory[category] = expensesByCategory[category]! + record.amount;
        } else {
          expensesByCategory[category] = record.amount;
        }
      }
    }

    return expensesByCategory;
  }
}


