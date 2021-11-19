import 'package:gudang_manager/models/penerimaan_model.dart';

class PemeliharaanModel {
  String responsecode = "";
  String responsemsg = "";
  List<Pemeliharaan> pemeliharaan = [];

  PemeliharaanModel(
      {required this.responsecode,
      required this.responsemsg,
      required this.pemeliharaan});

  PemeliharaanModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['pemeliharaan'] != null) {
      pemeliharaan = <Pemeliharaan>[];
      json['pemeliharaan'].forEach((v) {
        pemeliharaan.add(new Pemeliharaan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.pemeliharaan != null) {
      data['pemeliharaan'] = this.pemeliharaan.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pemeliharaan {
  int id = 0;
  String pemeliharaanName = "";
  String spkFile = "";
  String spkNo = "";
  String spkDate = "";
  String spmFile = "";
  String spmNo = "";
  String spmDate = "";
  int barangId = 0;
  String barangPrice = "";
  String barangQty = "";
  String barangSisa = "";
  int klasifikasiId = 0;
  int satuanId = 0;
  int rekananId = 0;
  int bagianId = 0;
  String status = "";
  int userId = 0;
  Barang? barang;
  Klasifikasi? rekanan;
  Klasifikasi? satuan;
  Klasifikasi? bagian;

  Pemeliharaan(
      {required this.id,
      required this.pemeliharaanName,
      required this.spkFile,
      required this.spkNo,
      required this.spkDate,
      required this.spmFile,
      required this.spmNo,
      required this.spmDate,
      required this.barangId,
      required this.barangPrice,
      required this.barangQty,
      required this.barangSisa,
      required this.klasifikasiId,
      required this.satuanId,
      required this.rekananId,
      required this.bagianId,
      required this.status,
      required this.userId,
      this.barang,
      this.rekanan,
      this.satuan,
      this.bagian});

  Pemeliharaan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pemeliharaanName = json['pemeliharaan_name'];
    spkFile = json['spk_file'];
    spkNo = json['spk_no'];
    spkDate = json['spk_date'];
    spmFile = json['spm_file'];
    spmNo = json['spm_no'];
    spmDate = json['spm_date'];
    barangId = json['barang_id'];
    barangPrice = json['barang_price'];
    barangQty = json['barang_qty'];
    barangSisa = json['barang_sisa'];
    klasifikasiId = json['klasifikasi_id'];
    satuanId = json['satuan_id'];
    rekananId = json['rekanan_id'];
    bagianId = json['bagian_id'];
    status = json['status'];
    userId = json['user_id'];
    barang =
        json['barang'] != null ? new Barang.fromJson(json['barang']) : null;
    rekanan = json['rekanan'] != null
        ? new Klasifikasi.fromJson(json['rekanan'])
        : null;
    satuan = json['satuan'] != null
        ? new Klasifikasi.fromJson(json['satuan'])
        : null;
    bagian = json['bagian'] != null
        ? new Klasifikasi.fromJson(json['bagian'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pemeliharaan_name'] = this.pemeliharaanName;
    data['spk_file'] = this.spkFile;
    data['spk_no'] = this.spkNo;
    data['spk_date'] = this.spkDate;
    data['spm_file'] = this.spmFile;
    data['spm_no'] = this.spmNo;
    data['spm_date'] = this.spmDate;
    data['barang_id'] = this.barangId;
    data['barang_price'] = this.barangPrice;
    data['barang_qty'] = this.barangQty;
    data['barang_sisa'] = this.barangSisa;
    data['klasifikasi_id'] = this.klasifikasiId;
    data['satuan_id'] = this.satuanId;
    data['rekanan_id'] = this.rekananId;
    data['bagian_id'] = this.bagianId;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    if (this.barang != null) {
      data['barang'] = this.barang!.toJson();
    }
    if (this.rekanan != null) {
      data['rekanan'] = this.rekanan!.toJson();
    }
    if (this.satuan != null) {
      data['satuan'] = this.satuan!.toJson();
    }
    if (this.bagian != null) {
      data['bagian'] = this.bagian!.toJson();
    }
    return data;
  }
}
