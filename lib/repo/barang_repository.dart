import 'dart:convert';
import 'package:gudang_manager/config/api.dart';
import 'package:gudang_manager/models/barang_model.dart';
import 'package:http/http.dart' as http;

abstract class BarangRepository {
  Future<BarangModel> getBarang();
}

class BarangRepositoryImpl implements BarangRepository {
  static const TAG = "BarangRepositoryImpl";

  @override
  Future<BarangModel> getBarang() async {
    var _response = await http.get(Uri.parse(Api.instance.barangURL));
    print(TAG + " " + _response.statusCode.toString());
    if (_response.statusCode == 200) {
      // print("$TAG getBarang true ");
      var data = json.decode(_response.body);
      // print("Data $data");
      BarangModel model = BarangModel.fromJson(data);
      return model;
    } else {
      // print("$TAG getLogin else");
      throw Exception();
    }
  }
}
