import 'klasifikasi.dart';

class Barang {
  int id = 0;
  int klasifikasiId = 0;
  String name = "";
  Klasifikasi? klasifikasi;

  Barang(
      {required this.id,
      required this.klasifikasiId,
      required this.name,
      this.klasifikasi});

  Barang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    klasifikasiId = json['klasifikasi_id'];
    name = json['name'];
    klasifikasi = json['klasifikasi'] != null
        ? new Klasifikasi.fromJson(json['klasifikasi'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['klasifikasi_id'] = this.klasifikasiId;
    data['name'] = this.name;
    if (this.klasifikasi != null) {
      data['klasifikasi'] = this.klasifikasi!.toJson();
    }
    return data;
  }
}