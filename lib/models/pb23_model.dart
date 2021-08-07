import 'package:gudang_manager/models/penerimaan_model.dart';

class Pb23Model {
  String responsecode = "";
  String responsemsg = "";
  List<Pb23> pb23 = [];

  Pb23Model({required this.responsecode, required this.responsemsg, required this.pb23});

  Pb23Model.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['pb23'] != null) {
      json['pb23'].forEach((v) {
        pb23.add(new Pb23.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.pb23 != null) {
      data['pb23'] = this.pb23.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pb23 {
  int id = 0;
  int penerimaanId = 0;
  int pengeluaranId = 0;
  int barangId = 0;
  String qty = "";
  String sisa = "";
  int status = 0;
  String date = "";
  Penerimaan? penerimaan;

  Pb23(
      {required this.id,
      required this.penerimaanId,
      required this.pengeluaranId,
      required this.barangId,
      required this.qty,
      required this.sisa,
      required this.status,
      required this.date,
      required this.penerimaan});

  Pb23.fromJson(Map<String, dynamic> json) {
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
