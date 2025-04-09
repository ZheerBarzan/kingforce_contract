import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                'کینگفۆرس',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('دروستکردنی ڕێکەوتنامە'),
            onTap: () {
              NavigationService.navigateTo('/generate');
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('ڕێکخستنەکان'),
            onTap: () {
              NavigationService.navigateTo('/settings');
              Navigator.pop(context); // Close the drawer
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('پڕۆفایل'),
            onTap: () {
              NavigationService.navigateTo('/profile');
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
} 