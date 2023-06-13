import 'package:flutter/material.dart';
import 'package:quality_control_tracker/view/admin/admin_inspector_creation_page.dart';

class AdminListPage extends StatefulWidget {
  const AdminListPage({Key? key}) : super(key: key);

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Inspectors',
          style: TextStyle(
            color: Color(0xFF221540),
          ),
        ),
      ),
      body: Stack(
        children: [
          const Center(child: Text('List of Inspectors')),
          Positioned(
            top: 450,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                // ignore: use_build_context_synchronously
                Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const AdminInspectorCreationPage()));
              },
              backgroundColor: Colors.purple,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
