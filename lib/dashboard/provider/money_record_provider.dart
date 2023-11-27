import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/shared/app_util.dart';
import 'package:money_watcher/shared/database_service.dart';

class MoneyRecordProvider extends ChangeNotifier {
  MoneyRecordProvider(this.databaseService);

  List<MoneyRecord> moneyRecordList = [];
  DatabaseService databaseService;
  bool isLoading = false;
  String? error;

  Future addMoneyRecord(MoneyRecord moneyRecord) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      await databaseService.addMoneyRecord(moneyRecord);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future editMoneyRecord(MoneyRecord moneyRecord) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      await databaseService.editMoneyRecord(moneyRecord);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future getMoneyRecords() async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      moneyRecordList = await databaseService.getMoneyRecords();
      notifyListeners();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future deleteMoneyRecord(int id) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      await databaseService.deleteMoneyRecord(id);
    } catch (e) {
      error = e.toString();
      AppUtil.showToast(error!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
