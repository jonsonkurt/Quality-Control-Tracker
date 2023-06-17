import 'package:flutter/material.dart';
import 'package:quality_control_tracker/view/admin/admin_profile_page.dart';

import 'package:firebase_database/firebase_database.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('projects');
  late String projectID;
  String projectName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color(0xFF221540),
            fontSize: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 15,
            ),
            child: IconButton(
              onPressed: () {
                // ignore: use_build_context_synchronously
                Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminProfilePage()));
              },
              icon: const Icon(
                Icons.account_circle,
                color: Color(0xFF221540),
                size: 45,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: ref.orderByChild("projectStatus").equalTo("ON-GOING").onValue,
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
                    String projectInspector = values[projectID]["inspector"];
                    String projectImage = values[projectID]["projectImage"];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (projectImage == "None")
                                  const Text(
                                    "NO FUCKING \nIMAGE",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                else
                                  Image.network(
                                    projectImage,
                                    width: 100,
                                    height: 100,
                                  ),
                                Column(
                                  children: [
                                    Text('Project Name: $projectName'),
                                    Text('Project Location: $projectLocation'),
                                    Text(
                                        'Project Inspector: $projectInspector'),
                                    Text('Project ID: $projectID'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // You can access and display other properties from projectData here
                      ),
                    );
                  },
                );
              }
            }
            return const Text("");
          }),
    );
  }
}
