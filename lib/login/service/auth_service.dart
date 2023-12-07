import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_watcher/login/model/user.dart';

class AuthService {
  Future<bool> login(UserModel userModel) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      return true;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future signUp(UserModel userModel) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
