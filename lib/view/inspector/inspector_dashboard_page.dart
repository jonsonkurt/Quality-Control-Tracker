import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:quality_control_tracker/view/inspector/inspector_bottom_navigation_bar.dart';

import 'inspector_profile_page.dart';

class InspectorDashboardPage extends StatefulWidget {
  const InspectorDashboardPage({Key? key}) : super(key: key);

  @override
  State<InspectorDashboardPage> createState() => _InspectorDashboardPageState();
}

class _InspectorDashboardPageState extends State<InspectorDashboardPage> {
  String? userID = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color(0xFF221540),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // ignore: use_build_context_synchronously
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => const InspectorProfilePage(),
                ),
              );
            },
            icon: const Icon(
              Icons.account_circle,
              color: Colors.purple,
            ),
          ),
        ],
      ),
      body: FirebaseAnimatedList(
        query: FirebaseDatabase.instance
            .ref()
            .child('projects/')
            .orderByChild('inspectorQuery')
            .equalTo(userID),
        itemBuilder: (context, snapshot, animation, index) {
          // Extract project details from the snapshot
          String projectName = snapshot.child('projectName').value.toString();
          String projectLocation =
              snapshot.child('projectLocation').value.toString();
          String projectDeadline =
              snapshot.child('projectDeadline').value.toString();
          String projectStatus =
              snapshot.child('projectStatus').value.toString();

          return Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            child: GestureDetector(
              onTap: () {
                // ignore: use_build_context_synchronously
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InspectorBottomNavigation(),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Name: $projectName',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text('Location: $projectLocation'),
                      const SizedBox(height: 8.0),
                      Text('Deadline: $projectDeadline'),
                      const SizedBox(height: 8.0),
                      Text('Status: $projectStatus'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
