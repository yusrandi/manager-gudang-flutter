import 'package:gudang_manager/models/penerimaan_model.dart';

class KlasifikasiModel {
  String responsecode = "";
  String responsemsg = "";
  List<Klasifikasi> klasifikasi = [];

  KlasifikasiModel({required this.responsecode, required this.responsemsg, required this.klasifikasi});

  KlasifikasiModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['klasifikasi'] != null) {
      // ignore: deprecated_member_use
      // klasifikasi = new List<Klasifikasi>();
      json['klasifikasi'].forEach((v) {
        klasifikasi.add(new Klasifikasi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.klasifikasi != null) {
      data['klasifikasi'] = this.klasifikasi.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
