import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AppUtil {
  static void showToast(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static String formattedDate(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    String formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);
    return formattedDate;
  }
}
