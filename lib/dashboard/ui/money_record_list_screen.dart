import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:money_watcher/dashboard/ui/add_money_record_screen.dart';
import 'package:money_watcher/dashboard/ui/edit_money_record_screen.dart';
import 'package:money_watcher/dashboard/ui/money_record_detail_screen.dart';
import 'package:money_watcher/dashboard/ui/money_record_fitter_screen.dart';
import 'package:money_watcher/dashboard/ui/widget/money_record_list_item_widget.dart';
import 'package:money_watcher/shared/app_string.dart';
import 'package:provider/provider.dart';

class MoneyRecordListScreen extends StatefulWidget {
  const MoneyRecordListScreen({Key? key}) : super(key: key);

  @override
  State<MoneyRecordListScreen> createState() => _MoneyRecordListScreenState();
}

class _MoneyRecordListScreenState extends State<MoneyRecordListScreen> {
  late MoneyRecordType filterType = MoneyRecordType.all;
  String selectedCategory = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchMoneyRecord();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(moneyRecordListAppbarText),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: openFilterScreen,
          ),
          // Add the clear filter button
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: clearFilter,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddMoneyRecordScreen,
        child: const Icon(Icons.add),
      ),
      body: Consumer<MoneyRecordProvider>(
        builder: (context, moneyRecordProvider, widget) {
          List<MoneyRecord> filteredRecords =
          applyFilter(moneyRecordProvider.moneyRecordList);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                MoneyRecord moneyRecord = filteredRecords[index];
                return Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          showDeleteConfirmDialog(moneyRecord);
                        },
                        icon: Icons.delete,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          openEditMoneyRecordScreen(moneyRecord);
                        },
                        icon: Icons.edit,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return MoneyRecordDetailScreen(
                              moneyRecord: moneyRecord,
                            );
                          }));
                    },
                    child: MoneyRecordListItemWidget(
                      moneyRecord: moneyRecord,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: filteredRecords.length,
            ),
          );
        },
      ),
    );
  }

  Future fetchMoneyRecord() async {
    final moneyProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    moneyProvider.getMoneyRecords();
  }

  void showDeleteConfirmDialog(MoneyRecord moneyRecord) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(moneyRecordDeleteTitleText),
          content: const Text(moneyRecordDeleteContentText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(moneyRecordDeleteButtonText),
            ),
            TextButton(
              onPressed: () {
                deleteMoneyRecord(moneyRecord.id!);
                Navigator.of(context).pop();
              },
              child: const Text(moneyRecordDeleteButtonTextOkay),
            )
          ],
        );
      },
    );
  }

  void openEditMoneyRecordScreen(MoneyRecord moneyRecord) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditMoneyRecordScreen(moneyRecord: moneyRecord);
    }));
  }

  void openAddMoneyRecordScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const AddMoneyRecordScreen();
    }));
  }

  Future deleteMoneyRecord(int id) async {
    MoneyRecordProvider moneyRecordProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    await moneyRecordProvider.deleteMoneyRecord(id);
    if (moneyRecordProvider.error == null) {
      moneyRecordProvider.getMoneyRecords();
    }
  }

  void openFilterScreen() {
    showModalBottomSheet(
      context: context,
      builder: (context) => MoneyRecordFilterScreen(
        onFilterChanged: (MoneyRecordType type, String category) {
          Navigator.pop(context);
          setState(() {
            filterType = type;
            selectedCategory = category;
          });

        },
        initialSelectedType: filterType,
        initialSelectedCategory: selectedCategory,
      ),
    );
  }

  List<MoneyRecord> applyFilter(List<MoneyRecord> records) {
    if (filterType == MoneyRecordType.all) {
      return records;
    } else {
      return records
          .where(
            (record) =>
        record.type == filterType &&
            (selectedCategory.isEmpty ||
                record.category == selectedCategory),
      )
          .toList();
    }
  }

  void clearFilter() {
    setState(() {
      filterType = MoneyRecordType.all;
      selectedCategory = '';
    });
  }
}
