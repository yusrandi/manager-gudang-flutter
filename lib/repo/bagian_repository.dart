
import 'dart:convert';
import 'package:gudang_manager/config/api.dart';
import 'package:gudang_manager/models/bagian_model.dart';
import 'package:http/http.dart' as http;

abstract class BagianRepository {
  Future<BagianModel> getBagian();
}

class BagianRepositoryImpl implements BagianRepository {
  final TAG = "BagianRepositoryImpl";

  @override
  Future<BagianModel> getBagian() async {
    var _response = await http.get(Uri.parse(Api.instance.bagianURL));
    print(_response.statusCode);
    if (_response.statusCode == 201) {
      // print("$TAG getBagian true ");
      var data = json.decode(_response.body);
      // print("Data $data");
      BagianModel model = BagianModel.fromJson(data);
      return model;
    } else {
      // print("$TAG getLogin else");
      throw Exception();
    }
  }
}
