import 'package:gudang_manager/config/api.dart';
import 'package:gudang_manager/models/user_models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class UserRepository {
  Future<UserModel> getLogin(
    String email,
    String password,
  );
  Future<UserModel> userUpdate(
    String id,
    String name,
    String password,
  );
  Future<UserModel> getUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  static const TAG = "UserRepositoryImpl";
  @override
  Future<UserModel> getLogin(String email, String password) async {
    var _response = await http.post(Uri.parse(Api.instance.loginURL),
        body: {"email": email, "password": password});
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

  @override
  Future<UserModel> getUser(String id) async {
    var _response = await http.get(
      Uri.parse(Api.instance.getUsers + '/' + id),
    );
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

  @override
  Future<UserModel> userUpdate(String id, String name, String password) async {
    var _response = await http.put(Uri.parse(Api.instance.getUsers + '/' + id),
        body: {"id": id, "name": name, "password": password});
    print(_response.statusCode);
    if (_response.statusCode == 200) {
      print("$TAG userUpdate true ");
      var data = json.decode(_response.body);
      print("Data $data");
      UserModel userModel = UserModel.fromJson(data);
      return userModel;
    } else {
      print("$TAG userUpdate else");
      throw Exception();
    }
  }
}
