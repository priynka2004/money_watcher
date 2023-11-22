import 'package:flutter/cupertino.dart';
import 'package:money_watcher/login/model/user.dart';
import 'package:money_watcher/shared/app_util.dart';
import 'package:money_watcher/shared/database_service.dart';

class AuthProvider extends ChangeNotifier {
  DatabaseService databaseService;

  AuthProvider(this.databaseService);

  bool isVisible = false;
  bool isLoading = false;
  String? error;

  void setPasswordFieldStatus() {
    isVisible = !isVisible;
    notifyListeners();
  }

  Future registerUser(User user) async {
    isLoading = true;
    error = null;
    notifyListeners();
    await Future.delayed(Duration(seconds: 3));
    try {
      await databaseService.registerUser(user);
    } catch (e) {
      error = e.toString();
      AppUtil.showToast(error!);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> isUserExists(User user) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      return await databaseService.isUserExists(user);
    } catch (e) {
      error = e.toString();
      AppUtil.showToast(error!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
