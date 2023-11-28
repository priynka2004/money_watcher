import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';

class MoneyRecordFilterScreen extends StatefulWidget {
  final MoneyRecordType selectedType;
  final Function(MoneyRecordType) onFilterChanged;
  const MoneyRecordFilterScreen({
    Key? key,
    required this.selectedType,
    required this.onFilterChanged
  }) : super(key: key);

  @override
  MoneyRecordFilterScreenState createState() => MoneyRecordFilterScreenState();
}

class MoneyRecordFilterScreenState extends State<MoneyRecordFilterScreen> {
  late MoneyRecordType selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Screen'),
      ),
      body: Column(
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
                      widget.onFilterChanged(MoneyRecordType.income);
                    }
                  },
                ),
                const SizedBox(width: 100,),
                ChoiceChip(
                  label: const Text('Expense'),
                  selected: selectedType == MoneyRecordType.expense,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        selectedType = MoneyRecordType.expense;
                      });
                      widget.onFilterChanged(MoneyRecordType.expense);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
