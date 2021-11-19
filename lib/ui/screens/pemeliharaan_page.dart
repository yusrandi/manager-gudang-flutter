import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/bloc/laporan_bloc/laporan_bloc.dart';
import 'package:gudang_manager/constant/constant.dart';
import 'package:gudang_manager/models/pemeliharaan_model.dart';
import 'package:gudang_manager/pdfapi/pdf_api.dart';
import 'package:gudang_manager/pdfapi/pdf_api_pemeliharaan.dart';
import 'package:gudang_manager/repo/laporan_repository.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/penerimaan_page.dart';
import 'package:gudang_manager/ui/widgets/primary_button.dart';
import 'package:intl/intl.dart';

class LandingPemeliharaanPage extends StatelessWidget {
  const LandingPemeliharaanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LaporanBloc(LaporanRepositoryImpl()),
      child: Container(
        child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              elevation: 0,
              backgroundColor: AppTheme.redBackgroundColor,
              title: Container(
                child: Row(
                  children: [
                    Text(
                      'Pemeliharaan',
                      style: Theme.of(context).primaryTextTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            body: PemeliharaanPage()),
      ),
    );
  }
}

class PemeliharaanPage extends StatefulWidget {
  const PemeliharaanPage({Key? key}) : super(key: key);

  @override
  _PemeliharaanPageState createState() => _PemeliharaanPageState();
}

class _PemeliharaanPageState extends State<PemeliharaanPage> {
  late LaporanBloc bloc;

  String _spesifikasiId = "";
  String _semester = "01,12";
  String _semesterLabel = "Pilih Priode";
  String _tahun = DateFormat('yyyy').format(DateTime.now());
  String _tahunLabel = "Pilih Tahun";

  @override
  void initState() {
    bloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    bloc.add(FetchLaporanPemeliharaanEvent(semester: _semester, tahun: _tahun));
    return BlocBuilder<LaporanBloc, LaporanState>(
      builder: (context, state) {
        if (state is LaporanInitialState || state is LaporanLoadingState) {
          return _buildLoading();
        } else if (state is LaporanErrorState) {
          return _buildErrorUi(state.msg);
        } else if (state is LaporanPemeliharaanLoadedState) {
          return _buildPemeliharaan(state.datas);
        } else {
          return _buildLoading();
        }
      },
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

  Widget _buildPemeliharaan(List<Pemeliharaan> datas) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                              await PdfInvoiceApiPemeliharaan.generate(
                                  datas, _tahun);
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
                    width: 150.0,
                    child: periode(),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 150.0,
                    child: tahun(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            _laporanItemList(datas),
          ],
        ),
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

  Widget _laporanItemList(List<Pemeliharaan> datas) {
    if (datas.length == 0) {
      return Center(
        child: Text("Laporan not Found"),
      );
    }
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
              // headingRowColor: MaterialStateColor.resolveWith((states) => Colors.red),
              columnSpacing: 10,
              columns: [
                DataColumn(
                    label: Text("NO",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("JENIS BARANG",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("TGL SPK",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("N0 SPK",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("TGL SPM",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("N0 SPM",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("BANYAKNYA",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("HARGA",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("TOTAL",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("BAGIAN",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("KETERANGAN",
                        style: Theme.of(context).textTheme.subtitle1)),
              ],
              rows: datas
                  .map((item) => DataRow(cells: [
                        DataCell(Text((datas.indexOf(item) + 1).toString(),
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.barang!.name,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.spkDate,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.spkNo,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.spmDate == null ? "" : item.spmDate,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.spmNo == null ? "" : item.spmNo,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.barangQty + ' ' + item.satuan!.name,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(
                            "Rp. " +
                                NumberFormat("#,##0", "en_US")
                                    .format(int.parse(item.barangPrice)),
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(
                            "Rp. " +
                                NumberFormat("#,##0", "en_US")
                                    .format((int.parse(item.barangQty) *
                                        int.parse(item.barangPrice)))
                                    .toString(),
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.bagian!.name,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.rekanan!.name,
                            style: Theme.of(context).textTheme.caption)),
                      ]))
                  .toList()),
        ));
  }
}
