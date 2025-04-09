import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/contract_model.dart';

class PDFService {
  static Future<List<int>> generateContractPDF(ContractModel contract) async {
    // Load the Noto Naskh Arabic font which supports Kurdish characters
    final ttf = await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf');
    final boldTtf = await rootBundle.load('assets/fonts/NotoNaskhArabic-Bold.ttf');

    final doc = pw.Document();

    // Add a page to the PDF with proper formatting
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Contract header
                pw.Header(
                  level: 0,
                  child: pw.Text('ڕێکەوتنامەی پارێزەر',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        font: pw.Font.ttf(boldTtf),
                      )),
                ),
                // Guard's personal information
                pw.SizedBox(height: 20),
                pw.Text('ئەم ڕێکەوتنامەیە لە نێوان کۆمپانیای پاراستنی کینگفۆرس و:',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                pw.SizedBox(height: 10),
                pw.Text('ناو: ${contract.name}',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                pw.Text('ژمارەی ناسنامە: ${contract.idNumber}',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                pw.Text('ناونیشان: ${contract.address}',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                pw.Text('ژمارەی مۆبایل: ${contract.phone}',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                // Contract details
                pw.SizedBox(height: 20),
                pw.Text('وردەکارییەکانی ڕێکەوتنامە:',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                pw.Text('بەرواری دەستپێکردن: ${contract.startDate}',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                pw.Text('مووچەی مانگانە: \$${contract.salary}',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                // Terms and conditions
                pw.SizedBox(height: 20),
                pw.Text('مەرج و ڕێساکان:',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                pw.Text('١. پارێزەرەکە پابەندە بە پاراستنی نهێنی.',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                pw.Text('٢. پارێزەرەکە لە کاتە دیاریکراوەکانی کاردا کار دەکات.',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                pw.Text('٣. پارێزەرەکە پابەندە بە یاسا و ڕێساکانی کۆمپانیا.',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                // Signature section
                pw.SizedBox(height: 20),
                pw.Text('واژۆ: ___________________',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
                pw.Text('بەروار: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                    style: pw.TextStyle(font: pw.Font.ttf(ttf))),
              ],
            ),
          );
        },
      ),
    );

    return await doc.save();
  }
} 