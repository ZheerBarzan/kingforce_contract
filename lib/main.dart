import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security Guard Contract',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SecurityGuardForm(),
    );
  }
}

class SecurityGuardForm extends StatefulWidget {
  const SecurityGuardForm({super.key});

  @override
  State<SecurityGuardForm> createState() => _SecurityGuardFormState();
}

class _SecurityGuardFormState extends State<SecurityGuardForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _generatePDF() async {
    try {
      // Check and request storage permission
      PermissionStatus status;
      if (Platform.isAndroid) {
        if (await Permission.storage.isDenied) {
          status = await Permission.storage.request();
          if (status.isDenied) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Storage permission is required to save the contract'),
                  duration: Duration(seconds: 5),
                ),
              );
            }
            return;
          }
        }
        
        // For Android 13 and above
        if (await Permission.photos.isDenied) {
          status = await Permission.photos.request();
          if (status.isDenied) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Media permission is required to save the contract'),
                  duration: Duration(seconds: 5),
                ),
              );
            }
            return;
          }
        }
      }

      final doc = pw.Document();

      // Create a page with proper margins and formatting
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text('Security Guard Contract',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 20),
                pw.Text('This contract is made between KingForce Security and:'),
                pw.SizedBox(height: 10),
                pw.Text('Name: ${_nameController.text}'),
                pw.Text('ID Number: ${_idNumberController.text}'),
                pw.Text('Address: ${_addressController.text}'),
                pw.Text('Phone: ${_phoneController.text}'),
                pw.SizedBox(height: 20),
                pw.Text('Contract Details:'),
                pw.Text('Start Date: ${_startDateController.text}'),
                pw.Text('Monthly Salary: \$${_salaryController.text}'),
                pw.SizedBox(height: 20),
                pw.Text('Terms and Conditions:'),
                pw.Text('1. The security guard agrees to maintain confidentiality.'),
                pw.Text('2. The security guard will work assigned shifts.'),
                pw.Text('3. The security guard will follow company policies.'),
                pw.SizedBox(height: 20),
                pw.Text('Signature: ___________________'),
                pw.Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
              ],
            );
          },
        ),
      );

      // Get the application documents directory
      Directory? directory;
      if (Platform.isAndroid) {
        // Try to get the downloads directory first
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          // Fallback to external storage directory
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      final fileName = 'security_contract_${_nameController.text.replaceAll(' ', '_')}.pdf';
      final file = File('${directory.path}/$fileName');
      
      // Save the PDF file
      final bytes = await doc.save();
      await file.writeAsBytes(bytes);
      
      // Open the PDF file
      final result = await OpenFile.open(file.path);
      
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contract generated successfully! Saved as: $fileName'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error generating PDF: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating contract: ${e.toString()}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Guard Contract'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idNumberController,
                decoration: const InputDecoration(
                  labelText: 'ID Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ID number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectDate(context),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the start date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Salary',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the salary';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _generatePDF();
                  }
                },
                child: const Text('Generate Contract'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idNumberController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _startDateController.dispose();
    _salaryController.dispose();
    super.dispose();
  }
}
