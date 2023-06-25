import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quality_control_tracker/view/admin/admin_inspector_creation_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminListPage extends StatefulWidget {
  const AdminListPage({Key? key}) : super(key: key);

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  StreamSubscription<DatabaseEvent>? nameSubricption;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('inspectors');
  DatabaseReference ref1 = FirebaseDatabase.instance.ref().child('projects');

  int countProjects(List<dynamic> projectList, String inspectorName) {
    int count = 0;
    for (var project in projectList) {
      if (project['inspector'] == inspectorName) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> projectList = [];

    ref1.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? projectsData =
          snapshot.value as Map<dynamic, dynamic>?;

      if (projectsData != null) {
        projectList = projectsData.values.toList();
      } else {
        print('No data available');
      }
    }, onError: (error) {
      print('Error: $error');
    });

    return WillPopScope(
      onWillPop: () async {
        return false; // Disable back button
      },
      child: Scaffold(
          backgroundColor: const Color(0xFFDCE4E9),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * 0.1,
            ),
            child: AppBar(
              toolbarHeight: 60,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Padding(
                padding: EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.of(context).size.height * 0.035,
                    MediaQuery.of(context).size.width * 0.06,
                    0),
                child: Text(
                  'Inspectors',
                  style: TextStyle(
                    fontFamily: 'Rubik Bold',
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                    color: const Color(0xFF221540),
                  ),
                ),
              ),
            ),
          ),
          body: StreamBuilder(
              stream: ref.orderByChild("firstName").onValue,
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
                          String projectUpdatesID =
                              values.keys.elementAt(index);
                          String? inspectorID =
                              values[projectUpdatesID]["inspectorID"];
                          String? inspectorFirstName =
                              values[projectUpdatesID]["firstName"];
                          String? inspectorLastName =
                              values[projectUpdatesID]["lastName"];
                          String? inspectorFullName =
                              "$inspectorFirstName $inspectorLastName";
                          String? inspectorProfilePic =
                              values[projectUpdatesID]["profilePicStatus"];

                          int projectHandled =
                              countProjects(projectList, inspectorFullName);

                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.01,
                              MediaQuery.of(context).size.height * 0.001,
                              MediaQuery.of(context).size.width * 0.01,
                              MediaQuery.of(context).size.height * 0.001,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(

                                  ///mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Hero(
                                            tag: inspectorID!,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: inspectorProfilePic ==
                                                      "None"
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
                                                          inspectorProfilePic!),
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
                                                              Color(0xFF221540),
                                                        );
                                                      },
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              inspectorFullName,
                                              style: TextStyle(
                                                  fontFamily: 'Rubik Bold',
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.023),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            Text(
                                              "Project handled:$projectHandled",
                                              style: TextStyle(
                                                fontFamily: 'Karla Regular',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.018,
                                                color: const Color(0xff221540),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          );
                        });
                  }
                }
                return Text("helkko");
              })),
    );
  }
}
