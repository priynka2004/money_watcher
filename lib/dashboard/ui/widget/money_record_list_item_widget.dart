import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/shared/app_colors.dart';

class MoneyRecordListItemWidget extends StatelessWidget {
  const MoneyRecordListItemWidget({super.key, required this.moneyRecord, });
  final MoneyRecord moneyRecord;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: moneyRecord.type == MoneyRecordType.expense
            ? expenseColor
            : incomeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(moneyRecord.category,textAlign: TextAlign.start,),
            Text(moneyRecord.amount.toString(),textAlign: TextAlign.end,)
          ],
        ),
      ),
    );
  }
}
