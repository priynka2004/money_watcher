import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:money_watcher/dashboard/ui/money_record_fitter_screen.dart';
import 'package:money_watcher/shared/app_constant.dart';
import 'package:money_watcher/shared/app_string.dart';
import 'package:provider/provider.dart';

class MoneyRecordChartScreen extends StatefulWidget {
  const MoneyRecordChartScreen({Key? key}) : super(key: key);

  @override
  State<MoneyRecordChartScreen> createState() => _MoneyRecordChartScreenState();
}

class _MoneyRecordChartScreenState extends State<MoneyRecordChartScreen> {
  List<MoneyRecord> recordList = [];
  MoneyRecordType selectedType = MoneyRecordType.all;
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    fetchMoneyRecord(context);
  }

  Future<void> fetchMoneyRecord(BuildContext context) async {
    final moneyProvider =
        Provider.of<MoneyRecordProvider>(context, listen: false);
    recordList = moneyProvider.moneyRecordList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(moneyRecordChart),
        actions: [
          IconButton(
            onPressed: () {
              _openFilterScreen(context);
            },
            icon: const Icon(Icons.filter_list),
          ),
          Visibility(visible: selectedType != MoneyRecordType.all,
            child: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: clearFilter,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
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
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: calculateFilteredRecords().map((record) {
                  return ListTile(
                    leading: Container(
                      width: 20,
                      height: 20,
                      color: getRandomColor(record.category),
                    ),
                    title: Text(record.category),
                    subtitle: Text('Amount: ${record.amount}'),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> getExpenseSections() {
    Map<String, double> expensesByCategory =
        getExpensesByCategory(recordList, selectedType, selectedCategory);
    List<PieChartSectionData> sections = [];

    expensesByCategory.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          color: getRandomColor(category),
          value: amount,
          title: '',
          showTitle: true,
          radius: 100,
          titleStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    });

    return sections;
  }

  List<MoneyRecord> calculateFilteredRecords() {
    if (selectedType == MoneyRecordType.all && selectedCategory.isEmpty) {
      return recordList;
    }

    Map<String, double> categoryRecord = {};

    for (MoneyRecord record in recordList) {
      if (record.type == selectedType &&
          (selectedCategory.isEmpty || record.category == selectedCategory)) {
        // Check if the category is already in the map
        if (categoryRecord.containsKey(record.category)) {
          // If yes, update the existing entry by adding the amount
          categoryRecord[record.category] =
              (categoryRecord[record.category] ?? 0) + record.amount;
        } else {
          categoryRecord[record.category] = record.amount;
        }
      }
    }

    // Create MoneyRecord objects for each category with the total amounts
    List<MoneyRecord> filteredRecords = categoryRecord.entries.map((record) {
      return MoneyRecord(
        type: selectedType,
        category: record.key,
        amount: record.value,
        date: DateTime.now().microsecondsSinceEpoch, // Use a valid DateTime object
        title: '', // Add an appropriate default value
      );
    }).toList();

    return filteredRecords;
  }

  Color getRandomColor(String category) {
    if (category == AppConstant.getRecordCategories()[0]) {
      return Colors.red;
    }
    if (category == AppConstant.getRecordCategories()[1]) {
      return Colors.blue;
    }
    if (category == AppConstant.getRecordCategories()[2]) {
      return Colors.green;
    }
    if (category == AppConstant.getRecordCategories()[3]) {
      return Colors.yellow;
    }
    if (category == AppConstant.getRecordCategories()[4]) {
      return Colors.orange;
    }
    if (category == AppConstant.getRecordCategories()[5]) {
      return Colors.purple;
    }
    if (category == AppConstant.getRecordCategories()[6]) {
      return Colors.black;
    }
    if (category == AppConstant.getRecordCategories()[7]) {
      return Colors.grey;
    }
    if (category == AppConstant.getRecordCategories()[8]) {
      return Colors.blueAccent;
    }
    if (category == AppConstant.getRecordCategories()[9]) {
      return Colors.brown;
    }
    if (category == AppConstant.getRecordCategories()[10]) {
      return Colors.deepOrangeAccent;
    }

    return Colors.amberAccent;
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
      if (type == MoneyRecordType.all ||
          (record.type == type &&
              (category.isEmpty || record.category == category))) {
        String recordCategory = record.category;

        if (expensesByCategory.containsKey(recordCategory)) {
          expensesByCategory[recordCategory] ??= 0; // Initialize to 0 if null
          expensesByCategory[recordCategory] =
              (expensesByCategory[recordCategory] ?? 0) +
                  (record.amount ?? 0); // Add record.amount if not null
        } else {
          expensesByCategory[recordCategory] =
              record.amount ?? 0; // Set to record.amount or 0 if null
        }
      }
    }

    return expensesByCategory;
  }


  void clearFilter() {
    setState(() {
      selectedType = MoneyRecordType.all;
      selectedCategory = '';
    });
  }
}
