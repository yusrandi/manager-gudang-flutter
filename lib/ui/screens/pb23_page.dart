import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/bloc/klasifikasi_bloc/klasifikasi_bloc.dart';
import 'package:gudang_manager/bloc/laporan_bloc/laporan_bloc.dart';
import 'package:gudang_manager/models/pb23_model.dart';
import 'package:gudang_manager/models/rekapitulasi_model.dart';
import 'package:gudang_manager/pdfapi/pdf_api.dart';
import 'package:gudang_manager/pdfapi/pdf_api_Pb23.dart';
import 'package:gudang_manager/repo/laporan_repository.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/screens/penerimaan_page.dart';
import 'package:gudang_manager/ui/widgets/primary_button.dart';
import 'package:intl/intl.dart';

class Pb23LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LaporanBloc(LaporanRepositoryImpl()),
      child: BlocProvider(
        create: (context) => KlasifikasiBloc(LaporanRepositoryImpl()),
        child: Pb23Page(),
      ),
    );
  }
}

class Pb23Page extends StatefulWidget {
  @override
  _Pb23PageState createState() => _Pb23PageState();
}

class _Pb23PageState extends State<Pb23Page> {
  late LaporanBloc _bloc;
  late KlasifikasiBloc _klasifikasiBloc;

  String _spesifikasiId = "";
  String _tahun = DateFormat('yyyy').format(DateTime.now());

  String _tahunDropdownValue = "Tahun";
  String _spesifikasiDropdownValue = "Spesifikasi";

  List<ItemModel> listKlasifikasi = [];
  List<Pb23> list = [];

  @override
  void initState() {
    super.initState();

    _bloc = BlocProvider.of<LaporanBloc>(context);
    _klasifikasiBloc = BlocProvider.of<KlasifikasiBloc>(context);
    _bloc.add(
        FetchLaporanEventPb23(spesifikasiId: _spesifikasiId, tahun: _tahun));

    _klasifikasiBloc.add(FetchKlasifikasiEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          backgroundColor: AppTheme.redBackgroundColor,
          title: Container(
            child: Row(
              children: [
                Text(
                  'Persediaan Barang B.23',
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
                    onTap: () async {
                      final pdfFile = await PdfApiPb23.generate(list);
                      PdfApi.openFile(pdfFile);
                    },
                    child: PrimaryButton(
                        btnText: "Export",
                        color: AppTheme.blueBackgroundColor))),
            SizedBox(
              height: 16,
            ),
            _dropDownSearch(),
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
          } else if (state is LaporanLoadedStatePb23) {
            list = state.laporans;

            return _buildLaporan(state.laporans);
          } else if (state is LaporanErrorState) {
            return _buildErrorUi(state.msg);
          } else {
            return _buildErrorUi("Undefined");
          }
        },
      ),
    );
  }

  Widget _buildLaporan(List<Pb23> list) {
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
                  label: Text("Tanggal",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Jenis Barang",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Barang Masuk",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Barang Keluar",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Sisa",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Harga Satuan",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Bertambah",
                      style: Theme.of(context).textTheme.subtitle1)),
              DataColumn(
                  label: Text("Berkurang",
                      style: Theme.of(context).textTheme.subtitle1)),
            ],
            rows: list
                .map(
                  (e) => DataRow(cells: [
                    DataCell(Text((list.indexOf(e) + 1).toString(),
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(e.date,
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(e.penerimaan!.barang!.name,
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        e.status == 1
                            ? e.qty + ' ' + e.penerimaan!.satuan!.name
                            : '0',
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        e.status == 1
                            ? '0'
                            : e.qty + ' ' + e.penerimaan!.satuan!.name,
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(e.sisa + ' ' + e.penerimaan!.satuan!.name,
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        "Rp. " +
                            NumberFormat("#,##0", "en_US")
                                .format(int.parse(e.penerimaan!.barangPrice)),
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        e.status == 1
                            ? "Rp. " +
                                NumberFormat("#,##0", "en_US").format(int.parse(
                                    (int.parse(e.qty) *
                                            int.parse(
                                                e.penerimaan!.barangPrice))
                                        .toString()))
                            : '0',
                        style: Theme.of(context).textTheme.caption)),
                    DataCell(Text(
                        e.status == 1
                            ? '0'
                            : "Rp. " +
                                NumberFormat("#,##0", "en_US").format(int.parse(
                                    (int.parse(e.qty) *
                                            int.parse(
                                                e.penerimaan!.barangPrice))
                                        .toString())),
                        style: Theme.of(context).textTheme.caption)),
                  ]),
                )
                .toList()),
      ),
    );
  }

  Widget _loadSpesifikasi() {
    return BlocListener<KlasifikasiBloc, KlasifikasiState>(
      listener: (context, state) {
        if (state is KlasifikasiErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.msg)));
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

          _bloc.add(FetchLaporanEventPb23(
              spesifikasiId: _spesifikasiId, tahun: _tahun));
        },
      ),
    );
  }

  Widget _dropDownSearch() {
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
            Expanded(flex: 1, child: _loadSpesifikasi()),
            SizedBox(width: 8),
            Expanded(flex: 1, child: _dropDownItemsTahun(listTahun)),
          ],
        ),
      ],
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
          _tahun = newValue! == "Tahun" ? "" : newValue;

          _bloc.add(FetchLaporanEventPb23(
              spesifikasiId: _spesifikasiId, tahun: _tahun));

          setState(() {
            _tahunDropdownValue = newValue;
            // resKategoriId = value.toString();
          });
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
