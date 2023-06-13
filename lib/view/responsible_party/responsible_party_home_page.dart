import 'package:flutter/material.dart';

class ResponsiblePartyHomePage extends StatelessWidget {
  const ResponsiblePartyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFDCE4E9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Information',
            style: TextStyle(
              color: Color(0xFF221540),
            ),
          ),
        ),
        body: const Text('Responsible Party information'));
  }
}
