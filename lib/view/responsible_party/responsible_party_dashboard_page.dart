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
  final TextEditingController _textFieldController = TextEditingController();

  StreamSubscription<DatabaseEvent>? getRole;
  StreamSubscription<DatabaseEvent>? userSubscription;
  StreamSubscription<DatabaseEvent>? projectSubscription;
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  String name = '';
  var logger = Logger();
  bool isLoading = true;

  @override
  void dispose() {
    _projectIdController.dispose();
    super.dispose();
  }

  // void _showDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Enter Text'),
  //         content: Column(
  //           children: <Widget>[
  //             TextField(
  //               controller: _textFieldController,
  //               decoration: InputDecoration(hintText: 'Type something'),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               String enteredText = _textFieldController.text;
  //               // Do something with the entered text, such as printing it
  //               print('Entered Text: $enteredText');
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Submit'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
          backgroundColor: const Color(0xffDCE4E9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Add Project',
            style: TextStyle(
                fontFamily: 'Rubik Bold',
                fontSize: 20,
                color: Color(0xFF221540)),
          ),
          content: TextField(
            controller: _projectIdController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Project ID',
              labelStyle: const TextStyle(
                fontFamily: 'Karla Regular',
                fontSize: 16,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                String projectId = _projectIdController.text;

                // Updates database
                DatabaseReference projectsRef = FirebaseDatabase.instance
                    .ref()
                    .child('projects/$projectId');

                projectSubscription = projectsRef.onValue.listen((event) {
                  try {
                    if (event.snapshot.value != null) {
                      projectsRef.update({
                        rpRole: name,
                        rpRoleQuery: userID,
                      });
                      _projectIdController.text = "";
                    } else {
                      // Project does not exist, show SnackBar
                      _projectIdController.text = "";
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Project does not exist")),
                      );
                    }
                  } catch (error, stackTrace) {
                    logger.d('Error occurred: $error');
                    logger.d('Stack trace: $stackTrace');
                  }
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

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          mediaQuery.size.height * 0.1,
        ),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.fromLTRB(
              0, 
              mediaQuery.size.height * 0.035, 
              mediaQuery.size.width * 0.06, 
              0),
            child: Text(
              'Dashboard',
              style: TextStyle(
                fontFamily: 'Rubik Bold',
                fontSize: mediaQuery.size.height * 0.04,
                color: const Color(0xFF221540),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                mediaQuery.size.height * 0.017,
                mediaQuery.size.width * 0.035,
                0,
              ),
              child: IconButton(
                onPressed: () {
                  // ignore: use_build_context_synchronously
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResponsiblePartyProfilePage(),
                    ),
                  );
                },
                icon: Icon(
                      Icons.account_circle,
                      size: mediaQuery.size.height * 0.045,
                      color: const Color(0xFF221540),
                    ),
                ),
            ),
          ],
        ),
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
                    builder: (context) => ResponsiblePartyBottomNavigation(
                      projectID: snapshot.child('projectID').value.toString(),
                    ),
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
                        style: TextStyle(
                          fontFamily: 'Rubik Bold',
                          fontSize: mediaQuery.size.height * 0.02,
                          color: const Color(0xFF221540)
                          ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.01),
                      Text(
                        'Location: $projectLocation',
                        style: TextStyle(
                          fontFamily: 'Karla Regular',
                          fontSize: mediaQuery.size.height * 0.02,
                          color: const Color(0xFF221540)
                        ),
                        ),
                      SizedBox(height: mediaQuery.size.height * 0.01),
                      Text(
                        'Deadline: $projectDeadline',
                        style: TextStyle(
                          fontFamily: 'Karla Regular',
                          fontSize: mediaQuery.size.height * 0.02,
                          color: const Color(0xFF221540)
                        ),
                        ),
                      SizedBox(height: mediaQuery.size.height * 0.01),
                      Text(
                        'Status: $projectStatus',
                        style: TextStyle(
                          fontFamily: 'Karla Regular',
                          fontSize: mediaQuery.size.height * 0.02,
                          color: const Color(0xFF221540)
                        ),),
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
        backgroundColor: const Color(0xFF221540),
        child: const Icon(Icons.add),
      ),
    );
  }
}
