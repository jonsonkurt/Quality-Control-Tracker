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

    return Scaffold(
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
                        String projectUpdatesID = values.keys.elementAt(index);
                        String? inspectorFirstName =
                            values[projectUpdatesID]["firstName"];
                        String? inspectorLastName =
                            values[projectUpdatesID]["lastName"];
                        String? inspectorFullName =
                            "$inspectorFirstName $inspectorLastName";

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
                                      const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
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
                                                fontSize: MediaQuery.of(context)
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
            }));
  }
}
