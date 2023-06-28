import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_tracker/view/responsible_party/update_image_controller.dart';

class ResponsiblePartyReworkEditPage extends StatefulWidget {
  final String projectUpdatesID;
  final String projectUpdatesTitle;
  final String projectUpdatesNotes;

  const ResponsiblePartyReworkEditPage({
    Key? key,
    required this.projectUpdatesID,
    required this.projectUpdatesTitle,
    required this.projectUpdatesNotes,
  }) : super(key: key);

  @override
  State<ResponsiblePartyReworkEditPage> createState() =>
      _ResponsiblePartyReworkEditPageState();
}

class _ResponsiblePartyReworkEditPageState
    extends State<ResponsiblePartyReworkEditPage> {
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
  final TextEditingController rpTitleController = TextEditingController();

  @override
  void initState() {
    rpNotesController.text = widget.projectUpdatesNotes;
    rpTitleController.text = widget.projectUpdatesTitle;
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
        case 'technician':
          return 'Technician';
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
              'Edit Update',
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

                String inspectorID = map['inspectorID'];
                String projectID = map['projectID'];

                int rpNotesLength = map["rpNotes"].length;

                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: mediaQuery.size.height * 0.05,
                      ),
                      ChangeNotifierProvider(
                        create: (_) => ProfileController(),
                        child: Consumer<ProfileController>(
                            builder: (context, provider, child) {
                          return Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 5,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: provider.image == null
                                              ? projectUpdatesPicture == "None"
                                                  ? Image.asset(
                                                      'assets/images/no-image.png',
                                                      fit: BoxFit.cover,
                                                      width: mediaQuery
                                                              .size.width *
                                                          0.8,
                                                      height: mediaQuery
                                                              .size.height *
                                                          0.25,
                                                    )
                                                  : Image(
                                                      width: mediaQuery
                                                              .size.width *
                                                          0.8,
                                                      height: mediaQuery
                                                              .size.height *
                                                          0.25,
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          projectUpdatesPicture),
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return const CircularProgressIndicator();
                                                      },
                                                      errorBuilder: (context,
                                                          object, stack) {
                                                        return const Icon(
                                                          Icons.error_outline,
                                                          color: Color.fromARGB(
                                                              255, 35, 35, 35),
                                                        );
                                                      },
                                                    )
                                              : Image.file(
                                                  fit: BoxFit.cover,
                                                  width: mediaQuery.size.width *
                                                      0.8,
                                                  height:
                                                      mediaQuery.size.height *
                                                          0.25,
                                                  File(provider.image!.path)
                                                      .absolute)),
                                    ),
                                  ),
                                  Positioned(
                                    top: mediaQuery.size.height * 0.22,
                                    left: mediaQuery.size.width * 0.75,
                                    child: InkWell(
                                      onTap: () {
                                        provider.pickImage(
                                            context, widget.projectUpdatesID);
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Color(0xFF221540),
                                        radius: 20,
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.02),
                              Form(
                                key: formKey,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: mediaQuery.size.width * 0.10,
                                      right: mediaQuery.size.width * 0.10),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: rpTitleController,
                                        cursorColor: const Color(0xFF221540),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.title),
                                          hintText: 'Title',
                                          labelStyle: const TextStyle(
                                            fontFamily: "Karla Regular",
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical:
                                                16, // Adjust the vertical padding here
                                            horizontal:
                                                24, // Adjust the horizontal padding here
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter a title';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      TextFormField(
                                        controller: rpNotesController,
                                        cursorColor: const Color(0xFF221540),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.note),
                                          hintText: 'Notes',
                                          labelStyle: const TextStyle(
                                            fontFamily: "Karla Regular",
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical:
                                                16, // Adjust the vertical padding here
                                            horizontal:
                                                24, // Adjust the horizontal padding here
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your notes';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.03),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF221540),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // Adjust the radius as needed
                                  ),
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    String rpTitleF = rpTitleController.text;
                                    String rpNotesF = rpNotesController.text;
                                    DatabaseReference projectsRef =
                                        FirebaseDatabase.instance.ref().child(
                                            'projectUpdates/${widget.projectUpdatesID}');

                                    // / Group the updates into a single JSON object
                                    Map<String, dynamic> updates = {
                                      "rpNotes/rpNotes$rpNotesLength": rpNotesF,
                                      "projectUpdatesTitle": rpTitleF,
                                      "rpProjectRemarks":
                                          "$userID-$projectID-PENDING-$combinedDateTime",
                                      "inspectorProjectRemarks":
                                          "$inspectorID-$projectID-PENDING-$combinedDateTime",
                                    };

                                    await provider
                                        .updloadImage(widget.projectUpdatesID);

                                    if (provider.imgURL != "") {
                                      projectsRef.update({
                                        "projectUpdatesPhotoURL":
                                            provider.imgURL,
                                      });
                                    }

                                    await projectsRef.update(updates);

                                    // await provider.updloadImage(widget.projectUpdatesID);
                                    // if (provider.imgURL != "") {
                                    //   await ref.child(userID!).update({
                                    //     'profilePicStatus': provider.imgURL,
                                    //   });
                                    // }
                                    // await ref.child(userID!).update({
                                    //   'firstName': firstName,
                                    //   'lastName': lastName,
                                    //   'mobileNumber': mobileNumber,
                                    // });
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(
                                      context,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      mediaQuery.size.height * 0.017),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontFamily: 'Rubik Regular',
                                      fontSize: mediaQuery.size.height * 0.02,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),

                      //
                      //
                      // TEXT COLUMNS
                      // Container(
                      //   padding: EdgeInsets.fromLTRB(
                      //       mediaQuery.size.width * 0.1,
                      //       0,
                      //       mediaQuery.size.width * 0.1,
                      //       0),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         projectUpdatesTitle,
                      //         style: TextStyle(
                      //           fontFamily: "Rubik Bold",
                      //           fontSize: mediaQuery.size.height * 0.03,
                      //           color: const Color(0xFF221540),
                      //         ),
                      //       ),
                      //       SizedBox(height: mediaQuery.size.height * 0.01),
                      //       Text(
                      //         'Accomplished by: $projectUpdatesOP',
                      //         style: TextStyle(
                      //           fontFamily: "Karla Regular",
                      //           fontSize: mediaQuery.size.height * 0.02,
                      //           fontStyle: FontStyle.italic,
                      //           color: const Color(0xFF221540),
                      //         ),
                      //       ),
                      //       SizedBox(height: mediaQuery.size.height * 0.01),
                      //       Row(
                      //         children: [
                      //           Padding(
                      //             padding: EdgeInsets.all(
                      //                 mediaQuery.size.width * 0.01),
                      //             child: Icon(
                      //               Icons.calendar_today,
                      //               color: const Color(0xFF221540),
                      //               size: mediaQuery.size.height * 0.03,
                      //             ),
                      //           ),
                      //           Text(
                      //             "$projectUpdatesSubmissionDate",
                      //             // "Submission Date: ",
                      //             style: TextStyle(
                      //               fontFamily: "Karla Regular",
                      //               fontSize: mediaQuery.size.height * 0.02,
                      //               color: const Color(0xFF221540),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Row(
                      //         children: [
                      //           Padding(
                      //             padding: EdgeInsets.all(
                      //                 mediaQuery.size.width * 0.01),
                      //             child: Icon(
                      //               Icons.search,
                      //               color: const Color(0xFF221540),
                      //               size: mediaQuery.size.height * 0.03,
                      //             ),
                      //           ),
                      //           Text(
                      //             projectUpdatesTag,
                      //             style: TextStyle(
                      //               fontFamily: "Karla Regular",
                      //               fontSize: mediaQuery.size.height * 0.02,
                      //               color: const Color(0xFF221540),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(height: mediaQuery.size.height * 0.02),
                      //       Text(
                      //         "Description:",
                      //         style: TextStyle(
                      //           fontFamily: "Rubik Bold",
                      //           fontSize: mediaQuery.size.height * 0.022,
                      //           color: const Color(0xFF221540),
                      //         ),
                      //       ),
                      //       Text(
                      //         "$projectUpdatesNotes",
                      //         style: TextStyle(
                      //           fontFamily: "Karla Regular",
                      //           fontSize: mediaQuery.size.height * 0.02,
                      //           color: const Color(0xFF221540),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
