import 'package:fluttertoast/fluttertoast.dart';

class AppUtil{
  static void showToast(String message){
    Fluttertoast.showToast(msg: message);
  }
}