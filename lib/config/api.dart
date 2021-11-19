class Api {
  //* Creating instance constructor;
  static Api instance = Api();
  //* Base API URL
  // static const baseURL = "http://192.168.1.6/gudang/public/api";
  static const baseURL = "http://gudang.lp2muniprima.ac.id/api";

  String getUsers = "$baseURL/user";
  String loginURL = "$baseURL/login";
  String penerimaanURL = "$baseURL/penerimaan";
  String pemeliharaanURL = "$baseURL/pemeliharaan";
  String pengeluaranURL = "$baseURL/pengeluaran";
  String klasifikasiURL = "$baseURL/spesifikasis";
  String bagianURL = "$baseURL/bagian";
  String pbURL = "$baseURL/pb22";
  String pb23URL = "$baseURL/pb23";
  String rekapitulasiURL = "$baseURL/rekapitulasi";
  String barangURL = "$baseURL/barang";
}
