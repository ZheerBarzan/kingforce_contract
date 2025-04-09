import 'package:flutter/material.dart';
import '../models/contract_model.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/permission_service.dart';

class ContractViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDateController.text = picked.toString().split(' ')[0];
      notifyListeners();
    }
  }

  Future<void> generatePDF(BuildContext context) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Check and request permissions
      final hasPermissions = await PermissionService.requestStoragePermissions();
      if (!hasPermissions) {
        _errorMessage = 'دەسەڵاتی پاشەکەوتکردن پێویستە';
        return;
      }

      // Create contract model
      final contract = ContractModel(
        name: nameController.text,
        idNumber: idNumberController.text,
        address: addressController.text,
        phone: phoneController.text,
        startDate: startDateController.text,
        salary: salaryController.text,
      );

      // Generate PDF
      final pdfBytes = await PDFService.generateContractPDF(contract);

      // Save and open PDF
      final fileName = 'security_contract_${nameController.text.replaceAll(' ', '_')}.pdf';
      final filePath = await StorageService.savePDF(pdfBytes, fileName);
      await StorageService.openFile(filePath);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ڕێکەوتنامە بە سەرکەوتوویی دروستکرا! ناوی فایل: $fileName'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      _errorMessage = 'هەڵە لە دروستکردنی ڕێکەوتنامە: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    idNumberController.dispose();
    addressController.dispose();
    phoneController.dispose();
    startDateController.dispose();
    salaryController.dispose();
    super.dispose();
  }
} 