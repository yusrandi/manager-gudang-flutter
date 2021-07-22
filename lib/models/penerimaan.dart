import 'barang.dart';
import 'klasifikasi.dart';

class Penerimaan {
  int id = 0;
  int rekananId = 0;
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
  int satuanId = 0;
  Barang? barang;
  Klasifikasi? satuan;

  Penerimaan(
      {required this.id,
      required this.rekananId,
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
      required this.satuanId,
      this.barang,
      this.satuan});

  Penerimaan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rekananId = json['rekanan_id'];
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
    satuanId = json['satuan_id'];
    barang =
        json['barang'] != null ? new Barang.fromJson(json['barang']) : null;
    satuan = json['satuan'] != null
        ? new Klasifikasi.fromJson(json['satuan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rekanan_id'] = this.rekananId;
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
    data['satuan_id'] = this.satuanId;
    if (this.barang != null) {
      data['barang'] = this.barang!.toJson();
    }
    if (this.satuan != null) {
      data['satuan'] = this.satuan!.toJson();
    }
    return data;
  }
}