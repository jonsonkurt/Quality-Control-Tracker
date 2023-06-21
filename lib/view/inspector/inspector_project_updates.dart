import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:random_string/random_string.dart';

class InspectorProjectUpdatesPage extends StatefulWidget {
  final String projectUpdatesID;

  const InspectorProjectUpdatesPage({
    Key? key,
    required this.projectUpdatesID,
  }) : super(key: key);

  @override
  State<InspectorProjectUpdatesPage> createState() =>
      _InspectorProjectUpdatesPageState();
}

class _InspectorProjectUpdatesPageState
    extends State<InspectorProjectUpdatesPage> {
  var logger = Logger();
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  String projectUpdatesPicture = '';
  String projectUpdatesTitle = '';
  String projectUpdatesOP = '';
  String projectUpdatesSubmissionDate = '';
  String projectUpdatesTag = '';
  String projectUpdatesNotes = '';
  StreamSubscription<DatabaseEvent>? projectUpdatesSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    projectUpdatesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    DatabaseReference projectDetailsRef = FirebaseDatabase.instance
        .ref()
        .child('projectUpdates/${widget.projectUpdatesID}');

    String convertJobTitle(String input) {
      switch (input.toLowerCase()) {
        case 'electrician':
          return 'Electrical';
        case 'plumber':
          return 'Plumbing';
        case 'painter':
          return 'Painting';
        case 'mason':
          return 'Masonry';
        case 'laborer':
          return 'Labor';
        case 'owner':
          return 'Ownership';
        case 'projectmanager':
          return 'Project Management';
        case 'welder':
          return 'Welding';
        case 'carpenter':
          return 'Carpentry';
        case 'landscaper':
          return 'Landscaping';
        case 'hvac':
          return 'HVAC';
        default:
          return 'Unknown';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          mediaQuery.size.height * 0.1,
        ),
        child: AppBar(
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
              'Inspections',
              style: TextStyle(
                fontFamily: 'Rubik Bold',
                fontSize: mediaQuery.size.height * 0.04,
                color: const Color(0xFF221540),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: projectDetailsRef.onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                // Getting the time and date
                final now = DateTime.now();
                final formattedDate = DateFormat('MM-dd-yyyy').format(now);
                final formattedTime = DateFormat('HH:mm').format(now);
                final combinedDateTime = "$formattedDate-$formattedTime";

                // Getting values from database
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

                String projectUpdatesPicture = map['projectUpdatesPhotoURL'];

                // projectUpdatesTitle
                int projectUpdatesTitleLength =
                    map["projectUpdatesTitle"].length;
                String projectUpdatesTitle = map["projectUpdatesTitle"]
                    ["title$projectUpdatesTitleLength"];

                String projectUpdatesOP = map['rpName'];
                String projectID = map['projectID'];
                String rpID = map['rpID'];

                // projectUpdatesSubmissionDate
                int projectUpdatesSubmissionDateLength =
                    map["projectUpdatesTitle"].length;
                String projectUpdatesSubmissionDate = map["rpSubmissionDate"]
                    ["rpSubmissionDate$projectUpdatesSubmissionDateLength"];

                String projectUpdatesTag =
                    convertJobTitle(map['rpRole'].toString());

                // String projectUpdatesNotes = map['firstName'];
                int projectUpdatesNotesLength =
                    map["projectUpdatesTitle"].length;
                String projectUpdatesNotes =
                    map["rpNotes"]["rpNotes$projectUpdatesNotesLength"];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          projectUpdatesPicture,
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        projectUpdatesTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Accomplished by: $projectUpdatesOP',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Submission Date: $projectUpdatesSubmissionDate",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Tag: $projectUpdatesTag",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Description: $projectUpdatesNotes",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Are you sure you want to mark the inspection as complete and indicate that no issues were found?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        // Performs the action when the user confirms
                                        // Updates database
                                        DatabaseReference projectsRef =
                                            FirebaseDatabase.instance.ref().child(
                                                'projectUpdates/${widget.projectUpdatesID}');

                                        projectsRef.update({
                                          "rpProjectRemarks":
                                              "$rpID-$projectID-COMPLETED-$combinedDateTime",
                                          "inspectorProjectRemarks":
                                              "$userID-$projectID-COMPLETED-$combinedDateTime",
                                        });
                                        Navigator.of(context).pop();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('Accept'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Rework button logic
                          },
                          child: const Text('Rework'),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(
                    child: Text(
                  'Something went wrong.',
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}
