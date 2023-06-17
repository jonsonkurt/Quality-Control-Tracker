import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ResponsiblePartyUpdatePage extends StatefulWidget {
  final String projectIDQuery;

  const ResponsiblePartyUpdatePage({
    Key? key,
    required this.projectIDQuery,
  }) : super(key: key);

  @override
  State<ResponsiblePartyUpdatePage> createState() =>
      _ResponsiblePartyUpdatePageState();
}

class _ResponsiblePartyUpdatePageState
    extends State<ResponsiblePartyUpdatePage> {
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  var logger = Logger();
  String? inspectorID;
  String? rpFullName;
  String? rpRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Updates',
          style: TextStyle(
            color: Color(0xFF221540),
          ),
        ),
      ),
      body: const Text('Responsible party list of updates'),
    );
  }
}
