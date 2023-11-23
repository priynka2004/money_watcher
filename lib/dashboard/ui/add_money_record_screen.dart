import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/model/money_record_model.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:money_watcher/shared/app_colors.dart';
import 'package:money_watcher/shared/app_constant.dart';
import 'package:money_watcher/shared/app_string.dart';
import 'package:money_watcher/shared/app_text_field.dart';
import 'package:money_watcher/shared/app_util.dart';
import 'package:money_watcher/shared/widget/radio_button_widget.dart';
import 'package:provider/provider.dart';

class AddMoneyRecordScreen extends StatefulWidget {
  const AddMoneyRecordScreen({super.key});

  @override
  AddMoneyRecordScreenState createState() => AddMoneyRecordScreenState();
}

class AddMoneyRecordScreenState extends State<AddMoneyRecordScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  late String selectedCategory;

  int selectedDate = DateTime.now().millisecondsSinceEpoch;
  MoneyRecordType selectedType = MoneyRecordType.expense;

  List<String> categories = AppConstant.getRecordCategories();

  @override
  void initState() {
    selectedCategory = categories[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(addMonetTitleText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: titleController,
                hintText: hintTextTitle,
              ),
              const SizedBox(
                height: 16,
              ),
              AppTextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                hintText: hintTextAmount,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButtonFormField(
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value as String;
                    });
                  },
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                      labelText: labelTextCategory, border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppUtil.formattedDate(selectedDate)),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text(selectDateText),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RadioButtonWidget<MoneyRecordType>(
                    value: MoneyRecordType.income,
                    selectedValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    title: radioTextIncome,
                  ),
                  RadioButtonWidget<MoneyRecordType>(
                    value: MoneyRecordType.expense,
                    selectedValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    title: radioTextExpense,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async{
                  await addMoneyRecord();
                  fetchMoneyRecord();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: buttonBackground,
                      borderRadius: BorderRadius.circular(24)),
                  child: const Text(
                    textButton,
                    style: TextStyle(color: buttonTextColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked.millisecondsSinceEpoch;
      });
    }
  }

  Future addMoneyRecord() async {
    MoneyRecord moneyRecord = MoneyRecord(
      title: titleController.text,
      amount: double.parse(amountController.text),
      category: selectedCategory,
      date: selectedDate,
      type: selectedType,
    );

    final moneyProvider =
        Provider.of<MoneyRecordProvider>(context, listen: false);
    await moneyProvider.addMoneyRecord(moneyRecord);

    if (moneyProvider.error == null) {
      if (mounted) {
        AppUtil.showToast(toastTest);
        Navigator.pop(context);
      }
    }
  }

  Future fetchMoneyRecord()async{
    final moneyProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    moneyProvider.getMoneyRecords();
  }
}
