import 'package:flutter/material.dart';

class ResponsiblePartyUpdatePage extends StatefulWidget {
  const ResponsiblePartyUpdatePage({super.key});

  @override
  State<ResponsiblePartyUpdatePage> createState() =>
      _ResponsiblePartyUpdatePageState();
}

class _ResponsiblePartyUpdatePageState
    extends State<ResponsiblePartyUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFDCE4E9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Updates',
            style: TextStyle(
              color: Color(0xFF221540),
            ),
          ),
        ),
        body: const Text('Responsible party list of updates'));
  }
}