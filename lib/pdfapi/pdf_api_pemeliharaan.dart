import 'dart:io';
import 'package:gudang_manager/models/pemeliharaan_model.dart';
import 'package:gudang_manager/pdfapi/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceApiPemeliharaan {
  static Future<File> generate(
      List<Pemeliharaan> pemeliharaans, String tahun) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.landscape,
      build: (context) => [
        pw.Container(width: double.infinity, child: buildHeader(tahun)),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        buildNavHeader(pemeliharaans[0]),
        pw.Divider(),
        buildTableView(pemeliharaans)
      ],
    ));

    return PdfApi.saveDocument(name: 'Pemeliharaan.pdf', pdf: pdf);
  }

  static buildHeader(String tahun) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        pw.Text('DAFTAR REALISASI HASIL PENGADAAN BARANG / JASA'),
        pw.Text('TAHUN $tahun'),
      ],
    );
  }

  static buildNavHeader(Pemeliharaan pemeliharaan) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(children: [
          pw.Container(
              child: pw.Text(
                  "SKPD : DINAS KEPENDUDUKAN DAN PENCATATAN SIPIL PROVINSI SULAWESI SELATAN",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        ]),
      ],
    );
  }

  static buildTableView(List<Pemeliharaan> pemeliharaans) {
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
    final data = pemeliharaans.map((e) {
      return [
        e.barang!.name,
        e.spkDate,
        e.spkNo,
        e.spmDate,
        e.spmNo,
        e.barangQty + ' ' + e.satuan!.name,
        "Rp. " +
            NumberFormat("#,##0", "en_US")
                .format(int.parse(e.barangPrice))
                .toString(),
        "Rp. " +
            NumberFormat("#,##0", "en_US")
                .format((int.parse(e.barangQty) * int.parse(e.barangPrice)))
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
