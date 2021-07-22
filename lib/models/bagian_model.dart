import 'bagian.dart';

class BagianModel {
  String responsecode = "";
  String responsemsg = "";
  List<Bagian> bagian = [];

  BagianModel({required this.responsecode, required this.responsemsg, required this.bagian});

  BagianModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['bagian'] != null) {
      json['bagian'].forEach((v) {
        bagian.add(new Bagian.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.bagian != null) {
      data['bagian'] = this.bagian.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
