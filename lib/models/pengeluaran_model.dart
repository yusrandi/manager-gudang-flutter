import 'package:gudang_manager/models/pengeluaran.dart';

class PengeluaranModel {
  String responsecode = "";
  String responsemsg = "";
  List<Pengeluaran> pengeluaran = [];

  PengeluaranModel({required this.responsecode, required this.responsemsg, required this.pengeluaran});

  PengeluaranModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['pengeluaran'] != null) {
      json['pengeluaran'].forEach((v) {
        pengeluaran.add(new Pengeluaran.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.pengeluaran != null) {
      data['pengeluaran'] = this.pengeluaran.map((v) => v.toJson()).toList();
    }
    return data;
  }
}








