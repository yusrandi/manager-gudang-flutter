import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/bloc/bagian_bloc/bagian_bloc.dart';
import 'package:gudang_manager/bloc/klasifikasi_bloc/klasifikasi_bloc.dart';
import 'package:gudang_manager/bloc/laporan_bloc/laporan_bloc.dart';
import 'package:gudang_manager/models/bagian.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/models/pengeluaran.dart';
import 'package:gudang_manager/pdfapi/pdf_invoice_api.dart';
import 'package:gudang_manager/repo/bagian_repository.dart';
import 'package:gudang_manager/repo/laporan_repository.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/penerimaan_page.dart';
import 'package:gudang_manager/ui/widgets/primary_button.dart';
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

  String _spesifikasiId = "";
  String _bagianId = "";
  String _semester = "01,12";
  String _tahun = DateFormat('yyyy').format(DateTime.now());

  List<ItemModel> listKlasifikasi = [];
  List<ItemModel> listBagian = [];

  String _semesterDropdownValue = "Priode";
  String _tahunDropdownValue = "Tahun";
  String _spesifikasiDropdownValue = "Spesifikasi";
  String _bagianDropdownValue = "Bagian";

  late Size _screenSize;

  @override
  void initState() {
    super.initState();

    _bloc = BlocProvider.of<LaporanBloc>(context);
    _klasifikasiBloc = BlocProvider.of<KlasifikasiBloc>(context);
    _bagianBloc = BlocProvider.of<BagianBloc>(context);

    _bloc.add(FetchLaporanPengeluaranEvent(
        spesifikasiId: _spesifikasiId,
        bagianId: _bagianId,
        semester: _semester,
        tahun: _tahun));

    _klasifikasiBloc.add(FetchKlasifikasiEvent());
    _bagianBloc.add(FetchBagianEvent());
  }

  @override
  Widget build(BuildContext context) {
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
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: GestureDetector(
                    onTap: () async {},
                    child: PrimaryButton(
                        btnText: "Export",
                        color: AppTheme.blueBackgroundColor))),
            SizedBox(height: 16),
            _dropDownSearch(),
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
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.msg)));
        }
      },
      child: BlocBuilder<LaporanBloc, LaporanState>(
        builder: (context, state) {
          print("_loadPengeluaran state $state");
          if (state is LaporanInitialState || state is LaporanLoadingState) {
            return _buildLoading();
          } else if (state is LaporanLoadedStatePengeluaran) {
            print(state.laporans.length);
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

  Widget _dropDownSearch() {
    List<ItemModel> listPeriode = [];
    listPeriode.add(ItemModel("Priode", "Priode"));
    listPeriode.add(ItemModel("01,12", "1 Tahun"));
    listPeriode.add(ItemModel("01,06", "Semester 1"));
    listPeriode.add(ItemModel("07,12", "Semester 2"));

    List<ItemModel> listTahun = [];
    listTahun.add(ItemModel("Tahun", "Tahun"));
    int date = int.parse(DateFormat('yyyy').format(DateTime.now()));
    for (int i = date; i > (date - 10); i--) {
      listTahun.add(ItemModel(i.toString(), i.toString()));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1, child: _dropDownItemsSemester(listPeriode)),
            SizedBox(width: 8),
            Expanded(flex: 1, child: _dropDownItemsTahun(listTahun)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1, child: _loadSpesifikasi()),
            SizedBox(width: 8),
            Expanded(flex: 1, child: _loadBagian()),
          ],
        ),
      ],
    );
  }

  Widget _loadSpesifikasi() {
    return BlocListener<KlasifikasiBloc, KlasifikasiState>(
      listener: (context, state) {
        if (state is KlasifikasiErrorState) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.msg)));
        }
      },
      child: BlocBuilder<KlasifikasiBloc, KlasifikasiState>(
        builder: (context, state) {
          print("_loadSpesifikasi state $state");
          if (state is KLasifikasiLoadingState) {
            return _buildLoading();
          }
          if (state is KlasifikasiLoadedState) {
            // return _buildPenerimaan(state.laporans);
            // print("KlasifikasiLoadedState state $state");
            List<ItemModel> list = [];
            list.add(ItemModel("Spesifikasi", "Spesifikasi"));
            state.klasifikasis.forEach((element) {
              list.add(ItemModel(element.id.toString(), element.name));
            });
            return _dropDownItemSpesifikasi(list);
          } else if (state is KlasifikasiErrorState) {
            return _buildErrorUi(state.msg);
          } else {
            return _buildErrorUi("Undefined");
          }
        },
      ),
    );
  }

  Widget _loadBagian() {
    return BlocListener<BagianBloc, BagianState>(
      listener: (context, state) {
        if (state is BagianErrorState) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.msg)));
        }
      },
      child: BlocBuilder<BagianBloc, BagianState>(
        builder: (context, state) {
          // print("state $state");
          if (state is BagianLoadingState) {
            return _buildLoading();
          }
          if (state is BagianLoadedState) {
            // return _buildPenerimaan(state.laporans);
            // print("BagianLoadedState state $state");
            List<ItemModel> list = [];
            list.add(ItemModel("Bagian", "Bagian"));
            state.bagians.forEach((element) {
              list.add(ItemModel(element.id.toString(), element.name));
            });
            return _dropDownItemBagian(list);
          } else if (state is BagianErrorState) {
            return _buildErrorUi(state.msg);
          } else {
            return _buildErrorUi("Undefined");
          }
        },
      ),
    );
  }

  Widget _dropDownItemsSemester(List<ItemModel> list) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.hintTextColor, width: 1),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        value: _semesterDropdownValue,
        hint: Text("Priode"),
        items: list.map((ItemModel value) {
          return DropdownMenuItem<String>(
            value: value.id,
            child: new Text(value.value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _semesterDropdownValue = newValue!;
            _semester = newValue == "Priode" ? "" : newValue;
            // resKategoriId = value.toString();

            print(_semester);
            _bloc.add(FetchLaporanPengeluaranEvent(
                spesifikasiId: _spesifikasiId,
                bagianId: _bagianId,
                semester: _semester,
                tahun: _tahun));
          });
        },
      ),
    );
  }

  Widget _dropDownItemsTahun(List<ItemModel> list) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.hintTextColor, width: 1),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        value: _tahunDropdownValue,
        hint: Text("Tahun"),
        items: list.map((ItemModel value) {
          return DropdownMenuItem<String>(
            value: value.id,
            child: new Text(value.value),
          );
        }).toList(),
        onChanged: (newValue) {
          _tahun = newValue! == "Tahun" ?  "" : newValue;

          _bloc.add(FetchLaporanPengeluaranEvent(
              spesifikasiId: _spesifikasiId,
              bagianId: _bagianId,
              semester: _semester,
              tahun: _tahun));

          setState(() {
            _tahunDropdownValue = newValue;
            // resKategoriId = value.toString();
          });
        },
      ),
    );
  }

  Widget _dropDownItemSpesifikasi(List<ItemModel> list) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.hintTextColor, width: 1),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        value: _spesifikasiDropdownValue,
        hint: Text("Spesifikasi"),
        items: list.map((ItemModel value) {
          return DropdownMenuItem<String>(
            value: value.id.toString(),
            child: new Text(value.value),
          );
        }).toList(),
        onChanged: (newValue) {
          print(newValue);
          setState(() {
            _spesifikasiDropdownValue = newValue!;
            // resKategoriId = value.toString();
            _spesifikasiId = newValue == "Spesifikasi" ? "" : newValue;
          });

          _bloc.add(FetchLaporanPengeluaranEvent(
              spesifikasiId: _spesifikasiId,
              bagianId: _bagianId,
              semester: _semester,
              tahun: _tahun));
        },
      ),
    );
  }

  Widget _dropDownItemBagian(List<ItemModel> list) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.hintTextColor, width: 1),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        value: _bagianDropdownValue,
        hint: Text("Bagian"),
        items: list.map((ItemModel value) {
          return DropdownMenuItem<String>(
            value: value.id.toString(),
            child: new Text(value.value),
          );
        }).toList(),
        onChanged: (newValue) {
          print(newValue);

          setState(() {
            _bagianDropdownValue = newValue!;
            // resKategoriId = value.toString();
            _bagianId = newValue == "Bagian" ? "" : newValue;
          });

          _bloc.add(FetchLaporanPengeluaranEvent(
              spesifikasiId: _spesifikasiId,
              bagianId: _bagianId,
              semester: _semester,
              tahun: _tahun));
        },
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