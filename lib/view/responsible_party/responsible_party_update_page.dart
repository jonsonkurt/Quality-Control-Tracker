import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_project_updates.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_project_updates_information.dart';
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

  bool validateTitle = false;
  bool validateNotes = false;
  bool isEmptyPending = true;
  bool isEmptyRework = true;
  bool isEmptyCompleted = true;

  StreamSubscription<DatabaseEvent>? getRole,
      userSubscription,
      projectSubscription,
      inspectorSubscription,
      emptyPendingSubscription,
      emptyReworkSubscription,
      emptyCompletedSubscription;
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
    emptyPendingSubscription?.cancel();
    emptyReworkSubscription?.cancel();
    emptyCompletedSubscription?.cancel();
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
                content: SizedBox(
                  height: mediaQuery.size.height * 0.38,
                  width: mediaQuery.size.height * 0.14,
                  child: Form(
                    key: formKey,
                    child: SizedBox(
                      height: mediaQuery.size.height * 0.38,
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
                          SizedBox(
                            height: mediaQuery.size.height * 0.015,
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
                          SizedBox(
                            height: mediaQuery.size.height * 0.03,
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.pickImage(context, projectUpdatesID);
                            },
                            child: Container(
                              height: mediaQuery.size.height * 0.15,
                              width: mediaQuery.size.width * 0.3,
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
                          await provider.updloadImage(projectUpdatesID);
                          // Updates database
                          DatabaseReference projectsRef = FirebaseDatabase
                              .instance
                              .ref()
                              .child('projectUpdates/$projectUpdatesID');
                          
                          await projectsRef.set({
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
                            "inspectionIssueDeadline": "",
                            "rpNotes": {"rpNotes1": rpNotes},
                            "inspectorProjectRemarks":
                                "$inspectorID-${widget.projectIDQuery}-PENDING-$combinedDateTime",
                            "inspectorNotes": "",
                            "inspectionDate": "",
                            "projectUpdatesTitle": rpTitle,
                            "projectUpdatesPhotoURL": "None",
                          });
                          if (provider.imgURL != "") {
                            await projectsRef.update({
                              "projectUpdatesPhotoURL": provider.imgURL,
                            });
                          }

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
                  SizedBox(height: mediaQuery.size.height * 0.02),
                ],
              );
            }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Database references and queries for empty views
    DatabaseReference emptyPendingRef =
        FirebaseDatabase.instance.ref('projectUpdates');
    Query emptyPendingQuery = emptyPendingRef
        .orderByChild('rpProjectRemarks')
        .startAt("$userID-${widget.projectIDQuery}-PENDING-")
        .endAt("$userID-${widget.projectIDQuery}-PENDING-\uf8ff");
    Query emptyReworkQuery = emptyPendingRef
        .orderByChild('rpProjectRemarks')
        .startAt("$userID-${widget.projectIDQuery}-REWORK-")
        .endAt("$userID-${widget.projectIDQuery}-REWORK-\uf8ff");
    Query emptyCompletedQuery = emptyPendingRef
        .orderByChild('rpProjectRemarks')
        .startAt("$userID-${widget.projectIDQuery}-COMPLETED-")
        .endAt("$userID-${widget.projectIDQuery}-COMPLETED-\uf8ff");
    emptyPendingSubscription = emptyPendingQuery.onValue.listen((event) {
      try {
        if (mounted) {
          setState(() {
            String check = event.snapshot.value.toString();
            if (check != "null") {
              isEmptyPending = false;
            }
          });
        }
      } catch (error, stackTrace) {
        logger.d('Error occurred: $error');
        logger.d('Stack trace: $stackTrace');
      }
    });
    emptyReworkSubscription = emptyReworkQuery.onValue.listen((event) {
      try {
        if (mounted) {
          setState(() {
            String check = event.snapshot.value.toString();
            if (check != "null") {
              isEmptyRework = false;
            }
          });
        }
      } catch (error, stackTrace) {
        logger.d('Error occurred: $error');
        logger.d('Stack trace: $stackTrace');
      }
    });
    emptyCompletedSubscription = emptyCompletedQuery.onValue.listen((event) {
      try {
        if (mounted) {
          setState(() {
            String check = event.snapshot.value.toString();
            if (check != "null") {
              isEmptyCompleted = false;
            }
          });
        }
      } catch (error, stackTrace) {
        logger.d('Error occurred: $error');
        logger.d('Stack trace: $stackTrace');
      }
    });

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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: mediaQuery.size.height * 0.7,
          width: mediaQuery.size.width,
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(left: mediaQuery.size.width * 0.01),
                child: Text(
                  "For Inspection",
                  style: TextStyle(
                    fontFamily: 'Rubik Bold',
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    color: const Color(0xff221540),
                  ),
                ),
              ),
              Builder(builder: (BuildContext context) {
                if (isEmptyPending) {
                  // TODO: Edit this empty view for "For Inspection"
                  return SizedBox(
                      height: mediaQuery.size.height * 0.19,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Available Data",
                              style: TextStyle(
                                fontFamily: 'Karla Regular',
                                fontSize: mediaQuery.size.height * 0.02,
                                color: const Color(0xff221540),
                              ),
                            ),
                          ],
                        ),
                      ));
                } else {
                  return Flexible(
                    child: FirebaseAnimatedList(
                      key: const Key('firebase_animated_list_key'),
                      scrollDirection: Axis.horizontal,
                      query: ref
                          .orderByChild("rpProjectRemarks")
                          .startAt("$userID-${widget.projectIDQuery}-PENDING-")
                          .endAt(
                              "$userID-${widget.projectIDQuery}-PENDING-\uf8ff"),
                      itemBuilder: (context, snapshot, animation, index) {
                        String projectUpdatesID =
                            snapshot.child("projectUpdatesID").value.toString();

                        String rpSubmissionDateLengthString =
                            snapshot.child("rpSubmissionDate").value.toString();
                        int rpSubmissionDateLengthInt =
                            rpSubmissionDateLengthString.split(":").length - 1;
                        String rpSubmissionDate = snapshot
                            .child(
                                "rpSubmissionDate/rpSubmissionDate$rpSubmissionDateLengthInt")
                            .value
                            .toString();

                        String projectUpdatesTitle = snapshot
                            .child("projectUpdatesTitle")
                            .value
                            .toString();

                        String projectUpdatesPhotoURL = snapshot
                            .child("projectUpdatesPhotoURL")
                            .value
                            .toString();

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ResponsiblePartyProjectUpdatesInformationPage(
                                        projectUpdatesID: projectUpdatesID,
                                      )),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: mediaQuery.size.height * 0.11,
                                  width: mediaQuery.size.width * 0.36,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: Image.network(
                                      projectUpdatesPhotoURL,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  projectUpdatesTitle,
                                  style: TextStyle(
                                      fontFamily: "Rubik Bold",
                                      fontSize: mediaQuery.size.height * 0.018,
                                      color: const Color(0xFF221540)),
                                ),
                                Text(
                                  "Submitted on:",
                                  style: TextStyle(
                                      fontFamily: "Karla Regular",
                                      fontSize: mediaQuery.size.height * 0.015,
                                      color: const Color(0xFF221540)),
                                ),
                                Text(
                                  rpSubmissionDate,
                                  style: TextStyle(
                                      fontFamily: "Karla Regular",
                                      fontSize: mediaQuery.size.height * 0.015,
                                      color: const Color(0xFF221540)),
                                ),
                              ],
                            ),
                            // child: Row(
                            //   children: [
                            //     Image.network(
                            //       projectUpdatesPhotoURL,
                            //       width: 100,
                            //       height: 100,
                            //     ),
                            //     Column(
                            //       children: [
                            //         Text(projectUpdatesTitle),
                            //         Text("Submitted on: $rpSubmissionDate"),
                            //       ],
                            //     )
                            //   ],
                            // ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(left: mediaQuery.size.width * 0.01),
                child: Text(
                  "For Rework",
                  style: TextStyle(
                    fontFamily: 'Rubik Bold',
                    fontSize: mediaQuery.size.height * 0.025,
                    color: const Color(0xff221540),
                  ),
                ),
              ),
              Builder(
                builder: (BuildContext context) {
                  if (isEmptyRework) {
                    // TODO: Edit this empty view for "For Rework"
                    return SizedBox(
                        height: mediaQuery.size.height * 0.19,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "No Available Data",
                                style: TextStyle(
                                  fontFamily: 'Karla Regular',
                                  fontSize: mediaQuery.size.height * 0.02,
                                  color: const Color(0xff221540),
                                ),
                              ),
                            ],
                          ),
                        ));
                  } else {
                    return Flexible(
                      child: FirebaseAnimatedList(
                        scrollDirection: Axis.horizontal,
                        query: ref
                            .orderByChild("rpProjectRemarks")
                            .startAt("$userID-${widget.projectIDQuery}-REWORK-")
                            .endAt(
                                "$userID-${widget.projectIDQuery}-REWORK-\uf8ff"),
                        itemBuilder: (context, snapshot, animation, index) {
                          String projectUpdatesID = snapshot
                              .child("projectUpdatesID")
                              .value
                              .toString();

                          String inspectionDateLengthString =
                              snapshot.child("inspectionDate").value.toString();
                          int inspectionDateLengthInt =
                              inspectionDateLengthString.split(":").length - 1;
                          String inspectionDate = snapshot
                              .child(
                                  "inspectionDate/inspectionDate$inspectionDateLengthInt")
                              .value
                              .toString();

                          String projectUpdatesTitle = snapshot
                              .child("projectUpdatesTitle")
                              .value
                              .toString();

                          String projectUpdatesPhotoURL = snapshot
                              .child("projectUpdatesPhotoURL")
                              .value
                              .toString();

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResponsiblePartyProjectUpdatesPage(
                                          projectUpdatesID: projectUpdatesID,
                                        )),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: mediaQuery.size.height * 0.11,
                                    width: mediaQuery.size.width * 0.36,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      child: Image.network(
                                        projectUpdatesPhotoURL,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        projectUpdatesTitle,
                                        style: TextStyle(
                                            fontFamily: "Rubik Bold",
                                            fontSize:
                                                mediaQuery.size.height * 0.018,
                                            color: const Color(0xFF221540)),
                                      ),
                                      Text(
                                        "Inspected on:",
                                        style: TextStyle(
                                            fontFamily: "Karla Regular",
                                            fontSize:
                                                mediaQuery.size.height * 0.015,
                                            color: const Color(0xFF221540)),
                                      ),
                                      Text(
                                        inspectionDate,
                                        style: TextStyle(
                                            fontFamily: "Karla Regular",
                                            fontSize:
                                                mediaQuery.size.height * 0.015,
                                            color: const Color(0xFF221540)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(left: mediaQuery.size.width * 0.01),
                child: Text(
                  "Completed",
                  style: TextStyle(
                    fontFamily: 'Rubik Bold',
                    fontSize: mediaQuery.size.height * 0.025,
                    color: const Color(0xff221540),
                  ),
                ),
              ),
              Builder(
                builder: (BuildContext context) {
                  if (isEmptyCompleted) {
                    // TODO: Edit this empty view for "Completed"
                    return Flexible(
                      child: SizedBox(
                          height: mediaQuery.size.height * 0.19,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "No Available Data",
                                  style: TextStyle(
                                    fontFamily: 'Karla Regular',
                                    fontSize: mediaQuery.size.height * 0.02,
                                    color: const Color(0xff221540),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                  } else {
                    return Flexible(
                      child: FirebaseAnimatedList(
                        scrollDirection: Axis.horizontal,
                        query: ref
                            .orderByChild("rpProjectRemarks")
                            .startAt(
                                "$userID-${widget.projectIDQuery}-COMPLETED-")
                            .endAt(
                                "$userID-${widget.projectIDQuery}-COMPLETED-\uf8ff"),
                        itemBuilder: (context, snapshot, animation, index) {
                          String projectUpdatesID = snapshot
                              .child("projectUpdatesID")
                              .value
                              .toString();

                          String rpSubmissionDateLengthString = snapshot
                              .child("rpSubmissionDate")
                              .value
                              .toString();
                          int rpSubmissionDateLengthInt =
                              rpSubmissionDateLengthString.split(":").length -
                                  1;
                          String rpSubmissionDate = snapshot
                              .child(
                                  "rpSubmissionDate/rpSubmissionDate$rpSubmissionDateLengthInt")
                              .value
                              .toString();

                          String projectUpdatesTitle = snapshot
                              .child("projectUpdatesTitle")
                              .value
                              .toString();

                          String projectUpdatesPhotoURL = snapshot
                              .child("projectUpdatesPhotoURL")
                              .value
                              .toString();

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ResponsiblePartyProjectUpdatesInformationPage(
                                    projectUpdatesID: projectUpdatesID,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: mediaQuery.size.height * 0.11,
                                    width: mediaQuery.size.width * 0.36,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      child: Image.network(
                                        projectUpdatesPhotoURL,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(projectUpdatesTitle,
                                          style: TextStyle(
                                              fontFamily: "Rubik Bold",
                                              fontSize: mediaQuery.size.height *
                                                  0.018,
                                              color: const Color(0xFF221540))),
                                      Text("Submitted on:",
                                          style: TextStyle(
                                              fontFamily: "Karla Regular",
                                              fontSize: mediaQuery.size.height *
                                                  0.015,
                                              color: const Color(0xFF221540))),
                                      Text(rpSubmissionDate,
                                          style: TextStyle(
                                              fontFamily: "Karla Regular",
                                              fontSize: mediaQuery.size.height *
                                                  0.015,
                                              color: const Color(0xFF221540))),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
