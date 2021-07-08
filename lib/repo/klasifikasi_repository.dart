
import 'dart:convert';
import 'package:gudang_manager/config/api.dart';
import 'package:gudang_manager/models/klasifikasi_model.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:http/http.dart' as http;

abstract class KlasifikasiRepository {
  Future<KlasifikasiModel> getKlasifikasi();
}

class KlasifikasiRepositoryImpl implements KlasifikasiRepository {
  final TAG = "KlasifikasiRepositoryImpl";

  @override
  Future<KlasifikasiModel> getKlasifikasi() async {
    var _response = await http.get(Uri.parse(Api.instance.klasifikasiURL));
    print(_response.statusCode);
    if (_response.statusCode == 201) {
      print("$TAG getLogin true ");
      var data = json.decode(_response.body);
      print("Data $data");
      KlasifikasiModel model = KlasifikasiModel.fromJson(data);
      return model;
    } else {
      print("$TAG getLogin else");
      throw Exception();
    }
  }
}
