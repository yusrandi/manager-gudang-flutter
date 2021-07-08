
import 'dart:convert';
import 'package:gudang_manager/config/api.dart';
import 'package:gudang_manager/models/klasifikasi_model.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:http/http.dart' as http;

abstract class LaporanRepository {
  Future<PenerimaanModel> getPenerimaan(
    String spesifikasiId,
    String semester,
    String tahun,
  );

  Future<KlasifikasiModel> getKlasifikasi();

}

class LaporanRepositoryImpl implements LaporanRepository {
  final TAG = "LaporanRepositoryImpl";

  @override
  Future<PenerimaanModel> getPenerimaan(String spesifikasiId, String semester, String tahun) async {
    var _response = await http.post(Uri.parse(Api.instance.penerimaanURL), body: {"spesifikasi_id": spesifikasiId, "semester": semester, "tahun": tahun});
    print(_response.statusCode);
    if (_response.statusCode == 200) {
      print("$TAG getLogin true ");
      var data = json.decode(_response.body);
      print("Data $data");
      PenerimaanModel model = PenerimaanModel.fromJson(data);
      return model;
    } else {
      print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<KlasifikasiModel> getKlasifikasi() async{
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