import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../image_viewer.dart';

class ResponsiblePartyProjectUpdatesInformationPage extends StatefulWidget {
  final String projectUpdatesID;

  const ResponsiblePartyProjectUpdatesInformationPage({
    Key? key,
    required this.projectUpdatesID,
  }) : super(key: key);

  @override
  State<ResponsiblePartyProjectUpdatesInformationPage> createState() =>
      _ResponsiblePartyProjectUpdatesInformationPageState();
}

class _ResponsiblePartyProjectUpdatesInformationPageState
    extends State<ResponsiblePartyProjectUpdatesInformationPage> {
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
  final TextEditingController inspectorNotesController =
      TextEditingController();
  final TextEditingController inspectorTitleController =
      TextEditingController();

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
                // Getting values from database
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

                String projectUpdatesPicture = map['projectUpdatesPhotoURL'];

                // projectUpdatesTitle
                String projectUpdatesTitle = map["projectUpdatesTitle"];

                String projectUpdatesOP = map['rpName'];

                // projectUpdatesSubmissionDate
                int projectUpdatesSubmissionDateLength =
                    map["rpSubmissionDate"].length;
                String? projectUpdatesSubmissionDate = map["rpSubmissionDate"]
                    ["rpSubmissionDate$projectUpdatesSubmissionDateLength"];

                String projectUpdatesTag =
                    convertJobTitle(map['rpRole'].toString());

                // String projectUpdatesNotes = map['firstName'];
                int projectUpdatesNotesLength = map["rpNotes"].length;
                String? projectUpdatesNotes =
                    map["rpNotes"]["rpNotes$projectUpdatesNotesLength"];

                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: mediaQuery.size.height * 0.05,
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                elevation: 5,
                                child: Hero(
                                  tag: widget.projectUpdatesID,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: projectUpdatesPicture == "None"
                                        ? Image.asset(
                                            'assets/images/no-image.png',
                                            fit: BoxFit.cover,
                                            width: mediaQuery.size.width * 0.8,
                                            height:
                                                mediaQuery.size.height * 0.25,
                                          )
                                        : Image(
                                            width: mediaQuery.size.width * 0.8,
                                            height:
                                                mediaQuery.size.height * 0.25,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                projectUpdatesPicture),
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const CircularProgressIndicator();
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
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.02),
                      //
                      //
                      // TEXT COLUMNS
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            mediaQuery.size.width * 0.1,
                            0,
                            mediaQuery.size.width * 0.1,
                            0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              projectUpdatesTitle,
                              style: TextStyle(
                                fontFamily: "Rubik Bold",
                                fontSize: mediaQuery.size.height * 0.03,
                                color: const Color(0xFF221540),
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            Text(
                              'Accomplished by: $projectUpdatesOP',
                              style: TextStyle(
                                fontFamily: "Karla Regular",
                                fontSize: mediaQuery.size.height * 0.02,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF221540),
                              ),
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      mediaQuery.size.width * 0.01),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: const Color(0xFF221540),
                                    size: mediaQuery.size.height * 0.03,
                                  ),
                                ),
                                Text(
                                  "$projectUpdatesSubmissionDate",
                                  // "Submission Date: ",
                                  style: TextStyle(
                                    fontFamily: "Karla Regular",
                                    fontSize: mediaQuery.size.height * 0.02,
                                    color: const Color(0xFF221540),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      mediaQuery.size.width * 0.01),
                                  child: Icon(
                                    Icons.search,
                                    color: const Color(0xFF221540),
                                    size: mediaQuery.size.height * 0.03,
                                  ),
                                ),
                                Text(
                                  projectUpdatesTag,
                                  style: TextStyle(
                                    fontFamily: "Karla Regular",
                                    fontSize: mediaQuery.size.height * 0.02,
                                    color: const Color(0xFF221540),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.02),
                            Text(
                              "Description:",
                              style: TextStyle(
                                fontFamily: "Rubik Bold",
                                fontSize: mediaQuery.size.height * 0.022,
                                color: const Color(0xFF221540),
                              ),
                            ),
                            Text(
                              "$projectUpdatesNotes",
                              style: TextStyle(
                                fontFamily: "Karla Regular",
                                fontSize: mediaQuery.size.height * 0.02,
                                color: const Color(0xFF221540),
                              ),
                            ),
                          ],
                        ),
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
