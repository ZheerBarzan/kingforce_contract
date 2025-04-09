import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const Sidebar(),
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
} 