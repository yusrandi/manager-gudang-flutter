import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/bloc/barang_bloc/barang_bloc.dart';
import 'package:gudang_manager/bloc/klasifikasi_bloc/klasifikasi_bloc.dart';
import 'package:gudang_manager/bloc/laporan_bloc/laporan_bloc.dart';
import 'package:gudang_manager/constant/constant.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/models/rekapitulasi_model.dart';
import 'package:gudang_manager/repo/laporan_repository.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/penerimaan_page.dart';
import 'package:gudang_manager/ui/widgets/primary_button.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";

class RekapitulasiLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LaporanBloc(LaporanRepositoryImpl()),
      child: BlocProvider(
        create: (context) => KlasifikasiBloc(LaporanRepositoryImpl()),
        child: RekapitulasiPage(),
      ),
    );
  }
}

class RekapitulasiPage extends StatefulWidget {
  @override
  _RekapitulasiPage createState() => _RekapitulasiPage();
}

class _RekapitulasiPage extends State<RekapitulasiPage> {
  late LaporanBloc _bloc;
  late KlasifikasiBloc _klasifikasiBloc;

  String _barangId = "";
  String _barangLabel = "Pilih Barang";
  String _tahun = DateFormat('yyyy').format(DateTime.now());
  String _tahunLabel = "Pilih Tahun";

  List<ItemModel> listKlasifikasi = [];
  List<Rekapitulasi> list = [];
  List<ItemRekap> listRekap = [];

  @override
  void initState() {
    super.initState();

    _bloc = BlocProvider.of<LaporanBloc>(context);
    _klasifikasiBloc = BlocProvider.of<KlasifikasiBloc>(context);

    _klasifikasiBloc.add(FetchKlasifikasiEvent());
  }

  @override
  Widget build(BuildContext context) {
    _bloc.add(
        FetchLaporanEventRekapitulasi(spesifikasiId: _barangId, tahun: _tahun));
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: AppTheme.redBackgroundColor,
          title: Container(
            child: Row(
              children: [
                Text(
                  'Rekapitulasi',
                  style: Theme.of(context).primaryTextTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        body: _pageBody());
  }

  Widget _pageBody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16),
            Container(
              height: 35,
              child: ListView(
                // This next line does the trick.
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 160.0,
                    child: GestureDetector(
                        onTap: () async {
                          // final pdfFile = await PdfApiRekapitulasi.generate(list);
                          // PdfApi.openFile(pdfFile);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.print_outlined, color: Colors.white),
                                SizedBox(width: 8),
                                Text("Export",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18))
                              ],
                            ),
                          ),
                        )),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 100.0,
                    child: tahun(),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 150.0,
                    child: BlocBuilder<BarangBloc, BarangState>(
                      builder: (context, state) {
                        if (state is BarangErrorState) {
                          return _buildErrorUi(state.msg);
                        } else if (state is BarangLoadedState) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute<bool>(
                                  builder: (BuildContext context) {
                                    return Scaffold(
                                      appBar: AppBar(
                                        backgroundColor:
                                            AppTheme.redBackgroundColor,
                                        title: Text("Pilih Barang"),
                                      ),
                                      body: WillPopScope(
                                        onWillPop: () async {
                                          Navigator.pop(context, false);
                                          return false;
                                        },
                                        child: loadListBarang(state.barangs),
                                      ),
                                    );
                                  },
                                ));
                              },
                              child: barangField());
                        } else {
                          return _buildLoading();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            _loadLaporan(),
          ],
        ),
      ),
    );
  }

  Widget _loadLaporan() {
    return BlocListener<LaporanBloc, LaporanState>(
      listener: (context, state) {
        if (state is LaporanErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.msg)));
        }
      },
      child: BlocBuilder<LaporanBloc, LaporanState>(
        builder: (context, state) {
          // print("_loadPengeluaran state $state");
          if (state is LaporanInitialState || state is LaporanLoadingState) {
            return _buildLoading();
          } else if (state is LaporanLoadedStateRekapitulasi) {
            list = state.laporans;
            return groupRekapByPenerimaanId(state.laporans);
          } else if (state is LaporanErrorState) {
            return _buildErrorUi(state.msg);
          } else {
            return _buildErrorUi("Undefined");
          }
        },
      ),
    );
  }

  Container loadListBarang(List<Barang> list) {
    return Container(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            var data = list[index];
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _barangId = data.id.toString();
                    _barangLabel = data.name;
                  });
                  Navigator.pop(context, false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(),
                      child: Text(
                        data.name,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Container barangField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: kHintTextColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$_barangLabel',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  GestureDetector tahun() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<bool>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppTheme.redBackgroundColor,
                  title: Text("Pilih Tahun"),
                ),
                body: WillPopScope(
                  onWillPop: () async {
                    Navigator.pop(context, false);
                    return false;
                  },
                  child: listTahun(),
                ),
              );
            },
          ));
        },
        child: tahunField());
  }

  Container listTahun() {
    List<ItemModel> itemsYear = [];
    int date = int.parse(DateFormat('yyyy').format(DateTime.now()));
    for (int i = date; i > (date - 10); i--) {
      itemsYear.add(ItemModel(i.toString(), i.toString()));
    }

    return Container(
      child: ListView.builder(
          itemCount: itemsYear.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _tahun = itemsYear[index].id;
                    _tahunLabel = itemsYear[index].value;
                  });
                  Navigator.pop(context, false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(),
                      child: Text(
                        itemsYear[index].value,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Container tahunField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: kHintTextColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$_tahunLabel',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget groupRekapByPenerimaanId(List<Rekapitulasi> rekaps) {
    listRekap.clear();
    final groups = groupBy(rekaps, (Rekapitulasi e) {
      return e.penerimaanId;
    });

    groups.forEach((key, value) {
      String namaBarang = "";
      String satuan = "";
      int qtyPen = 0;
      int qtyPeng = 0;
      int price = 0;
      value.forEach((element) {
        namaBarang = element.penerimaan!.barang!.name;
        element.status == 1
            ? qtyPen += int.parse(element.penerimaan!.barangQty)
            : qtyPeng += int.parse(element.qty);
        price = int.parse(element.penerimaan!.barangPrice);
        satuan = element.penerimaan!.satuan!.name;
      });
      print(
          "key $key , nama $namaBarang, qtyPen $qtyPen, Qty Peng $qtyPeng, price $price");
      listRekap.add(ItemRekap(
          key: key,
          namaBarang: namaBarang,
          satuan: satuan,
          qtyPen: qtyPen,
          qtyPeng: qtyPeng,
          price: price));
    });

    if (listRekap.length == 0) {
      return Center(
        child: Text("Laporan not Found"),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
            columnSpacing: 16,
            columns: [
              DataColumn(
                  label:
                      Text("NO", style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Jenis Barang",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Pen Jumlah",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Pen Harga",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Pen Total",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Peng Jumlah",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Peng Harga",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Peng Total",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Stok Jumlah",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Peng Harga",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Peng Total",
                      style: Theme.of(context).textTheme.subtitle1)),
            ],
            rows: listRekap
                .map(
                  (e) => DataRow(cells: [
                    DataCell(Text(e.key.toString(),
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(e.namaBarang,
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(e.qtyPen.toString() + ' ' + e.satuan,
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        "Rp. " + NumberFormat("#,##0", "en_US").format(e.price),
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        "Rp. " +
                            NumberFormat("#,##0", "en_US")
                                .format(e.price * e.qtyPen),
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(e.qtyPeng.toString() + ' ' + e.satuan,
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        "Rp. " + NumberFormat("#,##0", "en_US").format(e.price),
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        "Rp. " +
                            NumberFormat("#,##0", "en_US")
                                .format(e.price * e.qtyPeng),
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        (e.qtyPen - e.qtyPeng).toString() + ' ' + e.satuan,
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        "Rp. " + NumberFormat("#,##0", "en_US").format(e.price),
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        "Rp. " +
                            NumberFormat("#,##0", "en_US")
                                .format(e.price * (e.qtyPen - e.qtyPeng)),
                        style: Theme.of(context).textTheme.caption)),
                  ]),
                )
                .toList()),
      ),
    );
  }
}

class ItemRekap {
  int key;
  String namaBarang;
  String satuan;
  int qtyPen;
  int qtyPeng;
  int price;

  ItemRekap(
      {required this.key,
      required this.namaBarang,
      required this.satuan,
      required this.qtyPen,
      required this.qtyPeng,
      required this.price});
}
