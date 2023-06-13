import 'package:flutter/material.dart';

class InspectorListPage extends StatefulWidget {
  const InspectorListPage({super.key});

  @override
  State<InspectorListPage> createState() => _InspectorListPageState();
}

class _InspectorListPageState extends State<InspectorListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFDCE4E9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'For Inspection',
            style: TextStyle(
              color: Color(0xFF221540),
            ),
          ),
        ),
        body: const Text('Inspector List of inspections'));
  }
}
