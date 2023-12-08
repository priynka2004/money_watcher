import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/dashboard/service/money_watcher_firebase_service.dart';
import 'package:money_watcher/shared/app_util.dart';


class MoneyRecordProvider extends ChangeNotifier {
  MoneyRecordProvider(this.firebaseService);

  List<MoneyRecord> moneyRecordList = [];
  MoneyWatcherFirebaseService firebaseService;
  bool isLoading = false;
  String? error;

  Future<void> addMoneyRecord(MoneyRecord moneyRecord) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      await firebaseService.addMoneyRecord(moneyRecord);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void listenMoneyRecordChanges(){
    Stream<DatabaseEvent> databaseEventStream = firebaseService.listenMoneyWatcher();
    databaseEventStream.listen(onMoneyRecordChange);
  }

  void onMoneyRecordChange(DatabaseEvent databaseEvent){
    try {
      DataSnapshot dataSnapshot = databaseEvent.snapshot;
      if (dataSnapshot.exists) {
        dynamic map = dataSnapshot.value;

        if (map is Map<dynamic, dynamic>) {
          List<MoneyRecord> moneyRecordList = [];
          map.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              moneyRecordList.add(
                  MoneyRecord.fromJson(Map<String, dynamic>.from(value)));
            }
          });
          this.moneyRecordList = moneyRecordList;
          notifyListeners();
        } else {
          if (kDebugMode) {
            print('Invalid data');
          }
        }
      } else {
        if (kDebugMode) {
          print('Data not found');
        }
      }
    }catch(e){
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<void> editMoneyRecord(MoneyRecord moneyRecord) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      await firebaseService.editMoneyRecord(moneyRecord.id.toString(), moneyRecord);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMoneyRecords() async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      moneyRecordList = await firebaseService.fetchMoneyRecord();
      notifyListeners();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMoneyRecord(String id) async {
    try {
      error = null;
      isLoading = true;
      notifyListeners();
      await firebaseService.deleteMoneyRecord(id);
      getMoneyRecords();
    } catch (e) {
      error = e.toString();
      AppUtil.showToast(error!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
