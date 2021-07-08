import 'package:gudang_manager/config/api.dart';
import 'package:gudang_manager/models/user_models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class UserRepository {
  Future<UserModel> getLogin(
    String email,
    String password,
  );
}

class UserRepositoryImpl implements UserRepository {
  final TAG = "UserRepositoryImpl";
  @override
  Future<UserModel> getLogin(String email, String password) async {
    var _response = await http.post(Uri.parse(Api.instance.loginURL), body: {"email": email, "password": password});
    print(_response.statusCode);
    if (_response.statusCode == 200) {
      print("$TAG getLogin true ");
      var data = json.decode(_response.body);
      print("Data $data");
      UserModel userModel = UserModel.fromJson(data);
      return userModel;
    } else {
      print("$TAG getLogin else");
      throw Exception();
    }
  }
}
