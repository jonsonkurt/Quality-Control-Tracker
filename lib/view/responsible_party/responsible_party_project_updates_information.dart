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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      width: 300,
                                      height: 200,
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
                          "Description: $projectUpdatesNotes",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
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
