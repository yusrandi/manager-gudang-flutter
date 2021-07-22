class Api {
  //* Creating instance constructor;
  static Api instance = Api();
  //* Base API URL
  static const baseURL = "http://192.168.1.5/gudang_v2/public/api";

  String getUsers = "$baseURL/users";
  String loginURL = "$baseURL/login";
  String penerimaanURL = "$baseURL/penerimaan";
  String pengeluaranURL = "$baseURL/pengeluaran";
  String klasifikasiURL = "$baseURL/spesifikasis";
  String bagianURL = "$baseURL/bagian";
}
