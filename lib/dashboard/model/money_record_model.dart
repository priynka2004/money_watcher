import 'package:flutter/foundation.dart';

class MoneyRecord {
  String? id;
  String title;
  double amount;
  String category;
  int date;
  MoneyRecordType type;
  String path;

  MoneyRecord({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.type = MoneyRecordType.expense,
    this.path = '',
  });

  factory MoneyRecord.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print(json.toString());
    }
    return MoneyRecord(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: json['date'],
      type: MoneyRecordType.values.firstWhere(
        (type) => type.toString() == json['type'],
        orElse: () => MoneyRecordType.expense,
      ),
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
      'type': type.toString(),
      'path': path,
    };
  }
}

enum MoneyRecordType { income, expense, all }
