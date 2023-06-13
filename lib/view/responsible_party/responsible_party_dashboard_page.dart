import 'package:flutter/material.dart';
import 'responsible_party_profile_page.dart';

class ResponsiblePartyDashboardPage extends StatefulWidget {
  const ResponsiblePartyDashboardPage({super.key});

  @override
  State<ResponsiblePartyDashboardPage> createState() =>
      _ResponsiblePartyDashboardPageState();
}

class _ResponsiblePartyDashboardPageState
    extends State<ResponsiblePartyDashboardPage> {
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
                      builder: (context) =>
                          const ResponsiblePartyProfilePage()));
            },
            icon: const Icon(
              Icons.account_circle,
              color: Colors.purple,
            ),
          ),
        ],
      ),
      body: const Text('Responsible Party Dashboard'),
    );
  }
}
