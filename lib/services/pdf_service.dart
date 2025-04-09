import 'package:flutter/services.dart';
//import 'package:pdf/pdf.dart';
//import 'package:pdf/widgets.dart' as pw;
import 'package:kurdish_pdf/pdf.dart';
import 'package:kurdish_pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/contract_model.dart';

class PDFService {
  static Future<List<int>> generateContractPDF(ContractModel contract) async {
    // Load the Kurdish font
    //final fontData = await rootBundle.load('assets/fonts/Unikuweb.ttf'); dosent work
    final fontData = await rootBundle.load('assets/fonts/arial.ttf'); //dosent work
    //final fontData = await rootBundle.load('assets/fonts/ScheherazadeNew-Regular.ttf'); dosent work
    //final fontData = await rootBundle.load('assets/fonts/Amiri-Regular.ttf'); dosent work
    //final fontData = await rootBundle.load('assets/fonts/shasenem-mehwi.ttf'); dosent work
    //final fontData = await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf'); dosent work
   // final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'); deosnt work



    final customFont = pw.Font.ttf(fontData.buffer.asByteData());

    // Create PDF document with proper text direction
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        textDirection: pw.TextDirection.rtl, // Set RTL at page level
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title with larger font size for emphasis
              pw.Center(
                child: pw.Text('ڕێکەوتنامەی پارێزەر',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      font: customFont,
                    )),
              ),
              pw.SizedBox(height: 20),
              pw.Text('ئەم ڕێکەوتنامەیە لە نێوان کۆمپانیا ی پاراستنی کینگفۆرس و:',
                  style: pw.TextStyle(font: customFont, fontSize: 12)),
              pw.SizedBox(height: 10),
              
              // Contract details with consistent styling
              _buildDetailRow('ناو:', contract.name, customFont),
              _buildDetailRow('ژمارەی ناسنامە:', contract.idNumber, customFont),
              _buildDetailRow('ناونیشان:', contract.address, customFont),
              _buildDetailRow('ژمارەی مۆبایل:', contract.phone, customFont),
              
              pw.SizedBox(height: 20),
              pw.Text('وردەکارییەکانی ڕێکەوتنامە:', 
                  style: pw.TextStyle(font: customFont, fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              _buildDetailRow('بەروار ی دەستپێکردن:', contract.startDate, customFont),
              _buildDetailRow('مووچەی مانگانە:', '\$${contract.salary}', customFont),
              
              pw.SizedBox(height: 20),
              pw.Text('مەرج و ڕێساکان:', 
                  style: pw.TextStyle(font: customFont, fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              
              // Rules with proper numbering and consistent styling
              pw.Padding(
                padding: const pw.EdgeInsets.only(right: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('١. پارێزەرەکە پابەندە بە پاراستنی نهێنی.', 
                        style: pw.TextStyle(font: customFont)),
                    pw.Text('٢. پارێزەرەکە لە کاتە دیاریکراوەکانی کاردا کار دەکات.', 
                        style: pw.TextStyle(font: customFont)),
                    pw.Text('٣. پارێزەرەکە پابەندە بە یاسا و ڕێساکانی کۆمپانیا.', 
                        style: pw.TextStyle(font: customFont)),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 40),
              _buildSignatureLine('واژۆ:', '___________________', customFont),
              _buildDetailRow('بەروار:', DateFormat('yyyy-MM-dd').format(DateTime.now()), customFont),
            ],
          );
        },
      ),
    );

    return await doc.save();
  }
  
  // Helper method to create consistent detail rows
  static pw.Widget _buildDetailRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 5),
          pw.Text(value, style: pw.TextStyle(font: font)),
        ],
      ),
    );
  }
  
  // Helper method for signature line
  static pw.Widget _buildSignatureLine(String label, String placeholder, pw.Font font) {
    return pw.Row(
      children: [
        pw.Text(label, style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(width: 5),
        pw.Text(placeholder, style: pw.TextStyle(font: font)),
      ],
    );
  }
}