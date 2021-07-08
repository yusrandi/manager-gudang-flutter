import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gudang_manager/models/penerimaan_model.dart';
import 'package:gudang_manager/pdfapi/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceApi {
  static Future<File> generate(List<Penerimaan> penerimaans) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.landscape,
      build: (context) => [
        pw.Container(width: double.infinity, child: buildHeader() ),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        buildNavHeader(penerimaans[0]),
        pw.Divider(),
        buildTableView(penerimaans)

      ],
      
    ));

    return PdfApi.saveDocument(name: 'penerimaan.pdf', pdf: pdf);
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
  static buildNavHeader(Penerimaan penerimaan) {
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
  static buildTableView(List<Penerimaan> penerimaans) {

    final headers = [
      'Jenis Barang',
      'Tgl SPK',
      'No SPK',
      'Tgl SPM',
      'No SPM',
      'Qty',
      'Harga',
      'Total',

    ];
    final data = penerimaans.map((e){

     return [
       e.barang.name,
       e.spkDate,
       e.spkNo,
       e.spmDate == null ? "" : "",
       e.spmNo == null ? "" : "",
       e.barangQty+' '+e.satuan.name,
       "Rp. " +
           NumberFormat("#,##0", "en_US")
               .format(
               int.parse(e.barangPrice))
               .toString(),
       "Rp. " +
           NumberFormat("#,##0", "en_US")
               .format((int.parse(e.barangQty) *
               int.parse(e.barangPrice)))
               .toString(),

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
