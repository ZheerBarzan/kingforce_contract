import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ڕێکخستنەکان'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const Sidebar(),
      body: const Center(
        child: Text('ڕێکخستنەکان'),
      ),
    );
  }
} 