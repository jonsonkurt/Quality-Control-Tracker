import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quality_control_tracker/image_viewer.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_bottom_navigation_bar.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_profile_page.dart';

class ResponsiblePartyDashboardPage extends StatefulWidget {
  final String role;

  const ResponsiblePartyDashboardPage({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  State<ResponsiblePartyDashboardPage> createState() =>
      _ResponsiblePartyDashboardPageState();
}

class _ResponsiblePartyDashboardPageState
    extends State<ResponsiblePartyDashboardPage> {
  final TextEditingController _projectIdController = TextEditingController();

  StreamSubscription<DatabaseEvent>? getRole;
  StreamSubscription<DatabaseEvent>? userSubscription;
  StreamSubscription<DatabaseEvent>? projectSubscription;
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  String name = '';
  var logger = Logger();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = true;

  @override
  void dispose() {
    getRole?.cancel();
    userSubscription?.cancel();
    projectSubscription?.cancel();
    _projectIdController.dispose();
    super.dispose();
  }

  void _showDialog() {
    // Getting the RP's role and roleQuery
    String rpRole = "";
    String rpRoleQuery = "";

    if (widget.role == "Project Manager") {
      rpRole = "projectManager";
      rpRoleQuery = "projectManagerQuery";
    } else {
      rpRole = widget.role.toLowerCase();
      rpRoleQuery = "${widget.role.toLowerCase()}Query";
    }

    // Getting the RP's full name
    DatabaseReference nameRef =
        FirebaseDatabase.instance.ref().child('responsibleParties/$userID/');
    userSubscription = nameRef.onValue.listen((event) {
      try {
        String firstName = event.snapshot.child("firstName").value.toString();
        String lastName = event.snapshot.child("lastName").value.toString();
        name = "$firstName $lastName";
      } catch (error, stackTrace) {
        logger.d('Error occurred: $error');
        logger.d('Stack trace: $stackTrace');
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final mediaQuery = MediaQuery.of(context);
        return Form(
          key: formKey,
          child: AlertDialog(
            backgroundColor: const Color(0xffDCE4E9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Add Project',
              style: TextStyle(
                  fontFamily: 'Rubik Bold',
                  fontSize: mediaQuery.size.height * 0.03,
                  color: const Color(0xFF221540)),
            ),
            content: TextFormField(
              cursorColor: const Color(0xFF221540),
              controller: _projectIdController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Project ID',
                labelStyle: TextStyle(
                  fontFamily: 'Karla Regular',
                  fontSize: mediaQuery.size.height * 0.02,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a project ID';
                }
                return null;
              },
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: const Color(0xFF221540)),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      String projectId = _projectIdController.text;

                      // Updates database
                      DatabaseReference projectsRef = FirebaseDatabase.instance
                          .ref()
                          .child('projects/$projectId');

                      projectSubscription = projectsRef.onValue.listen((event) {
                        try {
                          if (event.snapshot.value != null) {
                            projectsRef.update({
                              rpRole: name,
                              rpRoleQuery: userID,
                            });
                            _projectIdController.text = "";
                          } else {
                            // Project does not exist, show SnackBar
                            _projectIdController.text = "";
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Project does not exist")),
                            );
                          }
                        } catch (error, stackTrace) {
                          logger.d('Error occurred: $error');
                          logger.d('Stack trace: $stackTrace');
                        }
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(mediaQuery.size.height * 0.017),
                    child: Text(
                      'Add Project',
                      style: TextStyle(
                          fontFamily: 'Rubik Regular',
                          fontSize: mediaQuery.size.height * 0.02),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.02,
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String rpRole = "";
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('projects');

    if (widget.role == "Project Manager") {
      rpRole = "projectManagerQuery";
    } else {
      rpRole = "${widget.role.toLowerCase()}Query";
    }

    final mediaQuery = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () async {
        return false; // Disable back button
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFDCE4E9),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              mediaQuery.size.height * 0.1,
            ),
            child: AppBar(
              toolbarHeight: mediaQuery.size.height * 0.1,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: EdgeInsets.fromLTRB(0, mediaQuery.size.height * 0.01,
                    mediaQuery.size.width * 0.06, 0),
                child: Text(
                  'Dashboard',
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
                    mediaQuery.size.height * 0.01,
                    mediaQuery.size.width * 0.035,
                    0,
                  ),
                  child: IconButton(
                    onPressed: () {
                      // ignore: use_build_context_synchronously
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ResponsiblePartyProfilePage(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.account_circle,
                      size: mediaQuery.size.height * 0.045,
                      color: const Color(0xFF221540),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: StreamBuilder(
              stream: ref.orderByChild(rpRole).equalTo(userID).onValue,
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
                          String projectID = values.keys.elementAt(index);

                          String projectName = values[projectID]["projectName"];
                          String projectLocation =
                              values[projectID]["projectLocation"];
                          String projectInspector =
                              values[projectID]["inspector"];
                          String projectImage =
                              values[projectID]["projectImage"];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ResponsiblePartyBottomNavigation(
                                    projectID: projectID,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                mediaQuery.size.width * 0.01,
                                mediaQuery.size.height * 0.001,
                                mediaQuery.size.width * 0.01,
                                mediaQuery.size.height * 0.001,
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return DetailScreen(
                                                imageUrl: projectImage,
                                                projectID: projectID,
                                              );
                                            }));
                                          },

                                          // Image (kindly consult Jiiroo if you can't understand the code ty. ヾ(≧▽≦*)o)
                                          child: Hero(
                                            tag: projectID,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: projectImage == "None"
                                                    ? Image.asset(
                                                        'assets/images/no-image.png',
                                                        fit: BoxFit.cover,
                                                        width: 100,
                                                        height: 100,
                                                      )
                                                    : Image(
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            projectImage),
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
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    35,
                                                                    35,
                                                                    35),
                                                          );
                                                        },
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right:
                                                        mediaQuery.size.width *
                                                            0.05),
                                                child: Text(
                                                  projectName,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik Bold',
                                                    fontSize:
                                                        mediaQuery.size.height *
                                                            0.02,
                                                    color:
                                                        const Color(0xff221540),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height:
                                                      mediaQuery.size.height *
                                                          0.002),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right:
                                                        mediaQuery.size.width *
                                                            0.05),
                                                child: Text(
                                                  projectLocation,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontFamily: 'Karla Regular',
                                                    fontSize:
                                                        mediaQuery.size.height *
                                                            0.017,
                                                    color:
                                                        const Color(0xff221540),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height:
                                                      mediaQuery.size.height *
                                                          0.002),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right:
                                                        mediaQuery.size.width *
                                                            0.05),
                                                child: Text(
                                                  projectInspector,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    fontFamily: 'Karla Regular',
                                                    fontSize:
                                                        mediaQuery.size.height *
                                                            0.017,
                                                    color:
                                                        const Color(0xff221540),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height:
                                                      mediaQuery.size.height *
                                                          0.002),
                                              Text(
                                                'Project ID: $projectID',
                                                style: TextStyle(
                                                  fontFamily: 'Karla Regular',
                                                  fontSize:
                                                      mediaQuery.size.height *
                                                          0.017,
                                                  color:
                                                      const Color(0xff221540),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }
                return const Center(child: Text("No Available Data"));
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: _showDialog,
            backgroundColor: const Color(0xFF221540),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
