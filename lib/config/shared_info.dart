
import 'package:gudang_manager/models/user_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedInfo {
  late SharedPreferences sharedPref;

  void sharedLoginInfo(User user) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setInt("idUser", user.id);
    sharedPref.setString("email", user.email);
  }
}
