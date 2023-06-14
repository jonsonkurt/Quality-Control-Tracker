import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../sign_in_page.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
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
        title: const Text('Admin'),
        backgroundColor: Color(0xFF221540),
      ),
      body: SafeArea(child: 
      Container(
        padding: EdgeInsets.only(top: 30, left: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Admin", style: TextStyle(fontSize: 25,),
            ),
          
          ],
        ),
      )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        child: const Icon(Icons.logout,),
      ),
    );
  }
}
