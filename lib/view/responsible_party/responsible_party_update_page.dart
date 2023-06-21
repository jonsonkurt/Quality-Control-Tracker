import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_tracker/view/responsible_party/update_image_controller.dart';
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
  final TextEditingController _rpTitleController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    _rpTitleController.dispose();
    _rpNotesController.dispose();
    getRole?.cancel();
    userSubscription?.cancel();
    projectSubscription?.cancel();
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

        return ChangeNotifierProvider(
            create: (_) => ProfileController(),
            child: Consumer<ProfileController>(
                builder: (context, provider, child) {
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
                    color: const Color(0xFF221540),
                  ),
                ),
                content: Form(
                  key: formKey,
                  child: SizedBox(
                    height: 300,
                    child: Column(
                      children: [
                        TextFormField(
                          cursorColor: const Color(0xFF221540),
                          controller: _rpTitleController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 4, 4, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Title',
                            labelStyle: TextStyle(
                              fontFamily: 'Karla Regular',
                              fontSize: mediaQuery.size.height * 0.02,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          cursorColor: const Color(0xFF221540),
                          controller: _rpNotesController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 4, 4, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Notes',
                            labelStyle: TextStyle(
                              fontFamily: 'Karla Regular',
                              fontSize: mediaQuery.size.height * 0.02,
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
                        GestureDetector(
                          onTap: () {
                            provider.pickImage(context, projectUpdatesID);
                          },
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color(0xff221540),
                                  width: 2,
                                )),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: provider.image == null
                                    ? const Icon(
                                        Icons.add_circle,
                                        size: 35,
                                        color: Color(0xff221540),
                                      )
                                    : Image.file(
                                        fit: BoxFit.cover,
                                        File(provider.image!.path).absolute)),
                          ),
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
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: const Color(0xFF221540),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          String rpTitle = _rpTitleController.text;
                          String rpNotes = _rpNotesController.text;

                          // Updates database
                          DatabaseReference projectsRef = FirebaseDatabase
                              .instance
                              .ref()
                              .child('projectUpdates/$projectUpdatesID');

                          projectsRef.set({
                            "projectID": widget.projectIDQuery,
                            "projectUpdatesID": projectUpdatesID,
                            "rpID": userID,
                            "rpName": rpFullName,
                            "rpRole": rpRole,
                            "inspectorID": inspectorID,
                            "rpProjectRemarks":
                                "$userID-${widget.projectIDQuery}-PENDING-$combinedDateTime",
                            "rpSubmissionDate": {
                              "rpSubmissionDate1": formattedDate
                            },
                            "inspectorIssueDeadline": "",
                            "rpNotes": {"rpNotes1": rpNotes},
                            "inspectorProjectRemarks":
                                "$inspectorID-${widget.projectIDQuery}-PENDING-$combinedDateTime",
                            "inspectorNotes": "",
                            "inspectionDate": "",
                            "projectUpdatesPhotoURL": provider.imgURL,
                            "projectUpdatesTitle": {"title1": rpTitle},
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(mediaQuery.size.height * 0.017),
                        child: Text(
                          'Request',
                          style: TextStyle(
                            fontFamily: 'Rubik Regular',
                            fontSize: mediaQuery.size.height * 0.02,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
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
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('projectUpdates');
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
        body: StreamBuilder(
            stream: ref.orderByChild("rpID").equalTo(userID).onValue,
            builder: (context, AsyncSnapshot snapshot) {
              dynamic values;
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                if (dataSnapshot.value != null) {
                  values = dataSnapshot.value;

                  return ListView.builder(
                      itemCount: values.length,
                      itemBuilder: (context, index) {
                        String projectUpdatesID = values.keys.elementAt(index);

                        String projectUpdatesPhotoURL =
                            values[projectUpdatesID]["projectUpdatesPhotoURL"];
                        int projectUpdatesTitleLength = values[projectUpdatesID]
                                ["projectUpdatesTitle"]
                            .length;
                        String projectUpdatesTitle = values[projectUpdatesID]
                                ["projectUpdatesTitle"]
                            ["title$projectUpdatesTitleLength"];
                        String projectID =
                            values[projectUpdatesID]["projectID"];
                        int rpSubmissionDateLength =
                            values[projectUpdatesID]["rpSubmissionDate"].length;
                        String rpSubmissionDate = values[projectUpdatesID]
                                ["rpSubmissionDate"]
                            ["rpSubmissionDate$rpSubmissionDateLength"];
                        DateTime dateTime =
                            DateFormat("MM-dd-yyyy").parse(rpSubmissionDate);
                        String formattedDate =
                            DateFormat("MMMM d, yyyy").format(dateTime);
                        if (projectID == widget.projectIDQuery) {
                          return Card(
                            child: Column(children: [
                              Row(
                                children: [
                                  Image.network(
                                    fit: BoxFit.cover,
                                    projectUpdatesPhotoURL,
                                    width: 100,
                                    height: 100,
                                  ),
                                  Column(
                                    children: [
                                      Text("Title: $projectUpdatesTitle"),
                                      Text("Submission Date$formattedDate"),
                                    ],
                                  )
                                ],
                              )
                            ]),
                          );
                        }
                        return const Text("");
                      });
                }
              }
              return const Text("");
            }));
  }
}
