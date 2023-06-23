import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:quality_control_tracker/view/inspector/inspector_project_updates.dart';

class InspectorListPage extends StatefulWidget {
  final String projectIDQuery;

  const InspectorListPage({
    Key? key,
    required this.projectIDQuery,
  }) : super(key: key);

  @override
  State<InspectorListPage> createState() => _InspectorListPageState();
}

class _InspectorListPageState extends State<InspectorListPage> {
  String? inspectorID = FirebaseAuth.instance.currentUser?.uid;
  StreamSubscription<DatabaseEvent>? emptyPendingSubscription;
  var logger = Logger();
  bool isEmptyPending = true;

  DatabaseReference ref =
      FirebaseDatabase.instance.ref().child('projectUpdates/');

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emptyPendingSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Database reference and query for empty view
    DatabaseReference emptyPendingRef =
        FirebaseDatabase.instance.ref('projectUpdates');
    Query emptyPendingQuery = emptyPendingRef
        .orderByChild("inspectorProjectRemarks")
        .startAt("$inspectorID-${widget.projectIDQuery}-PENDING-")
        .endAt("$inspectorID-${widget.projectIDQuery}-PENDING-\uf8ff");

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

    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          mediaQuery.size.height * 0.1,
        ),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
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
            padding: EdgeInsets.fromLTRB(0, mediaQuery.size.height * 0.035,
                mediaQuery.size.width * 0.06, 0),
            child: Text(
              'For Inspection',
              style: TextStyle(
                fontFamily: 'Rubik Bold',
                fontSize: mediaQuery.size.height * 0.04,
                color: const Color(0xFF221540),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: 580,
        padding: const EdgeInsets.only(top: 10),
        child: Builder(
          builder: (BuildContext context) {
            if (isEmptyPending) {
              // TODO: Edit this empty view
              return const Center(child: Text("No Available Data"));
            } else {
              return FirebaseAnimatedList(
                query: ref
                    .orderByChild("inspectorProjectRemarks")
                    .startAt("$inspectorID-${widget.projectIDQuery}-PENDING-")
                    .endAt(
                        "$inspectorID-${widget.projectIDQuery}-PENDING-\uf8ff"),
                itemBuilder: (context, snapshot, animation, index) {
                  String projectUpdatesID =
                      snapshot.child("projectUpdatesID").value.toString();
                  String rpName = snapshot.child("rpName").value.toString();
                  String rpRole = snapshot.child("rpRole").value.toString();
                  String jobTitle = convertJobTitle(rpRole);

                  String rpSubmissionDateLengthString =
                      snapshot.child("rpSubmissionDate").value.toString();
                  int rpSubmissionDateLengthInt =
                      rpSubmissionDateLengthString.split(":").length - 1;
                  String rpSubmissionDate = snapshot
                      .child(
                          "rpSubmissionDate/rpSubmissionDate$rpSubmissionDateLengthInt")
                      .value
                      .toString();

                  String projectUpdatesTitle =
                      snapshot.child("projectUpdatesTitle").value.toString();

                  String projectUpdatesPhotoURL =
                      snapshot.child("projectUpdatesPhotoURL").value.toString();

                  DateTime dateTime =
                      DateFormat("MM-dd-yyyy").parse(rpSubmissionDate);
                  String formattedDate =
                      DateFormat("MMMM d, yyyy").format(dateTime);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InspectorProjectUpdatesPage(
                                  projectUpdatesID: projectUpdatesID,
                                )),
                      );
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Image.network(
                            fit: BoxFit.cover,
                            projectUpdatesPhotoURL,
                            width: 100,
                            height: 100,
                          ),
                          Column(
                            children: [
                              Text(
                                jobTitle,
                                style: const TextStyle(fontSize: 8),
                              ),
                              Text(projectUpdatesTitle),
                              Text("Accomplished by: $rpName"),
                              Text(formattedDate),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
