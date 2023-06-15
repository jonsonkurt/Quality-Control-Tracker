import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_bottom_navigation_bar.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_profile_page.dart';

class ResponsiblePartyDashboardPage extends StatefulWidget {
  final String role;

  const ResponsiblePartyDashboardPage({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  State<ResponsiblePartyDashboardPage> createState() =>
      _ResponsiblePartyDashboardPageState();
}

class _ResponsiblePartyDashboardPageState
    extends State<ResponsiblePartyDashboardPage> {
  final TextEditingController _projectIdController = TextEditingController();
  StreamSubscription<DatabaseEvent>? getRole;
  StreamSubscription<DatabaseEvent>? userSubscription;
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  String name = '';
  var logger = Logger();
  bool isLoading = true;

  @override
  void dispose() {
    _projectIdController.dispose();
    super.dispose();
  }

  void _showDialog() {
    // Getting the RP's role and roleQuery
    String rpRole = "";
    String rpRoleQuery = "";

    if (widget.role == "Project Manager") {
      rpRole = "projectManager";
      rpRoleQuery = "projectManagerQuery";
    } else {
      rpRole = widget.role.toLowerCase();
      rpRoleQuery = "${widget.role.toLowerCase()}Query";
    }

    // Getting the RP's full name
    DatabaseReference nameRef =
        FirebaseDatabase.instance.ref().child('responsibleParties/$userID/');
    userSubscription = nameRef.onValue.listen((event) {
      try {
        String firstName = event.snapshot.child("firstName").value.toString();
        String lastName = event.snapshot.child("lastName").value.toString();
        name = "$firstName $lastName";
      } catch (error, stackTrace) {
        logger.d('Error occurred: $error');
        logger.d('Stack trace: $stackTrace');
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Project'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _projectIdController,
                decoration: const InputDecoration(
                  labelText: 'Project ID',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                String projectId = _projectIdController.text;

                // Updates database
                DatabaseReference projectsRef =
                    FirebaseDatabase.instance.ref('projects/$projectId');
                projectsRef.update({
                  rpRole: name,
                  rpRoleQuery: userID,
                });
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String rpRole = "";

    if (widget.role == "Project Manager") {
      rpRole = "projectManagerQuery";
    } else {
      rpRole = "${widget.role.toLowerCase()}Query";
    }

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
                  builder: (context) => const ResponsiblePartyProfilePage(),
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
            .orderByChild(rpRole) // Try getting the role upon sign in
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
                    builder: (context) =>
                        const ResponsiblePartyBottomNavigation(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
