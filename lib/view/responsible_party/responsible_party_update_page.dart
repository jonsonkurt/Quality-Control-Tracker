import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:random_string/random_string.dart';

class ResponsiblePartyUpdatePage extends StatefulWidget {
  final String projectIDQuery;

  const ResponsiblePartyUpdatePage({
    Key? key,
    required this.projectIDQuery,
  }) : super(key: key);

  @override
  State<ResponsiblePartyUpdatePage> createState() =>
      _ResponsiblePartyUpdatePageState();
}

class _ResponsiblePartyUpdatePageState
    extends State<ResponsiblePartyUpdatePage> {
  final TextEditingController _rpNotesController = TextEditingController();

  StreamSubscription<DatabaseEvent>? getRole;
  StreamSubscription<DatabaseEvent>? userSubscription;
  StreamSubscription<DatabaseEvent>? projectSubscription;
  StreamSubscription<DatabaseEvent>? inspectorSubscription;
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  String inspectorID = "";
  String rpFullName = "";
  String rpRole = "";
  String rpRoleQuery = "";
  var logger = Logger();
  bool isLoading = true;

  @override
  void dispose() {
    getRole?.cancel();
    userSubscription?.cancel();
    projectSubscription?.cancel();
    _rpNotesController.dispose();
    super.dispose();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Getting the time and date
        final now = DateTime.now();
        final formattedDate = DateFormat('MM-dd-yyyy').format(now);
        final formattedTime = DateFormat('HH:mm').format(now);
        final combinedDateTime = "$formattedDate-$formattedTime";
        final String projectUpdatesID = randomAlphaNumeric(8);

        final mediaQuery = MediaQuery.of(context);

        return AlertDialog(
          backgroundColor: const Color(0xffDCE4E9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Request Inspection',
            style: TextStyle(
                fontFamily: 'Rubik Bold',
                fontSize: mediaQuery.size.height * 0.03,
                color: const Color(0xFF221540)),
          ),
          content: Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5,
            child: TextField(
              cursorColor: const Color(0xFF221540),
              controller: _rpNotesController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Notes',
                labelStyle: TextStyle(
                  fontFamily: 'Karla Regular',
                  fontSize: mediaQuery.size.height * 0.02,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    backgroundColor: const Color(0xFF221540)),
                onPressed: () async {
                  String rpNotes = _rpNotesController.text;

                  // Updates database
                  DatabaseReference projectsRef = FirebaseDatabase.instance
                      .ref()
                      .child('projectUpdates/$projectUpdatesID');

                  projectsRef.set({
                    "projectID": widget.projectIDQuery,
                    "projectUpdatesID": projectUpdatesID,
                    "rpID": userID,
                    "rpName": rpFullName,
                    "rpRole": rpRole,
                    "inspectorID": inspectorID,
                    "rpProjectRemarks": "$userID-PENDING-$combinedDateTime",
                    "rpSubmissionDate": {"rpSubmissionDate1": formattedDate},
                    "inspectorIssueDeadline": {"inspectorIssueDeadline1": ""},
                    "rpNotes": {"rpNotes1": rpNotes},
                    "inspectorProjectRemakrs":
                        "$inspectorID-PENDING-$combinedDateTime",
                    "inspectorNotes": {"inspectorNotes1": ""},
                    "inspectionDate": {"inspectionDate1": ""},
                    "projectUpdatesPhotoURL": "",
                  });

                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(mediaQuery.size.height * 0.017),
                  child: Text(
                    'Request',
                    style: TextStyle(
                        fontFamily: 'Rubik Regular',
                        fontSize: mediaQuery.size.height * 0.02),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Getting the inspector's ID
    DatabaseReference inspectorRef = FirebaseDatabase.instance
        .ref()
        .child('projects/${widget.projectIDQuery}/');
    inspectorSubscription = inspectorRef.onValue.listen((event) {
      try {
        inspectorID = event.snapshot.child("inspectorQuery").value.toString();
      } catch (error, stackTrace) {
        logger.d('Error occurred: $error');
        logger.d('Stack trace: $stackTrace');
      }
    });

    // Getting the RP's full name and role
    DatabaseReference nameRef =
        FirebaseDatabase.instance.ref().child('responsibleParties/$userID/');
    userSubscription = nameRef.onValue.listen((event) {
      try {
        String firstName = event.snapshot.child("firstName").value.toString();
        String lastName = event.snapshot.child("lastName").value.toString();
        String role = event.snapshot.child("role").value.toString();
        rpFullName = "$firstName $lastName";

        // Getting the RP's role and roleQuery
        if (role == "Project Manager") {
          rpRole = "projectManager";
          rpRoleQuery = "projectManagerQuery";
        } else {
          rpRole = role.toLowerCase();
          rpRoleQuery = "${role.toLowerCase()}Query";
        }
      } catch (error, stackTrace) {
        logger.d('Error occurred: $error');
        logger.d('Stack trace: $stackTrace');
      }
    });

    return Scaffold(
        backgroundColor: const Color(0xFFDCE4E9),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            mediaQuery.size.height * 0.1,
          ),
          child: AppBar(
            toolbarHeight: 60,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width * 0.035,
                mediaQuery.size.height * 0.028,
                0,
                0,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF221540),
                ),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(
                top: mediaQuery.size.height * 0.035,
              ),
              child: Text(
                'Updates',
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
                  onPressed: _showDialog,
                  icon: Icon(
                    Icons.add,
                    size: mediaQuery.size.height * 0.045,
                    color: const Color(0xFF221540),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const Text('Responsible party list of updates'));
  }
}
