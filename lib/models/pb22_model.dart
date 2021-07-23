import 'package:gudang_manager/models/penerimaan.dart';

class Pb22Model {
  String responsecode = "";
  String responsemsg = "";
  List<Pb22> pb22 = [];

  Pb22Model({required this.responsecode, required this.responsemsg, required this.pb22});

  Pb22Model.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['pb22'] != null) {
      json['pb22'].forEach((v) {
        pb22.add(new Pb22.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.pb22 != null) {
      data['pb22'] = this.pb22.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pb22 {
  int id = 0;
  int penerimaanId = 0;
  int pengeluaranId = 0;
  int barangId = 0;
  String qty = "";
  String sisa = "";
  int status = 0;
  String date = "";
  Penerimaan? penerimaan;

  Pb22(
      {required this.id,
      required this.penerimaanId,
      required this.pengeluaranId,
      required this.barangId,
      required this.qty,
      required this.sisa,
      required this.status,
      required this.date,
      this.penerimaan});

  Pb22.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    penerimaanId = json['penerimaan_id'];
    pengeluaranId = json['pengeluaran_id'];
    barangId = json['barang_id'];
    qty = json['qty'];
    sisa = json['sisa'];
    status = json['status'];
    date = json['date'];
    penerimaan = json['penerimaan'] != null
        ? new Penerimaan.fromJson(json['penerimaan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['penerimaan_id'] = this.penerimaanId;
    data['pengeluaran_id'] = this.pengeluaranId;
    data['barang_id'] = this.barangId;
    data['qty'] = this.qty;
    data['sisa'] = this.sisa;
    data['status'] = this.status;
    data['date'] = this.date;
    if (this.penerimaan != null) {
      data['penerimaan'] = this.penerimaan!.toJson();
    }
    return data;
  }
}

