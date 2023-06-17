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
    final mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false; // Disable back button
      },
      
      child: Scaffold(
        backgroundColor: const Color(0xFFDCE4E9),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            mediaQuery.size.height * 0.1
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
                        builder: (context) => const InspectorProfilePage(),
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
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 10, right: 10),
              child: GestureDetector(
                onTap: () {
                  // ignore: use_build_context_synchronously
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InspectorBottomNavigation(
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
                            color: const Color(0xFF221540),
                        ),
                          ),
                        SizedBox(height: mediaQuery.size.height * 0.01),
                        Text(
                          'Deadline: $projectDeadline',
                          style: TextStyle(
                            fontFamily: 'Karla Regular',
                            fontSize: mediaQuery.size.height * 0.02,
                            color: const Color(0xFF221540),
                            ),
                          ),
                        SizedBox(height: mediaQuery.size.height * 0.01),
                        Text(
                          'Status: $projectStatus',
                          style: TextStyle(
                            fontFamily: 'Karla Regular',
                            fontSize: mediaQuery.size.height * 0.02,
                            color: const Color(0xFF221540)
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
