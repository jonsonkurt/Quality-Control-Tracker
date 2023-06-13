import 'package:flutter/material.dart';

class InspectorHomePage extends StatefulWidget {
  const InspectorHomePage({super.key});

  @override
  State<InspectorHomePage> createState() => _InspectorHomePageState();
}

class _InspectorHomePageState extends State<InspectorHomePage> {
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
        body: const Text('Inspector information'));
  }
}
