import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
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

    // _bloc.add(FetchLaporanPenerimaanEvent(
    //     spesifikasiId: _spesifikasiId, semester: _semester, tahun: _tahun));
  }

  @override
  Widget build(BuildContext context) {
    // print("build");

    _bloc.add(FetchLaporanPenerimaanEvent(
        spesifikasiId: _spesifikasiId, semester: _semester, tahun: _tahun));
    return Scaffold(
        appBar: AppBar(
          // brightness: Brightness.light,
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
        spkDate = e.spkDate;
        spkNo = e.spkNo;
        spmDate = e.spmDate;
        spmNo = e.spmNo;
        vendor = e.rekanan!.name;
        keterangan = "";
        subTotal += int.parse(e.barangPrice) * int.parse(e.barangQty);
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
    print(data.spkNo);
    buildItem(Penerimaan p) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text("Jenis Barang",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 1,
                    child: Text("Jumlah Barang",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 1,
                    child: Text("Harga Barang",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text(p.barang!.name,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 1,
                    child: Text("${p.barangQty} ${p.satuan!.name}",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 1,
                    child: Text(
                        "Rp. " +
                            NumberFormat("#,##0", "en_US")
                                .format(int.parse(p.barangPrice)),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold))),
              ],
            ),
            SizedBox(height: 16),
            Text(
                "Rp. " +
                    NumberFormat("#,##0", "en_US").format(
                        int.parse(p.barangPrice) * int.parse(p.barangQty)),
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(),
          ],
        ),
      );
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var i in data.data) buildItem(i),
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(child: Container()),
                          Container(
                            width: 80,
                            child: Text("Tanggal", textAlign: TextAlign.end),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 100,
                            child: Text("Nomor", textAlign: TextAlign.end),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(child: Text("SPK/Perjanjian/Kontrak")),
                          Container(
                            width: 80,
                            child: Text(data.spkDate,
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.black54)),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 100,
                            child: Text(data.spkNo,
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.black54)),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(child: Text("DPA/SPM/Kwitansi")),
                          Container(
                            width: 80,
                            child: Text(
                                data.spmDate != null ? data.spmDate : '-',
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.black54)),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 100,
                            child: Text(data.spmNo != null ? data.spmNo : '-',
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.black54)),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Vendor"),
                          Text(data.vendor,
                              style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Keterangan"),
                          Text("-", style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sub Total"),
                          Text(
                              "Rp. " +
                                  NumberFormat("#,##0", "en_US")
                                      .format(data.subTotal),
                              style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                      Divider(),
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

  Container listContainer(
      BuildContext context, double width, String title, String value) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            "$value",
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
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
