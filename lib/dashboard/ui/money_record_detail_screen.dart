import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/shared/app_colors.dart';
import 'package:money_watcher/shared/app_util.dart';

class MoneyRecordDetailScreen extends StatefulWidget {
  const MoneyRecordDetailScreen({super.key, required this.moneyRecord});

  final MoneyRecord moneyRecord;

  @override
  State<MoneyRecordDetailScreen> createState() =>
      _MoneyRecordDetailScreenState();
}

class _MoneyRecordDetailScreenState extends State<MoneyRecordDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppUtil.formattedDate(widget.moneyRecord.date)),
        ),
        backgroundColor: widget.moneyRecord.type == MoneyRecordType.expense
            ? expenseColor
            : incomeColor,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              moneyRecordRow(
                label: 'Name',
                value: widget.moneyRecord.title,
              ),
              moneyRecordRow(
                label: 'Amount',
                value: widget.moneyRecord.amount.toString(),
              ),
              moneyRecordRow(
                label: 'Category',
                value: widget.moneyRecord.category,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget moneyRecordRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
