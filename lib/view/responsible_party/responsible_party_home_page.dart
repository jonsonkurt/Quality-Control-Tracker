import 'package:flutter/material.dart';

class ResponsiblePartyHomePage extends StatefulWidget {
  final String projectIDQuery;

  const ResponsiblePartyHomePage({
    Key? key,
    required this.projectIDQuery,
  }) : super(key: key);

  @override
  State<ResponsiblePartyHomePage> createState() =>
      _ResponsiblePartyHomePageState();
}

class _ResponsiblePartyHomePageState extends State<ResponsiblePartyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFDCE4E9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.purple,
            ),
          ),
          title: const Text(
            'Information',
            style: TextStyle(
              color: Color(0xFF221540),
            ),
          ),
        ),
        body: const Text('Party information'));
  }
}
