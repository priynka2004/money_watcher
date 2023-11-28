import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/shared/app_constant.dart';

class MoneyRecordFilterScreen extends StatefulWidget {
  final MoneyRecordType initialSelectedType;
  final String initialSelectedCategory;
  final Function(MoneyRecordType, String) onFilterChanged;

  const MoneyRecordFilterScreen({
    Key? key,
    required this.initialSelectedType,
    required this.initialSelectedCategory,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  MoneyRecordFilterScreenState createState() => MoneyRecordFilterScreenState();
}

class MoneyRecordFilterScreenState extends State<MoneyRecordFilterScreen> {
  late MoneyRecordType selectedType;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialSelectedType;
    selectedCategory = widget.initialSelectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Filter Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ChoiceChip(
                    label: const Text('Income'),
                    selected: selectedType == MoneyRecordType.income,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          selectedType = MoneyRecordType.income;
                        });
                        widget.onFilterChanged(
                          MoneyRecordType.income,
                          selectedCategory,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 100),
                  ChoiceChip(
                    label: const Text('Expense'),
                    selected: selectedType == MoneyRecordType.expense,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          selectedType = MoneyRecordType.expense;
                        });
                        widget.onFilterChanged(
                          MoneyRecordType.expense,
                          selectedCategory,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Filter Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: AppConstant.getRecordCategories().map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                        widget.onFilterChanged(
                          selectedType,
                          category,
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
