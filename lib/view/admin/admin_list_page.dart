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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Inspectors',
          style: TextStyle(
            color: Color(0xFF221540),
            fontSize: 30,
          ),
        ),
      ),
      body: SafeArea(child:
      Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        ),
        margin:EdgeInsets.all(15),
        elevation: 8,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.account_box_outlined, size: 60,),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Giova Guava", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Text("Shabu Packer", style: TextStyle(fontSize: 13)),
                ],
              ),
            )
          ],
        ),
      ),
      )
    );
  }
}
