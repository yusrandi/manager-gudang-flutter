import 'package:gudang_manager/models/penerimaan.dart';

import 'klasifikasi.dart';

class Pengeluaran {
  int id = 0;
  int penerimaanId = 0;
  String date = "";
  String notaNo = "";
  String notaFile = "";
  String penanggung = "";
  String penerima = "";
  String qty = "";
  String sisa = "";
  int bagianId = 0;
  Penerimaan? penerimaan;
  Klasifikasi? bagian;

  Pengeluaran(
      {required this.id,
      required this.penerimaanId,
      required this.date,
      required this.notaNo,
      required this.notaFile,
      required this.penanggung,
      required this.penerima,
      required this.qty,
      required this.sisa,
      required this.bagianId,
      this.penerimaan,
      this.bagian});

  Pengeluaran.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    penerimaanId = json['penerimaan_id'];
    date = json['date'];
    notaNo = json['nota_no'];
    notaFile = json['nota_file'];
    penanggung = json['penanggung'];
    penerima = json['penerima'];
    qty = json['qty'];
    sisa = json['sisa'];
    bagianId = json['bagian_id'];
    penerimaan = json['penerimaan'] != null
        ? new Penerimaan.fromJson(json['penerimaan'])
        : null;
    bagian = json['bagian'] != null
        ? new Klasifikasi.fromJson(json['bagian'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['penerimaan_id'] = this.penerimaanId;
    data['date'] = this.date;
    data['nota_no'] = this.notaNo;
    data['nota_file'] = this.notaFile;
    data['penanggung'] = this.penanggung;
    data['penerima'] = this.penerima;
    data['qty'] = this.qty;
    data['sisa'] = this.sisa;
    data['bagian_id'] = this.bagianId;
    if (this.penerimaan != null) {
      data['penerimaan'] = this.penerimaan!.toJson();
    }
    if (this.bagian != null) {
      data['bagian'] = this.bagian!.toJson();
    }
    return data;
  }
}