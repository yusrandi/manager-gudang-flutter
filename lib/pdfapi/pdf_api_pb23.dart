import 'dart:io';

import 'package:gudang_manager/models/pb23_model.dart';
import 'package:gudang_manager/pdfapi/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApiPb23 {
  static Future<File> generate(List<Pb23> list) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.landscape,
      build: (context) => [
        pw.Container(width: double.infinity, child: buildHeader() ),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        // buildNavHeader(pengeluarans[0]),
        pw.Divider(),
        buildTableView(list)

      ],
      
    ));

    return PdfApi.saveDocument(name: 'Persediaan Barang B.23.pdf', pdf: pdf);
  }

  static buildHeader(){
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        pw.Text( 'KARTU BARANG'),
        pw.Text( 'SEKRETARIAT DPRD PROVINSI SULAWESI SELATAN'),
      ],
    );
  }
  static buildTableView(List<Pb23> list) {

    final headers = [
      'Tanggal',
      'Jenis Barang',
      'Barang Masuk',
      'Barang Keluar',
      'Sisa',
      'Harga Satuan',
      'Bertambah',
      'Berkurang',
    ];
    final data = list.map((e){

     return [
       e.date,
       e.penerimaan!.barang!.name,
       e.status == 1 ? e.qty+' '+e.penerimaan!.satuan!.name : '0',
       e.status == 1 ? '0' : e.qty+' '+e.penerimaan!.satuan!.name ,
       e.sisa,
        "Rp. " +
                              NumberFormat("#,##0", "en_US")
                                  .format(int.parse(e.penerimaan!.barangPrice)),
        e.status == 1
                            ? "Rp. " +
                              NumberFormat("#,##0", "en_US")
                                  .format(int.parse((int.parse(e.qty) * int.parse(e.penerimaan!.barangPrice)).toString()))
                            : '0',
        e.status == 1
                            ?  '0' : "Rp. " +
                              NumberFormat("#,##0", "en_US")
                                  .format(int.parse((int.parse(e.qty) * int.parse(e.penerimaan!.barangPrice)).toString())),
        ];
    }).toList();
    return pw.Container(
      child: pw.Table.fromTextArray(
        headers: headers,
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
          data: data,
        border: null,

        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerLeft,
          3: pw.Alignment.centerLeft,
          4: pw.Alignment.centerLeft,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
          7: pw.Alignment.centerRight,
        },

      ));
  }
}