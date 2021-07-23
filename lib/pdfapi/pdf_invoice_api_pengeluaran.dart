import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gudang_manager/models/pengeluaran.dart';
import 'package:gudang_manager/pdfapi/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceApiPengeluaran {
  static Future<File> generate(List<Pengeluaran> pengeluarans) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.landscape,
      build: (context) => [
        pw.Container(width: double.infinity, child: buildHeader() ),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        // buildNavHeader(pengeluarans[0]),
        pw.Divider(),
        buildTableView(pengeluarans)

      ],
      
    ));

    return PdfApi.saveDocument(name: 'Pengeluaran.pdf', pdf: pdf);
  }

  static buildHeader(){
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        pw.Text( 'DAFTAR HASIL PENGADAAN BARANG MILIK DAERAH (DHPBMD)'),
        pw.Text( 'SEMESTER 1 dan 2 (JANUARI S/D DESEMBER 20__)'),
      ],
    );
  }
  static buildNavHeader(Pengeluaran pengeluaran) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
            children: [
              pw.Container(width: 100, child: pw.Text("SKPD", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Text(": Sekretariat DPRD Prov. SulSel"),
            ]
        ),
        pw.Row(
            children: [
              pw.Container(width: 100, child: pw.Text("KAB/KOTA", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Text(": Makassar"),
            ]
        ),
        pw.Row(
            children: [
              pw.Container(width: 100, child: pw.Text("PROVINSI", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Text(": Sulawesi Selatan "),
            ]
        )
      ],
    );
  }
  static buildTableView(List<Pengeluaran> pengeluarans) {

    final headers = [
      'No Surat/Nota',
      'Nama Barang',
      'Jumlah',
      'Harga',
      'Total',
      'Penerima',
      'Unit Bagian',

    ];
    final data = pengeluarans.map((e){

     return [
       e.notaNo,
       e.penerimaan!.barang!.name,
       e.qty+' '+e.penerimaan!.satuan!.name,
       "Rp. " +
           NumberFormat("#,##0", "en_US")
               .format(
               int.parse(e.penerimaan!.barangPrice))
               .toString(),
       
       "Rp. " +
           NumberFormat("#,##0", "en_US")
               .format(
               int.parse((int.parse(e.qty) * int.parse(e.penerimaan!.barangPrice)).toString()))
               .toString(),
       
       e.penerima,
       e.bagian!.name
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
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
        },

      ));
  }
}
