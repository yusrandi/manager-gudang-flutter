import 'dart:convert';
import 'package:gudang_manager/config/api.dart';
import 'package:gudang_manager/models/klasifikasi_model.dart';
import 'package:gudang_manager/models/pb22_model.dart';
import 'package:gudang_manager/models/pb23_model.dart';
import 'package:gudang_manager/models/pemeliharaan_model.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/models/pengeluaran_model.dart';
import 'package:gudang_manager/models/rekapitulasi_model.dart';
import 'package:http/http.dart' as http;

abstract class LaporanRepository {
  Future<PenerimaanModel> getPenerimaan(
    String spesifikasiId,
    String semester,
    String tahun,
  );
  Future<PemeliharaanModel> getPemeliharaan(
    String semester,
    String tahun,
  );

  Future<PengeluaranModel> getPengeluaran(
    String spesifikasiId,
    String bagianId,
    String semester,
    String tahun,
  );

  Future<Pb22Model> getPb22(
    String spesifikasiId,
    String tahun,
  );
  Future<Pb23Model> getPb23(
    String spesifikasiId,
    String tahun,
  );
  Future<RekapitulasiModel> getRekapitulasi(
    String spesifikasiId,
    String tahun,
  );

  Future<KlasifikasiModel> getKlasifikasi();
}

class LaporanRepositoryImpl implements LaporanRepository {
  static const TAG = "LaporanRepositoryImpl";

  @override
  Future<PenerimaanModel> getPenerimaan(
      String spesifikasiId, String semester, String tahun) async {
    var _response = await http.post(Uri.parse(Api.instance.penerimaanURL),
        body: {
          "spesifikasi_id": spesifikasiId,
          "semester": semester,
          "tahun": tahun
        });
    print("TAG " + _response.statusCode.toString());
    if (_response.statusCode == 200) {
      // print("$TAG getLogin true ");
      var data = json.decode(_response.body);
      // print("Data $data");
      PenerimaanModel model = PenerimaanModel.fromJson(data);
      return model;
    } else {
      // print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<KlasifikasiModel> getKlasifikasi() async {
    var _response = await http.get(Uri.parse(Api.instance.klasifikasiURL));
    print(_response.statusCode);
    if (_response.statusCode == 201) {
      // print("$TAG getKlasifikasi true ");
      var data = json.decode(_response.body);
      // print("Data $data");
      KlasifikasiModel model = KlasifikasiModel.fromJson(data);
      return model;
    } else {
      // print("$TAG getKlasifikasi else");
      throw Exception();
    }
  }

  @override
  Future<PengeluaranModel> getPengeluaran(String spesifikasiId, String bagianId,
      String semester, String tahun) async {
    var _response =
        await http.post(Uri.parse(Api.instance.pengeluaranURL), body: {
      "spesifikasi_id": spesifikasiId,
      "bagian_id": bagianId,
      "semester": semester,
      "tahun": tahun
    });
    print(TAG + " getPengeluaran : " + _response.statusCode.toString());
    if (_response.statusCode == 200) {
      // print("$TAG getLogin true ");
      var data = json.decode(_response.body);
      // print("Data $data");
      PengeluaranModel model = PengeluaranModel.fromJson(data);
      return model;
    } else {
      // print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<Pb22Model> getPb22(String spesifikasiId, String tahun) async {
    var _response = await http.post(Uri.parse(Api.instance.pbURL),
        body: {"klasifikasi_id": spesifikasiId, "tahun": tahun});
    // print(TAG+" getPb22 "+_response.statusCode.toString());
    if (_response.statusCode == 200) {
      // print("$TAG getLogin true ");
      var data = json.decode(_response.body);
      // print("Data $data");
      Pb22Model model = Pb22Model.fromJson(data);
      return model;
    } else {
      // print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<Pb23Model> getPb23(String spesifikasiId, String tahun) async {
    var _response = await http.post(Uri.parse(Api.instance.pb23URL),
        body: {"klasifikasi_id": spesifikasiId, "tahun": tahun});
    // print(TAG+" getPb22 "+_response.statusCode.toString());
    if (_response.statusCode == 200) {
      // print("$TAG getLogin true ");
      var data = json.decode(_response.body);
      // print("Data $data");
      Pb23Model model = Pb23Model.fromJson(data);
      return model;
    } else {
      // print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<RekapitulasiModel> getRekapitulasi(
      String spesifikasiId, String tahun) async {
    var _response = await http.post(Uri.parse(Api.instance.rekapitulasiURL),
        body: {"klasifikasi_id": spesifikasiId, "filterTahun": tahun});
    // print(TAG+" getPb22 "+_response.statusCode.toString());
    if (_response.statusCode == 200) {
      // print("$TAG getLogin true ");
      var data = json.decode(_response.body);
      // print("Data $data");
      RekapitulasiModel model = RekapitulasiModel.fromJson(data);
      return model;
    } else {
      // print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<PemeliharaanModel> getPemeliharaan(
      String semester, String tahun) async {
    var _response = await http.post(Uri.parse(Api.instance.pemeliharaanURL),
        body: {"semester": semester, "tahun": tahun});
    print("TAG " + _response.statusCode.toString());
    if (_response.statusCode == 200) {
      // print("$TAG getLogin true ");
      var data = json.decode(_response.body);
      // print("Data $data");
      PemeliharaanModel model = PemeliharaanModel.fromJson(data);
      return model;
    } else {
      // print("$TAG getLogin else");
      throw Exception();
    }
  }
}
