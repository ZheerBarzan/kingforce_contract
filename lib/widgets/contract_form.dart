import 'package:flutter/material.dart';
import '../viewmodels/contract_viewmodel.dart';

class ContractForm extends StatelessWidget {
  final ContractViewModel viewModel;
  final GlobalKey<FormState> formKey;

  const ContractForm({
    super.key,
    required this.viewModel,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: viewModel.nameController,
            decoration: const InputDecoration(
              labelText: 'ناو',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'تکایە ناو بنووسە';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: viewModel.idNumberController,
            decoration: const InputDecoration(
              labelText: 'ژمارەی ناسنامە',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'تکایە ژمارەی ناسنامە بنووسە';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: viewModel.addressController,
            decoration: const InputDecoration(
              labelText: 'ناونیشان',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'تکایە ناونیشان بنووسە';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: viewModel.phoneController,
            decoration: const InputDecoration(
              labelText: 'ژمارەی مۆبایل',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'تکایە ژمارەی مۆبایل بنووسە';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: viewModel.startDateController,
            decoration: const InputDecoration(
              labelText: 'بەرواری دەستپێکردن',
              border: OutlineInputBorder(),
            ),
            onTap: () => viewModel.selectDate(context),
            readOnly: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'تکایە بەرواری دەستپێکردن هەڵبژێرە';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: viewModel.salaryController,
            decoration: const InputDecoration(
              labelText: 'مووچەی مانگانە',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'تکایە مووچە بنووسە';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: viewModel.isLoading
                ? null
                : () {
                    if (formKey.currentState!.validate()) {
                      viewModel.generatePDF(context);
                    }
                  },
            child: viewModel.isLoading
                ? const CircularProgressIndicator()
                :  Text('دروستکردنی ڕێکەوتنامە',
                    style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.inversePrimary)),
          ),
          if (viewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                viewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
} 