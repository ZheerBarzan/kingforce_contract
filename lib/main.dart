/// Security Guard Contract Generator
/// 
/// This application allows users to create professional PDF contracts for security guards.
/// Users can input guard details, and the app generates a formatted PDF contract that can be saved and printed.
/// 
/// Features:
/// - Input form for guard details (name, ID, address, etc.)
/// - Date picker for contract start date
/// - PDF generation with professional formatting
/// - File storage with proper permissions handling
/// - Cross-platform support (Android and iOS)

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:intl/intl.dart';

/// The main entry point of the application
void main() {
  runApp(const MyApp());
}

/// The root widget of the application
/// 
/// Sets up the basic app configuration including:
/// - App title
/// - Theme (using Material 3 with blue color scheme)
/// - Initial screen (SecurityGuardForm)
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

/// The main form widget that handles security guard contract creation
/// 
/// This widget manages the state of the form and handles:
/// - Form input validation
/// - Date selection
/// - PDF generation
/// - File storage
class SecurityGuardForm extends StatefulWidget {
  const SecurityGuardForm({super.key});

  @override
  State<SecurityGuardForm> createState() => _SecurityGuardFormState();
}

/// The state class for SecurityGuardForm
/// 
/// Manages:
/// - Form controllers for text input
/// - Form validation
/// - PDF generation logic
/// - File storage and permissions
class _SecurityGuardFormState extends State<SecurityGuardForm> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  /// Controllers for text input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  /// Shows a date picker dialog and sets the selected date
  /// 
  /// Parameters:
  /// - context: The build context
  /// 
  /// The date picker allows selection between 2000 and 2100,
  /// with the current date as the initial selection.
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

  /// Generates and saves the PDF contract
  /// 
  /// This method:
  /// 1. Checks and requests necessary permissions
  /// 2. Creates a PDF document with the guard's information
  /// 3. Saves the PDF to the device's storage
  /// 4. Opens the PDF for viewing
  /// 5. Shows success/error messages
  Future<void> _generatePDF() async {
    try {
      // Check and request storage permissions
      PermissionStatus status;
      if (Platform.isAndroid) {
        // Request storage permission for Android
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
        
        // Request media permission for Android 13+
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

      // Create PDF document
      final doc = pw.Document();

      // Add a page to the PDF with proper formatting
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Contract header
                pw.Header(
                  level: 0,
                  child: pw.Text('Security Guard Contract',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                ),
                // Guard's personal information
                pw.SizedBox(height: 20),
                pw.Text('This contract is made between KingForce Security and:'),
                pw.SizedBox(height: 10),
                pw.Text('Name: ${_nameController.text}'),
                pw.Text('ID Number: ${_idNumberController.text}'),
                pw.Text('Address: ${_addressController.text}'),
                pw.Text('Phone: ${_phoneController.text}'),
                // Contract details
                pw.SizedBox(height: 20),
                pw.Text('Contract Details:'),
                pw.Text('Start Date: ${_startDateController.text}'),
                pw.Text('Monthly Salary: \$${_salaryController.text}'),
                // Terms and conditions
                pw.SizedBox(height: 20),
                pw.Text('Terms and Conditions:'),
                pw.Text('1. The security guard agrees to maintain confidentiality.'),
                pw.Text('2. The security guard will work assigned shifts.'),
                pw.Text('3. The security guard will follow company policies.'),
                // Signature section
                pw.SizedBox(height: 20),
                pw.Text('Signature: ___________________'),
                pw.Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
              ],
            );
          },
        ),
      );

      // Get the directory to save the PDF
      Directory? directory;
      if (Platform.isAndroid) {
        // Try to save in Downloads folder first
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          // Fallback to external storage
          directory = await getExternalStorageDirectory();
        }
      } else {
        // For iOS, use app documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      // Save the PDF file
      final fileName = 'security_contract_${_nameController.text.replaceAll(' ', '_')}.pdf';
      final file = File('${directory.path}/$fileName');
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
      // Show error message if something goes wrong
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

  /// Builds the form UI
  /// 
  /// Creates a scrollable form with:
  /// - Text input fields for guard details
  /// - Date picker for contract start date
  /// - Generate Contract button
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
              // Full Name input field
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
              // ID Number input field
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
              // Address input field
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
              // Phone Number input field
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
              // Start Date input field with date picker
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
              // Monthly Salary input field
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
              // Generate Contract button
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

  /// Cleans up resources when the widget is disposed
  /// 
  /// Disposes of all text controllers to prevent memory leaks
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
