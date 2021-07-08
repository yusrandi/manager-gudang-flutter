import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudang_manager/bloc/klasifikasi_bloc/klasifikasi_bloc.dart';
import 'package:gudang_manager/bloc/laporan_bloc/laporan_bloc.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/pdfapi/pdf_api.dart';
import 'package:gudang_manager/pdfapi/pdf_invoice_api.dart';
import 'package:gudang_manager/repo/laporan_repository.dart';
import 'package:gudang_manager/res/styling.dart';
import 'package:gudang_manager/ui/widgets/primary_button.dart';
import 'package:intl/intl.dart';
import 'package:sweetalert/sweetalert.dart';

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
  String _semester = "01,12";
  String _tahun = DateFormat('yyyy').format(DateTime.now());

  List<ItemModel> listKlasifikasi = [];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LaporanBloc>(context);
    _klasifikasiBloc = BlocProvider.of<KlasifikasiBloc>(context);

    _bloc.add(FetchLaporanPenerimaanEvent(
        spesifikasiId: _spesifikasiId, semester: _semester, tahun: _tahun));

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
                'Penerimaan',
                style: Theme.of(context).primaryTextTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      body: _pageBody()
    );
  }
  Widget _pageBody() {
    return BlocListener<LaporanBloc, LaporanState>(
      listener: (context, state) {
        if (state is LaporanErrorState) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.msg)));
        }
      },
      child: BlocBuilder<LaporanBloc, LaporanState>(
        builder: (context, state) {
          print("state $state");
          if (state is LaporanInitialState) {
            return _buildLoading();
          } else if (state is LaporanLoadingState) {
            return _buildLoading();
          } else if (state is LaporanLoadedState) {
            return _buildPenerimaan(state.laporans);
          } else if (state is LaporanErrorState) {
            return _buildErrorUi(state.msg);
          } else {
            return _buildErrorUi("Undefined");
          }
        },
      ),
    );
  }
  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  void _alertSuccess() {
    SweetAlert.show(context,
        title: "Success",
        subtitle: "data loaded",
        style: SweetAlertStyle.success);
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
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: GestureDetector(
                    onTap: () async {
                      final pdfFile = await PdfInvoiceApi.generate(penerimaans);
                      PdfApi.openFile(pdfFile);
                    },
                    child: PrimaryButton(
                        btnText: "Export",
                        color: AppTheme.blueBackgroundColor))),
            SizedBox(height: 16),
            _dropDownSearch(),
            SizedBox(height: 16),
            _laporanItemList(penerimaans),
          ],
        ),
      ),
    );
  }
  Widget _dropDownSearch(){

    List<ItemModel> items = [
      ItemModel("01,12", "1 Tahun"),
      ItemModel("01,06", "Semester 1"),
      ItemModel("07,12", "Semester 2"),
    ];

    List<ItemModel> itemsYear = [];
    int date =  int.parse(DateFormat('yyyy').format(DateTime.now()));
    for(int i = date; i > (date-10); i--){
      itemsYear.add(ItemModel(i.toString(), i.toString()));
    }



    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _dropDownItems(items, "Priode", 0),
        _dropDownItems(itemsYear, "Tahun", 1),
        _pageKlasifikasiBody()
      ],
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
              headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey),
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
                    label: Text("QTY",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("HARGA",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("TOTAL",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("SISA",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("VENDOR",
                        style: Theme.of(context).textTheme.subtitle1)),
              ],
              rows: penerimaans
                  .map((item) => DataRow(cells: [
                        DataCell(Text(
                            (penerimaans.indexOf(item) + 1).toString(),
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.barang.name,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.spkDate,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.spkNo,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.spmDate == null ? "" : item.spmDate,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.spmNo == null ? "" : item.spmNo,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.barangQty + ' ' + item.satuan.name,
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
                        DataCell(Text(item.barangSisa + ' ' + item.satuan.name,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(item.rekanan.name,
                            style: Theme.of(context).textTheme.caption)),
                      ]))
                  .toList()),
        ));
  }
  Widget _dropDownItems(List<ItemModel> items, String msg, int index){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.redBackgroundColor, width: 1),
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        hint: Text(msg),
        items: items.map((ItemModel value) {
          return DropdownMenuItem<String>(
            value: value.id,
            child: new Text(value.value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
              if (index == 0) _semester = value!;
              else if (index == 1) _tahun = value!;
              else if (index == 2) _spesifikasiId = value!;

            _bloc.add(FetchLaporanPenerimaanEvent(spesifikasiId: _spesifikasiId, semester: _semester, tahun: _tahun));
          });
        },
      ),
    );
  }

  Widget _pageKlasifikasiBody(){
    return BlocListener<KlasifikasiBloc, KlasifikasiState>(
      listener: (context, state) {
        if (state is KlasifikasiErrorState) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.msg)));
        }
      },
      child: BlocBuilder<KlasifikasiBloc, KlasifikasiState>(
        builder: (context, state) {
          print("state $state");
          if(state is KLasifikasiLoadingState){
           return _buildLoading();
          }
          if (state is KlasifikasiLoadedState) {
            // return _buildPenerimaan(state.laporans);
            print("KlasifikasiLoadedState state $state");

            listKlasifikasi.clear();
            listKlasifikasi.add(ItemModel("", "Spesifikasi"));
            state.klasifikasis.forEach((element) {
              listKlasifikasi.add(ItemModel(element.id.toString(), element.name));
            });
            return _dropDownItems(listKlasifikasi, "Spesifikasi", 2);

          } else if (state is KlasifikasiErrorState) {
            return _buildErrorUi(state.msg);
          } else {
            return _buildErrorUi("Undefined");
          }
        },
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
class ItemModel{
  String id;
  String value;
  ItemModel(this.id, this.value);
}