import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/shared/app_constant.dart';
import 'package:money_watcher/shared/app_string.dart';

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
  void didUpdateWidget(covariant MoneyRecordFilterScreen oldWidget) {
    if (oldWidget.initialSelectedType != widget.initialSelectedType ||
        oldWidget.initialSelectedCategory != widget.initialSelectedCategory) {
      selectedType = widget.initialSelectedType;
      selectedCategory = widget.initialSelectedCategory;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(filterAppbar),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                filterTypeText,
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
                    label: const Text(filterChipTextAll),
                    selected: selectedType == MoneyRecordType.all,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          selectedType = MoneyRecordType.all;
                          selectedCategory = '';
                        });
                        widget.onFilterChanged(
                          MoneyRecordType.all,
                          selectedCategory,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text(filterChipTextIncome),
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
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text(filterChipTextExpense),
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
                filterCategoryText,
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
