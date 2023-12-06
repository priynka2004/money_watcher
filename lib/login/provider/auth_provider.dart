import 'package:flutter/cupertino.dart';
import 'package:money_watcher/firebase_auth_service/auth_service.dart';
import 'package:money_watcher/login/model/user.dart';
import 'package:money_watcher/shared/app_util.dart';

class AuthProvider extends ChangeNotifier {
  AuthService   authService;
  AuthProvider(this.authService);

  bool isVisible = false;
  bool isLoading = false;
  String? error;

  void setPasswordFieldStatus() {
    isVisible = !isVisible;
    notifyListeners();
  }

  Future registerUser(UserModel user) async {
    isLoading = true;
    error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    try {
      await authService.signUp(user);
    } catch (e) {
      error = e.toString();
      AppUtil.showToast(error!);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> isUserExists(UserModel user) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      bool result = await authService.login(user);
      if (result) {
        return true;
      } else {
        return false;
      }
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
