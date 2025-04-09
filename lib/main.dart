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
import 'package:kingforce_contract/themes/theme_provider.dart';
import 'viewmodels/contract_viewmodel.dart';
import 'widgets/contract_form.dart';
import 'widgets/sidebar.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'services/navigation_service.dart';
import 'package:provider/provider.dart';

/// The main entry point of the application
void main() {
   runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
   
  ], child: const MyApp()));
}

/// The root widget of the application
/// 
/// Sets up the basic app configuration including:
/// - App title
/// - Theme (using Material 3 with blue color scheme)
/// - Initial screen (SplashScreen)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Security Guard Contract',
      navigatorKey: NavigationService.navigatorKey,
            theme: Provider.of<ThemeProvider>(context).themeData,

      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/generate': (context) => const ContractScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
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
class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

/// The state class for ContractScreen
/// 
/// Manages:
/// - Form controllers for text input
/// - Form validation
/// - PDF generation logic
/// - File storage and permissions
class _ContractScreenState extends State<ContractScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ContractViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ContractViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ڕێکەوتنامەی پارێزەر'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ContractForm(
          viewModel: _viewModel,
          formKey: _formKey,
        ),
      ),
    );
  }
}
