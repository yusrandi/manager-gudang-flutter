import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/bloc/bagian_bloc/bagian_bloc.dart';
import 'package:gudang_manager/bloc/barang_bloc/barang_bloc.dart';
import 'package:gudang_manager/bloc/klasifikasi_bloc/klasifikasi_bloc.dart';
import 'package:gudang_manager/bloc/laporan_bloc/laporan_bloc.dart';
import 'package:gudang_manager/constant/constant.dart';
import 'package:gudang_manager/models/bagian.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/models/pengeluaran.dart';
import 'package:gudang_manager/pdfapi/pdf_api.dart';
import 'package:gudang_manager/pdfapi/pdf_invoice_api_pengeluaran.dart';
import 'package:gudang_manager/repo/bagian_repository.dart';
import 'package:gudang_manager/repo/laporan_repository.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/penerimaan_page.dart';
import 'package:intl/intl.dart';

class PengeluaranLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LaporanBloc(LaporanRepositoryImpl()),
      child: BlocProvider(
          create: (context) => KlasifikasiBloc(LaporanRepositoryImpl()),
          child: BlocProvider(
              create: (context) => BagianBloc(BagianRepositoryImpl()),
              child: PengeluaranPage())),
    );
  }
}

class PengeluaranPage extends StatefulWidget {
  @override
  _PengeluaranPageState createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  late LaporanBloc _bloc;
  late KlasifikasiBloc _klasifikasiBloc;
  late BagianBloc _bagianBloc;

  String _bagianId = "";
  String _bagianLabel = "Pilih Unit Bagian";

  String _barangId = "";
  String _barangLabel = "Pilih Barang";

  String _semester = "01,12";
  String _semesterLabel = "Pilih Priode";
  String _tahun = DateFormat('yyyy').format(DateTime.now());
  String _tahunLabel = "Pilih Tahun";

  List<ItemModel> listKlasifikasi = [];
  List<ItemModel> listBagian = [];
  List<Pengeluaran> pengeluarans = [];

  late Size _screenSize;

  @override
  void initState() {
    super.initState();

    _bloc = BlocProvider.of<LaporanBloc>(context);
    _klasifikasiBloc = BlocProvider.of<KlasifikasiBloc>(context);
    _bagianBloc = BlocProvider.of<BagianBloc>(context);

    _klasifikasiBloc.add(FetchKlasifikasiEvent());
    _bagianBloc.add(FetchBagianEvent());
  }

  @override
  Widget build(BuildContext context) {
    _bloc.add(FetchLaporanPengeluaranEvent(
        spesifikasiId: _barangId,
        bagianId: _bagianId,
        semester: _semester,
        tahun: _tahun));

    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: AppTheme.redBackgroundColor,
          title: Container(
            child: Row(
              children: [
                Text(
                  'Pengeluaran',
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
                          final pdfFile =
                              await PdfInvoiceApiPengeluaran.generate(
                                  pengeluarans);
                          PdfApi.openFile(pdfFile);
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
                    child: periode(),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 100.0,
                    child: tahun(),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 150.0,
                    child: _loadBagian(),
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
            SizedBox(height: 16),
            _loadPengeluaran(),
          ],
        ),
      ),
    );
  }

  Widget _loadPengeluaran() {
    return BlocListener<LaporanBloc, LaporanState>(
      listener: (context, state) {
        if (state is LaporanErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.msg)));
        }
      },
      child: BlocBuilder<LaporanBloc, LaporanState>(
        builder: (context, state) {
          print("_loadPengeluaran state $state");
          if (state is LaporanInitialState || state is LaporanLoadingState) {
            return _buildLoading();
          } else if (state is LaporanLoadedStatePengeluaran) {
            print(state.laporans.length);
            pengeluarans = state.laporans;
            return _buildPengeluaran(state.laporans);
          } else if (state is LaporanErrorState) {
            return _buildErrorUi(state.msg);
          } else {
            return _buildErrorUi("Undefined");
          }
        },
      ),
    );
  }

  Widget _buildPengeluaran(List<Pengeluaran> list) {
    if (list.length == 0) {
      return Center(
        child: Text("Laporan not Found"),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
            columnSpacing: 10,
            columns: [
              DataColumn(
                  label:
                      Text("NO", style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("No Surat / Nota",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Nama Barang",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Jumlah",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Harga",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Total",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Penerima",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Unit/Bagian",
                      style: Theme.of(context).textTheme.subtitle1)),
            ],
            rows: list
                .map((e) => DataRow(cells: [
                      DataCell(Text((list.indexOf(e) + 1).toString(),
                          style: Theme.of(context).textTheme.caption)),
                      DataCell(Text(e.notaNo,
                          style: Theme.of(context).textTheme.caption)),
                      DataCell(Text(e.penerimaan!.barang!.name,
                          style: Theme.of(context).textTheme.caption)),
                      DataCell(Text(
                          e.penerimaan!.barangQty +
                              " " +
                              e.penerimaan!.satuan!.name,
                          style: Theme.of(context).textTheme.caption)),
                      DataCell(Text(
                          "Rp. " +
                              NumberFormat("#,##0", "en_US")
                                  .format(int.parse(e.penerimaan!.barangPrice)),
                          style: Theme.of(context).textTheme.caption)),
                      DataCell(Text(
                          "Rp. " +
                              NumberFormat("#,##0", "en_US").format(int.parse(
                                  (int.parse(e.penerimaan!.barangPrice) *
                                          int.parse(e.penerimaan!.barangQty))
                                      .toString())),
                          style: Theme.of(context).textTheme.caption)),
                      DataCell(Text(e.penerima,
                          style: Theme.of(context).textTheme.caption)),
                      DataCell(Text(e.bagian!.name,
                          style: Theme.of(context).textTheme.caption)),
                    ]))
                .toList()),
      ),
    );
  }

  GestureDetector periode() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<bool>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppTheme.redBackgroundColor,
                  title: Text("Pilih Periode"),
                ),
                body: WillPopScope(
                  onWillPop: () async {
                    Navigator.pop(context, false);
                    return false;
                  },
                  child: listPeriode(),
                ),
              );
            },
          ));
        },
        child: periodeField());
  }

  Container listPeriode() {
    List<ItemModel> items = [
      ItemModel("01,12", "1 Tahun"),
      ItemModel("01,06", "Semester 1"),
      ItemModel("07,12", "Semester 2"),
    ];

    return Container(
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _semester = items[index].id;
                    _semesterLabel = items[index].value;
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
                        items[index].value,
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

  Container periodeField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: kHintTextColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$_semesterLabel',
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

  Widget _loadBagian() {
    return BlocBuilder<BagianBloc, BagianState>(
      builder: (context, state) {
        // print("state $state");
        if (state is BagianLoadingState) {
          return _buildLoading();
        }
        if (state is BagianLoadedState) {
          // return _buildPenerimaan(state.laporans);
          // print("BagianLoadedState state $state");
          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<bool>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: AppTheme.redBackgroundColor,
                        title: Text("Pilih Unit Bagian"),
                      ),
                      body: WillPopScope(
                        onWillPop: () async {
                          Navigator.pop(context, false);
                          return false;
                        },
                        child: loadListBagian(state.bagians),
                      ),
                    );
                  },
                ));
              },
              child: bagianField());
        } else if (state is BagianErrorState) {
          return _buildErrorUi(state.msg);
        } else {
          return _buildErrorUi(state.toString());
        }
      },
    );
  }

  Container loadListBagian(List<Bagian> list) {
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
                    _bagianId = data.id.toString();
                    _bagianLabel = data.name;
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

  Container bagianField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: kHintTextColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$_bagianLabel',
        style: const TextStyle(fontSize: 16),
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
}
