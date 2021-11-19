import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:gudang_manager/bloc/klasifikasi_bloc/klasifikasi_bloc.dart';
import 'package:gudang_manager/bloc/laporan_bloc/laporan_bloc.dart';
import 'package:gudang_manager/constant/constant.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/pdfapi/pdf_api.dart';
import 'package:gudang_manager/pdfapi/pdf_invoice_api.dart';
import 'package:gudang_manager/repo/laporan_repository.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import "package:collection/collection.dart";

class LandingPenerimaanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LaporanBloc(LaporanRepositoryImpl()),
      child: BlocProvider(
          create: (context) => KlasifikasiBloc(LaporanRepositoryImpl()),
          child: PenerimaanPage()),
    );
  }
}

class PenerimaanPage extends StatefulWidget {
  @override
  _PenerimaanPageState createState() => _PenerimaanPageState();
}

class _PenerimaanPageState extends State<PenerimaanPage> {
  late LaporanBloc _bloc;
  late KlasifikasiBloc _klasifikasiBloc;

  String _spesifikasiId = "";
  String _spesifikasiIdLabel = "Pilih Spesifikasi Barang";
  String _semester = "01,12";
  String _semesterLabel = "Pilih Periode";
  String _tahun = DateFormat('yyyy').format(DateTime.now());
  String _tahunLabel = "Pilih Tahun";

  List<ItemModel> listKlasifikasi = [];

  double heightOfModalBottomSheet = 100;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LaporanBloc>(context);
    _klasifikasiBloc = BlocProvider.of<KlasifikasiBloc>(context);

    _klasifikasiBloc.add(FetchKlasifikasiEvent());
  }

  @override
  Widget build(BuildContext context) {
    // print("build");

    _bloc.add(FetchLaporanPenerimaanEvent(
        spesifikasiId: _spesifikasiId, semester: _semester, tahun: _tahun));
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: AppTheme.redBackgroundColor,
          title: Container(
            child: Row(
              children: [
                Text(
                  'Penerimaan',
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
    return BlocBuilder<LaporanBloc, LaporanState>(
      builder: (context, state) {
        // print("state $state");
        if (state is LaporanInitialState) {
          return _buildLoading();
        } else if (state is LaporanLoadingState) {
          return _buildLoading();
        } else if (state is LaporanLoadedState) {
          // print(state.laporans.length);
          return _buildPenerimaan(state.laporans);
        } else if (state is LaporanErrorState) {
          return _buildErrorUi(state.msg);
        } else {
          return _buildErrorUi(state.toString());
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

  Widget _buildPenerimaan(List<Penerimaan> penerimaans) {
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
                              await PdfInvoiceApi.generate(penerimaans);
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
                    width: 180.0,
                    child: _pageKlasifikasiBody(),
                  ),
                ],
              ),
            ),

            // _dropDownSearch(),
            SizedBox(height: 16),

            _laporanItemListNew(penerimaans),
          ],
        ),
      ),
    );
  }

  Widget _laporanItemList(List<Penerimaan> penerimaans) {
    if (penerimaans.length == 0) {
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
                    label: Text("KETERANGAN",
                        style: Theme.of(context).textTheme.subtitle1)),
              ],
              rows: penerimaans
                  .map((item) => DataRow(cells: [
                        DataCell(Text(
                            (penerimaans.indexOf(item) + 1).toString(),
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
                        DataCell(Text(item.rekanan!.name,
                            style: Theme.of(context).textTheme.caption)),
                      ]))
                  .toList()),
        ));
  }

  Container _laporanItemListNew(List<Penerimaan> penerimaans) {
    List<ItemPenerimaan> list = [];
    final groups = groupBy(penerimaans, (Penerimaan e) {
      return e.spkNo;
    });

    groups.forEach((key, value) {
      String key = "";
      String spkDate = "";
      String spkNo = "";
      String spmDate = "";
      String spmNo = "";
      String vendor = "";
      String keterangan = "";
      int subTotal = 0;

      List<Penerimaan> data;

      value.forEach((e) {
        key = e.spkNo;
        spkDate = e.spmDate;
        spkNo = e.spkDate;
        spmDate = e.spmDate;
        spmNo = e.spmNo;
        vendor = e.rekanan!.name;
        keterangan = "";
        subTotal += int.parse(e.barangPrice);
      });
      data = value;

      list.add(ItemPenerimaan(key, spkDate, spkNo, spmDate, spmNo, vendor,
          keterangan, subTotal, data));
    });

    return Container(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: list.length,
          itemBuilder: (context, index) {
            var data = list[index];

            print("data $data");

            return CardExpand(data);
          }),
    );
  }

  Widget _pageKlasifikasiBody() {
    return BlocBuilder<KlasifikasiBloc, KlasifikasiState>(
      builder: (context, state) {
        print("state $state");
        if (state is KLasifikasiLoadingState) {
          return _buildLoading();
        }
        if (state is KlasifikasiLoadedState) {
          // return _buildPenerimaan(state.laporans);
          print("KlasifikasiLoadedState state $state");

          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<bool>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: AppTheme.redBackgroundColor,
                        title: Text("Pilih Spesifikasi Barang"),
                      ),
                      body: WillPopScope(
                        onWillPop: () async {
                          Navigator.pop(context, false);
                          return false;
                        },
                        child: loadListKlasifikasi(state.klasifikasis),
                      ),
                    );
                  },
                ));
              },
              child: klasifikasiField());
        } else if (state is KlasifikasiErrorState) {
          return _buildErrorUi(state.msg);
        } else {
          return _buildErrorUi("Undefined");
        }
      },
    );
  }

  Container loadListKlasifikasi(List<Klasifikasi> list) {
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
                    _spesifikasiId = data.id.toString();
                    _spesifikasiIdLabel = data.name;
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

  Container klasifikasiField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: kHintTextColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$_spesifikasiIdLabel',
        style: const TextStyle(fontSize: 16),
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
}

class OutLineBtn extends StatefulWidget {
  final String btnText;

  const OutLineBtn({key, required this.btnText}) : super(key: key);

  @override
  _OutLineBtnState createState() => _OutLineBtnState();
}

class _OutLineBtnState extends State<OutLineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border.all(color: AppTheme.selectedTabBackgroundColor, width: 2),
          borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(15),
      child: Center(
        child:
            Text(widget.btnText, style: Theme.of(context).textTheme.headline6),
      ),
    );
  }
}

class ItemModel {
  String id;
  String value;
  ItemModel(this.id, this.value);
}

class CardExpand extends StatelessWidget {
  final ItemPenerimaan data;
  CardExpand(this.data);

  @override
  Widget build(BuildContext context) {
    buildItem(String label) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(data.key),
      );
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var i in data.data) buildItem("Item ${i.barang!.name}"),
        ],
      );
    }

    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToExpand: true,
                tapBodyToCollapse: true,
                hasIcon: false,
              ),
              header: Container(
                color: Colors.indigoAccent,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ExpandableIcon(
                            theme: const ExpandableThemeData(
                              expandIcon: Icons.arrow_right,
                              collapseIcon: Icons.arrow_drop_down,
                              iconColor: Colors.white,
                              iconSize: 28.0,
                              iconRotationAngle: math.pi / 2,
                              iconPadding: EdgeInsets.only(right: 5),
                              hasIcon: false,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Items ${data.key}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Items ${data.subTotal}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              collapsed: Container(),
              expanded: buildList(),
            ),
          ],
        ),
      ),
    ));
  }
}

class ItemPenerimaan {
  final String key;
  final String spkDate;
  final String spkNo;
  final String spmDate;
  final String spmNo;
  final String vendor;
  final String keterangan;
  final int subTotal;

  final List<Penerimaan> data;

  ItemPenerimaan(this.key, this.spkDate, this.spkNo, this.spmDate, this.spmNo,
      this.vendor, this.keterangan, this.subTotal, this.data);
}
