import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../sign_in_page.dart';

class ResponsiblePartyProfilePage extends StatefulWidget {
  const ResponsiblePartyProfilePage({super.key});

  @override
  State<ResponsiblePartyProfilePage> createState() =>
      _ResponsiblePartyProfilePageState();
}

class _ResponsiblePartyProfilePageState
    extends State<ResponsiblePartyProfilePage> {
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    // Redirect the user to the SignInPage after logging out
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        child: const Icon(Icons.logout),
      ),
    );
  }
}