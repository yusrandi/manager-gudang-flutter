class PenerimaanModel {
  String responsecode = "";
  String responsemsg = "";
  List<Penerimaan> penerimaan = [];

  PenerimaanModel({required this.responsecode, required this.responsemsg, required this.penerimaan});

  PenerimaanModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['penerimaan'] != null) {
      // ignore: deprecated_member_use
      // penerimaan = new List<Penerimaan>();
      json['penerimaan'].forEach((v) {
        penerimaan.add(new Penerimaan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responsecode'] = this.responsecode;
    data['responsemsg'] = this.responsemsg;
    if (this.penerimaan != null) {
      data['penerimaan'] = this.penerimaan.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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
  Klasifikasi? rekanan;
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
      this.rekanan,
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
    barang = json['barang'] != null ? new Barang.fromJson(json['barang']) : null!;
    rekanan = (json['rekanan'] != null ? new Klasifikasi.fromJson(json['rekanan']): null!) ;
    satuan = (json['satuan'] != null? new Klasifikasi.fromJson(json['satuan']): null!);
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
    if (this.rekanan != null) {
      data['rekanan'] = this.rekanan!.toJson();
    }
    if (this.satuan != null) {
      data['satuan'] = this.satuan!.toJson();
    }
    return data;
  }
}

class Barang {
  int id = 0;
  int klasifikasiId = 0;
  String name = "";
  Klasifikasi? klasifikasi;

  Barang(
      {required this.id,
      required this.klasifikasiId,
      required this.name,
      required this.klasifikasi});

  Barang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    klasifikasiId = json['klasifikasi_id'];
    name = json['name'];
    klasifikasi = (json['klasifikasi'] != null ? new Klasifikasi.fromJson(json['klasifikasi']): null)!;
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

class Klasifikasi {
  int id = 0;
  String name = "";
  Klasifikasi({required this.id, required this.name});

  Klasifikasi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Rekanan {
  int id = 0;
  String name = "";

  Rekanan({required this.id, required this.name});

  Rekanan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
class Satuan {
  int id = 0;
  String name = "";

  Satuan({required this.id, required this.name});

  Satuan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}