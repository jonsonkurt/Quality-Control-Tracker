import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:logger/logger.dart';
import 'package:quality_control_tracker/view/inspector/inspector_project_updates.dart';

import 'inspector_project_updates_completed.dart';
import 'inspector_project_updates_rework.dart';

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
  StreamSubscription<DatabaseEvent>? emptyPendingSubscription,
      emptyReworkSubscription,
      emptyCompletedSubscription;
  var logger = Logger();
  bool isEmptyPending = true;
  bool isEmptyRework = true;
  bool isEmptyCompleted = true;
  String? searchQuery = "";

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
      case 'technician':
        return 'Technician';
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
    Query emptyReworkQuery = emptyPendingRef
        .orderByChild("inspectorProjectRemarks")
        .startAt("$inspectorID-${widget.projectIDQuery}-REWORK-")
        .endAt("$inspectorID-${widget.projectIDQuery}-REWORK-\uf8ff");
    Query emptyCompletedQuery = emptyPendingRef
        .orderByChild("inspectorProjectRemarks")
        .startAt("$inspectorID-${widget.projectIDQuery}-COMPLETED-")
        .endAt("$inspectorID-${widget.projectIDQuery}-COMPLETED-\uf8ff");

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
              'Updates',
              style: TextStyle(
                fontFamily: 'Rubik Bold',
                fontSize: mediaQuery.size.height * 0.04,
                color: const Color(0xFF221540),
              ),
            ),
          ),
        ),
      ),
      //   body: Column(
      //     children: [
      //       Expanded(
      //         child: Container(
      //           height: 580,
      //           padding: const EdgeInsets.only(top: 10),
      //           child: Builder(
      //             builder: (BuildContext context) {
      //               if (isEmptyPending) {
      //                 return const Center(child: Text("No Available Data"));
      //               } else {
      //                 return FirebaseAnimatedList(
      //                   padding: const EdgeInsets.only(bottom: 80),
      //                   query: ref
      //                       .orderByChild("inspectorProjectRemarks")
      //                       .startAt(
      //                           "$inspectorID-${widget.projectIDQuery}-PENDING-")
      //                       .endAt(
      //                           "$inspectorID-${widget.projectIDQuery}-PENDING-\uf8ff"),
      //                   itemBuilder: (context, snapshot, animation, index) {
      //                     String projectUpdatesID =
      //                         snapshot.child("projectUpdatesID").value.toString();
      //                     String rpName =
      //                         snapshot.child("rpName").value.toString();
      //                     String rpRole =
      //                         snapshot.child("rpRole").value.toString();
      //                     String jobTitle = convertJobTitle(rpRole);

      //                     String rpSubmissionDateLengthString =
      //                         snapshot.child("rpSubmissionDate").value.toString();
      //                     int rpSubmissionDateLengthInt =
      //                         rpSubmissionDateLengthString.split(":").length - 1;
      //                     String rpSubmissionDate = snapshot
      //                         .child(
      //                             "rpSubmissionDate/rpSubmissionDate$rpSubmissionDateLengthInt")
      //                         .value
      //                         .toString();

      //                     String projectUpdatesTitle = snapshot
      //                         .child("projectUpdatesTitle")
      //                         .value
      //                         .toString();

      //                     String projectUpdatesPhotoURL = snapshot
      //                         .child("projectUpdatesPhotoURL")
      //                         .value
      //                         .toString();

      //                     DateTime dateTime =
      //                         DateFormat("MM-dd-yyyy").parse(rpSubmissionDate);
      //                     String formattedDate =
      //                         DateFormat("MMMM d, yyyy").format(dateTime);

      //                     if (searchQuery != null &&
      //                         searchQuery!.isNotEmpty &&
      //                         !projectUpdatesTitle
      //                             .toLowerCase()
      //                             .contains(searchQuery!.toLowerCase())) {
      //                       return Container();
      //                     }

      //                     return GestureDetector(
      //                       onTap: () {
      //                         Navigator.push(
      //                           context,
      //                           MaterialPageRoute(
      //                               builder: (context) =>
      //                                   InspectorProjectUpdatesPage(
      //                                     projectUpdatesID: projectUpdatesID,
      //                                   )),
      //                         );
      //                       },
      //                       child: Padding(
      //                         padding: EdgeInsets.fromLTRB(
      //                           mediaQuery.size.width * 0.02,
      //                           mediaQuery.size.height * 0.001,
      //                           mediaQuery.size.width * 0.02,
      //                           mediaQuery.size.height * 0.001,
      //                         ),
      //                         child: Card(
      //                           shape: RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(20)),
      //                           child: Row(
      //                             children: [
      //                               Padding(
      //                                 padding: const EdgeInsets.all(10.0),
      //                                 child: Hero(
      //                                   tag: projectUpdatesID,
      //                                   child: ClipRRect(
      //                                     borderRadius: BorderRadius.circular(15),
      //                                     child: projectUpdatesPhotoURL == "None"
      //                                         ? Image.asset(
      //                                             'assets/images/no-image.png',
      //                                             fit: BoxFit.cover,
      //                                             width: 100,
      //                                             height: 100,
      //                                           )
      //                                         : Image(
      //                                             width: 100,
      //                                             height: 100,
      //                                             fit: BoxFit.cover,
      //                                             image: NetworkImage(
      //                                                 projectUpdatesPhotoURL),
      //                                             loadingBuilder: (context, child,
      //                                                 loadingProgress) {
      //                                               if (loadingProgress == null) {
      //                                                 return child;
      //                                               }
      //                                               return const CircularProgressIndicator();
      //                                             },
      //                                             errorBuilder:
      //                                                 (context, object, stack) {
      //                                               return const Icon(
      //                                                 Icons.error_outline,
      //                                                 color: Color.fromARGB(
      //                                                     255, 35, 35, 35),
      //                                               );
      //                                             },
      //                                           ),
      //                                   ),
      //                                 ),
      //                               ),
      //                               Expanded(
      //                                 child: Column(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment.start,
      //                                   children: [
      //                                     Padding(
      //                                       padding: EdgeInsets.only(
      //                                           right:
      //                                               mediaQuery.size.width * 0.05),
      //                                       child: Text(
      //                                         jobTitle,
      //                                         maxLines: 1,
      //                                         overflow: TextOverflow.fade,
      //                                         softWrap: false,
      //                                         style: TextStyle(
      //                                           fontFamily: 'Rubik Bold',
      //                                           fontSize:
      //                                               mediaQuery.size.height * 0.02,
      //                                           color: const Color(0xff221540),
      //                                         ),
      //                                       ),
      //                                     ),
      //                                     SizedBox(
      //                                         height:
      //                                             mediaQuery.size.height * 0.002),
      //                                     Padding(
      //                                       padding: EdgeInsets.only(
      //                                           right:
      //                                               mediaQuery.size.width * 0.05),
      //                                       child: Text(
      //                                         projectUpdatesTitle,
      //                                         maxLines: 1,
      //                                         overflow: TextOverflow.fade,
      //                                         softWrap: false,
      //                                         style: TextStyle(
      //                                           fontFamily: 'Karla Regular',
      //                                           fontSize: mediaQuery.size.height *
      //                                               0.017,
      //                                           color: const Color(0xff221540),
      //                                         ),
      //                                       ),
      //                                     ),
      //                                     SizedBox(
      //                                         height:
      //                                             mediaQuery.size.height * 0.002),
      //                                     Text(
      //                                       "Accomplished by: $rpName",
      //                                       maxLines: 1,
      //                                       overflow: TextOverflow.fade,
      //                                       softWrap: false,
      //                                       style: TextStyle(
      //                                         fontFamily: 'Karla Regular',
      //                                         fontSize:
      //                                             mediaQuery.size.height * 0.017,
      //                                         color: const Color(0xff221540),
      //                                       ),
      //                                     ),
      //                                     SizedBox(
      //                                         height:
      //                                             mediaQuery.size.height * 0.002),
      //                                     Text(
      //                                       formattedDate,
      //                                       maxLines: 1,
      //                                       overflow: TextOverflow.fade,
      //                                       softWrap: false,
      //                                       style: TextStyle(
      //                                         fontFamily: 'Karla Regular',
      //                                         fontSize:
      //                                             mediaQuery.size.height * 0.017,
      //                                         color: const Color(0xff221540),
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               )
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 );
      //               }
      //             },
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      body: SingleChildScrollView(
        child: Padding(
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
                            .orderByChild("inspectorProjectRemarks")
                            .startAt(
                                "$inspectorID-${widget.projectIDQuery}-PENDING-")
                            .endAt(
                                "$inspectorID-${widget.projectIDQuery}-PENDING-\uf8ff"),
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

                          // String projectUpdatesTitle = snapshot
                          //     .child("projectUpdatesTitle")
                          //     .value
                          //     .toString();

                          String? projectUpdatesPhotoURL = snapshot
                              .child("projectUpdatesPhotoURL")
                              .value
                              .toString();

                          String rpRole =
                              snapshot.child("rpRole").value.toString();
                          String jobTitle = convertJobTitle(rpRole);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InspectorProjectUpdatesPage(
                                          projectUpdatesID: projectUpdatesID,
                                        )),
                              );
                            },
                            child: SizedBox(
                              height: mediaQuery.size.height * 0.11,
                              width: mediaQuery.size.width * 0.36,
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
                                        child: projectUpdatesPhotoURL == "None"
                                            ? Image.asset(
                                                'assets/images/no-image.png',
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                              )
                                            : Image(
                                                width:
                                                    mediaQuery.size.width * 0.8,
                                                height: mediaQuery.size.height *
                                                    0.25,
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    projectUpdatesPhotoURL),
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Transform.scale(
                                                    scaleX: 0.25,
                                                    scaleY: 0.35,
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                      strokeWidth: 2.0,
                                                    ),
                                                  );
                                                },
                                                errorBuilder:
                                                    (context, object, stack) {
                                                  return const Icon(
                                                    Icons.error_outline,
                                                    color: Color.fromARGB(
                                                        255, 35, 35, 35),
                                                  );
                                                },
                                              ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      child: Text(
                                        // projectUpdatesTitle,
                                        jobTitle,
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontFamily: "Rubik Bold",
                                            fontSize:
                                                mediaQuery.size.height * 0.018,
                                            color: const Color(0xFF221540)),
                                      ),
                                    ),
                                    Text(
                                      "Submitted on:",
                                      style: TextStyle(
                                          fontFamily: "Karla Regular",
                                          fontSize:
                                              mediaQuery.size.height * 0.015,
                                          color: const Color(0xFF221540)),
                                    ),
                                    Text(
                                      rpSubmissionDate,
                                      style: TextStyle(
                                          fontFamily: "Karla Regular",
                                          fontSize:
                                              mediaQuery.size.height * 0.015,
                                          color: const Color(0xFF221540)),
                                    ),
                                  ],
                                ),
                              ),
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
                              .orderByChild("inspectorProjectRemarks")
                              .startAt(
                                  "$inspectorID-${widget.projectIDQuery}-REWORK-")
                              .endAt(
                                  "$inspectorID-${widget.projectIDQuery}-REWORK-\uf8ff"),
                          itemBuilder: (context, snapshot, animation, index) {
                            String projectUpdatesID = snapshot
                                .child("projectUpdatesID")
                                .value
                                .toString();

                            String inspectionDateLengthString = snapshot
                                .child("inspectionDate")
                                .value
                                .toString();
                            int inspectionDateLengthInt =
                                inspectionDateLengthString.split(":").length -
                                    1;
                            String inspectionDate = snapshot
                                .child(
                                    "inspectionDate/inspectionDate$inspectionDateLengthInt")
                                .value
                                .toString();

                            // String projectUpdatesTitle = snapshot
                            //     .child("projectUpdatesTitle")
                            //     .value
                            //     .toString();

                            String projectUpdatesPhotoURL = snapshot
                                .child("projectUpdatesPhotoURL")
                                .value
                                .toString();

                            String rpRole =
                                snapshot.child("rpRole").value.toString();
                            String jobTitle = convertJobTitle(rpRole);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InspectorProjectUpdatesReworkPage(
                                            projectUpdatesID: projectUpdatesID,
                                          )),
                                );
                              },
                              child: SizedBox(
                                height: mediaQuery.size.height * 0.11,
                                width: mediaQuery.size.width * 0.36,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: mediaQuery.size.height * 0.11,
                                        width: mediaQuery.size.width * 0.36,
                                        child: Hero(
                                          tag: projectUpdatesID,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20)),
                                            child: projectUpdatesPhotoURL ==
                                                    "None"
                                                ? Image.asset(
                                                    'assets/images/no-image.png',
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  )
                                                : Image(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.8,
                                                    height:
                                                        mediaQuery.size.height *
                                                            0.25,
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        projectUpdatesPhotoURL),
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Transform.scale(
                                                          scaleX: 0.25,
                                                          scaleY: 0.35,
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                            strokeWidth: 2.0,
                                                          ));
                                                    },
                                                    errorBuilder: (context,
                                                        object, stack) {
                                                      return const Icon(
                                                        Icons.error_outline,
                                                        color: Color.fromARGB(
                                                            255, 35, 35, 35),
                                                      );
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                            ),
                                            child: Text(
                                              // projectUpdatesTitle,
                                              jobTitle,
                                              maxLines: 1,
                                              softWrap: false,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  fontFamily: "Rubik Bold",
                                                  fontSize:
                                                      mediaQuery.size.height *
                                                          0.018,
                                                  color:
                                                      const Color(0xFF221540)),
                                            ),
                                          ),
                                          Text(
                                            "Inspected on:",
                                            style: TextStyle(
                                                fontFamily: "Karla Regular",
                                                fontSize:
                                                    mediaQuery.size.height *
                                                        0.015,
                                                color: const Color(0xFF221540)),
                                          ),
                                          Text(
                                            inspectionDate,
                                            style: TextStyle(
                                                fontFamily: "Karla Regular",
                                                fontSize:
                                                    mediaQuery.size.height *
                                                        0.015,
                                                color: const Color(0xFF221540)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
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
                              .orderByChild("inspectorProjectRemarks")
                              .startAt(
                                  "$inspectorID-${widget.projectIDQuery}-COMPLETED-")
                              .endAt(
                                  "$inspectorID-${widget.projectIDQuery}-COMPLETED-\uf8ff"),
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

                            // String projectUpdatesTitle = snapshot
                            //     .child("projectUpdatesTitle")
                            //     .value
                            //     .toString();

                            String projectUpdatesPhotoURL = snapshot
                                .child("projectUpdatesPhotoURL")
                                .value
                                .toString();

                            String rpRole =
                                snapshot.child("rpRole").value.toString();
                            String jobTitle = convertJobTitle(rpRole);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InspectorProjectUpdatesCompletedPage(
                                      projectUpdatesID: projectUpdatesID,
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: mediaQuery.size.height * 0.11,
                                width: mediaQuery.size.width * 0.36,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: mediaQuery.size.height * 0.11,
                                        width: mediaQuery.size.width * 0.36,
                                        child: Hero(
                                          tag: projectUpdatesID,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20)),
                                            child: projectUpdatesPhotoURL ==
                                                    "None"
                                                ? Image.asset(
                                                    'assets/images/no-image.png',
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  )
                                                : Image(
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.8,
                                                    height:
                                                        mediaQuery.size.height *
                                                            0.25,
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        projectUpdatesPhotoURL),
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Transform.scale(
                                                          scaleX: 0.25,
                                                          scaleY: 0.35,
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                            strokeWidth: 2.0,
                                                          ));
                                                    },
                                                    errorBuilder: (context,
                                                        object, stack) {
                                                      return const Icon(
                                                        Icons.error_outline,
                                                        color: Color.fromARGB(
                                                            255, 35, 35, 35),
                                                      );
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                            ),
                                            child: Text(
                                                // projectUpdatesTitle,
                                                jobTitle,
                                                maxLines: 1,
                                                softWrap: false,
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    fontFamily: "Rubik Bold",
                                                    fontSize:
                                                        mediaQuery.size.height *
                                                            0.018,
                                                    color: const Color(
                                                        0xFF221540))),
                                          ),
                                          Text("Submitted on:",
                                              style: TextStyle(
                                                  fontFamily: "Karla Regular",
                                                  fontSize:
                                                      mediaQuery.size.height *
                                                          0.015,
                                                  color:
                                                      const Color(0xFF221540))),
                                          Text(rpSubmissionDate,
                                              style: TextStyle(
                                                  fontFamily: "Karla Regular",
                                                  fontSize:
                                                      mediaQuery.size.height *
                                                          0.015,
                                                  color:
                                                      const Color(0xFF221540))),
                                        ],
                                      )
                                    ],
                                  ),
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
      ),
    );
  }
}
