import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../image_viewer.dart';

class ResponsiblePartyProjectUpdatesPage extends StatefulWidget {
  final String projectUpdatesID;

  const ResponsiblePartyProjectUpdatesPage({
    Key? key,
    required this.projectUpdatesID,
  }) : super(key: key);

  @override
  State<ResponsiblePartyProjectUpdatesPage> createState() =>
      _ResponsiblePartyProjectUpdatesPageState();
}

class _ResponsiblePartyProjectUpdatesPageState
    extends State<ResponsiblePartyProjectUpdatesPage> {
  var logger = Logger();
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  String projectUpdatesPicture = '';
  String projectUpdatesTitle = '';
  String projectUpdatesOP = '';
  String projectUpdatesSubmissionDate = '';
  String projectUpdatesTag = '';
  String projectUpdatesNotes = '';
  StreamSubscription<DatabaseEvent>? projectUpdatesSubscription;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController rpNotesController = TextEditingController();

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
          toolbarHeight: mediaQuery.size.height * 0.1,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: EdgeInsets.fromLTRB(
              mediaQuery.size.width * 0.035,
              mediaQuery.size.height * 0.01,
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
              top: mediaQuery.size.height * 0.01,
            ),
            child: Text(
              'Update',
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

                // inspectionIssueDeadline
                int inspectionIssueDeadlineLength =
                    map["inspectionIssueDeadline"].length;
                String? inspectionIssueDeadline = map["inspectionIssueDeadline"]
                    ["inspectionIssueDeadline$inspectionIssueDeadlineLength"];

                // rpNotes length
                int rpNotesLength = map["rpNotes"].length + 1;

                // rpSubmissionDate length
                int rpSubmissionDateLength = map["rpSubmissionDate"].length + 1;

                // projectUpdatesTitle
                String projectUpdatesTitle = map["projectUpdatesTitle"];

                String projectID = map['projectID'];
                String inspectorID = map['inspectorID'];

                // inspectionDate
                int inspectionDateLength = map["inspectionDate"].length;
                String? inspectionDate = map["inspectionDate"]
                    ["inspectionDate$inspectionDateLength"];

                String projectUpdatesTag =
                    convertJobTitle(map['rpRole'].toString());

                // String projectUpdatesNotes = map['firstName'];
                int inspectorNotesLength = map["inspectorNotes"].length;
                String? inspectorNotes = map["inspectorNotes"]
                    ["inspectorNotes$inspectorNotesLength"];

                return Center(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailScreen(
                                imageUrl: projectUpdatesPicture,
                                projectID: widget.projectUpdatesID,
                              );
                            }));
                          },

                          // Image (kindly consult Jiiroo if you can't understand the code ty. ヾ(≧▽≦*)o)
                          child: Hero(
                            tag: widget.projectUpdatesID,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: projectUpdatesPicture == "None"
                                  ? Image.asset(
                                      'assets/images/no-image.png',
                                      fit: BoxFit.cover,
                                      width: 300,
                                      height: 200,
                                    )
                                  : Image(
                                      width: mediaQuery.size.width * 0.8,
                                      height: mediaQuery.size.height * 0.25,
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage(projectUpdatesPicture),
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                      errorBuilder: (context, object, stack) {
                                        return const Icon(
                                          Icons.error_outline,
                                          color:
                                              Color.fromARGB(255, 35, 35, 35),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Inspection Date: $inspectionDate",
                          // "Submission Date: ",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Issue Deadline: $inspectionIssueDeadline",
                          // "Submission Date: ",
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
                          "Inspector Notes: $inspectorNotes",
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
                              // Dialog for rework
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final mediaQuery = MediaQuery.of(context);

                                  return AlertDialog(
                                    backgroundColor: const Color(0xffDCE4E9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text(
                                      'Rework',
                                      style: TextStyle(
                                        fontFamily: 'Rubik Bold',
                                        fontSize: mediaQuery.size.height * 0.03,
                                        color: const Color(0xFF221540),
                                      ),
                                    ),
                                    content: Form(
                                      key: formKey,
                                      child: SizedBox(
                                        height: 300,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              cursorColor:
                                                  const Color(0xFF221540),
                                              controller: rpNotesController,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 4, 4, 0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none,
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Notes',
                                                labelStyle: TextStyle(
                                                  fontFamily: 'Karla Regular',
                                                  fontSize:
                                                      mediaQuery.size.height *
                                                          0.02,
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter your notes';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            backgroundColor:
                                                const Color(0xFF221540),
                                          ),
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              String rpNotes =
                                                  rpNotesController.text;

                                              // Updates rpNotes
                                              DatabaseReference rpNotesRef =
                                                  FirebaseDatabase.instance
                                                      .ref()
                                                      .child(
                                                          'projectUpdates/${widget.projectUpdatesID}/rpNotes');

                                              rpNotesRef.update({
                                                "rpNotes$rpNotesLength":
                                                    rpNotes,
                                              });

                                              // Updates rpSubmissionDate
                                              DatabaseReference
                                                  rpSubmissionDateRef =
                                                  FirebaseDatabase.instance
                                                      .ref()
                                                      .child(
                                                          'projectUpdates/${widget.projectUpdatesID}/rpSubmissionDate');

                                              rpSubmissionDateRef.update({
                                                "rpSubmissionDate$rpSubmissionDateLength":
                                                    formattedDate
                                              });

                                              // Updates project remarks
                                              DatabaseReference projectsRef =
                                                  FirebaseDatabase.instance
                                                      .ref()
                                                      .child(
                                                          'projectUpdates/${widget.projectUpdatesID}');

                                              projectsRef.update({
                                                "rpProjectRemarks":
                                                    "$userID-$projectID-PENDING-$combinedDateTime",
                                                "inspectorProjectRemarks":
                                                    "$inspectorID-$projectID-PENDING-$combinedDateTime",
                                              });
                                              Navigator.of(context).pop();
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                mediaQuery.size.height * 0.017),
                                            child: Text(
                                              'Submit',
                                              style: TextStyle(
                                                fontFamily: 'Rubik Regular',
                                                fontSize:
                                                    mediaQuery.size.height *
                                                        0.02,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                    ],
                  ),
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
