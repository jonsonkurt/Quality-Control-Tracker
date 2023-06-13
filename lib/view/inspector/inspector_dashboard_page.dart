import 'package:flutter/material.dart';

import 'inspector_profile_page.dart';

class InspectorDashboardPage extends StatefulWidget {
  const InspectorDashboardPage({super.key});

  @override
  State<InspectorDashboardPage> createState() => _InspectorDashboardPageState();
}

class _InspectorDashboardPageState extends State<InspectorDashboardPage> {
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
                      builder: (context) => const InspectorProfilePage()));
            },
            icon: const Icon(
              Icons.account_circle,
              color: Colors.purple,
            ),
          ),
        ],
      ),
      body: const Text('Inspector Dashboard'),
    );
  }
}
