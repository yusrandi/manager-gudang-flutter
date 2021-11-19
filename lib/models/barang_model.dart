import 'penerimaan_model.dart';

class BarangModel {
  String responsecode = "";
  String responsemsg = "";
  List<Barang> barang = [];

  BarangModel(
      {required this.responsecode,
      required this.responsemsg,
      required this.barang});

  BarangModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['barang'] != null) {
      barang = <Barang>[];
      json['barang'].forEach((v) {
        barang.add(new Barang.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.barang != null) {
      data['barang'] = this.barang.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
