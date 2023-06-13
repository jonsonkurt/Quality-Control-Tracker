import 'package:flutter/material.dart';
import 'package:quality_control_tracker/view/admin/admin_profile_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color(0xFF221540),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // ignore: use_build_context_synchronously
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminProfilePage()));
            },
            icon: const Icon(
              Icons.account_circle,
              color: Colors.purple,
            ),
          ),
        ],
      ),
      body: const Text('Admin Dashboard'),
    );
  }
}