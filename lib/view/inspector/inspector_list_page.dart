import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
  DatabaseReference ref =
      FirebaseDatabase.instance.ref().child('projectUpdates');

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
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
        backgroundColor: const Color(0xFFDCE4E9),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            mediaQuery.size.height * 0.1,
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
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
        body: StreamBuilder(
            stream:
                ref.orderByChild("inspectorID").equalTo(inspectorID).onValue,
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
                        String inspectorName =
                            values[projectUpdatesID]["inspector"];
                        String rpName = values[projectUpdatesID]["rpName"];
                        String rpRole = values[projectUpdatesID]["rpRole"];
                        String jobTitle = convertJobTitle(rpRole);
                        int rpSubmissionDateLength =
                            values[projectUpdatesID]["rpSubmissionDate"].length;
                        String rpSubmissionDate = values[projectUpdatesID]
                                ["rpSubmissionDate"]
                            ["rpSubmissionDate$rpSubmissionDateLength"];
                        String projectUpdatesPhotoURL =
                            values[projectUpdatesID]["projectUpdatesPhotoURL"];

                        DateTime dateTime =
                            DateFormat("MM-dd-yyyy").parse(rpSubmissionDate);
                        String formattedDate =
                            DateFormat("MMMM d, yyyy").format(dateTime);

                        return Card(
                          child: Row(
                            children: [
                              Image.network(
                                projectUpdatesPhotoURL,
                                width: 100,
                                height: 100,
                              ),
                              Column(
                                children: [
                                  Text(jobTitle),
                                  Text("Accomplished by: $rpName"),
                                  Text(formattedDate),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                }
              }
              return const Text("hello");
            }));
  }
}
