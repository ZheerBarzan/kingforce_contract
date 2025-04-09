import 'package:flutter/material.dart';
import 'package:kingforce_contract/themes/theme_provider.dart';
import '../services/navigation_service.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
           DrawerHeader(
            decoration:  BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Generate Contract'),
            onTap: () {
              Navigator.pop(context); // Close the drawer first
              NavigationService.navigateTo('/generate');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer first
              NavigationService.navigateTo('/settings');
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer first
              NavigationService.navigateTo('/profile');
            },
          ),
        ],
      ),
    );
  }
} 