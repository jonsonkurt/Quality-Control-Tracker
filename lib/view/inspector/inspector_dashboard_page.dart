import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quality_control_tracker/image_viewer.dart';
import 'package:quality_control_tracker/view/inspector/inspector_bottom_navigation_bar.dart';

import 'inspector_profile_page.dart';

class InspectorDashboardPage extends StatefulWidget {
  const InspectorDashboardPage({Key? key}) : super(key: key);

  @override
  State<InspectorDashboardPage> createState() => _InspectorDashboardPageState();
}

class _InspectorDashboardPageState extends State<InspectorDashboardPage> {
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('projects');

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        return false; // Disable back button
      },
      child: Scaffold(
          backgroundColor: const Color(0xFFDCE4E9),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(mediaQuery.size.height * 0.1),
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
                          builder: (context) => const InspectorProfilePage(),
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
              stream:
                  ref.orderByChild("inspectorQuery").equalTo(userID).onValue,
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
                        String projectImage = values[projectID]["projectImage"];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InspectorBottomNavigation(
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
                                        child: Hero(
                                          tag: projectID,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
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
                                                          color: Color.fromARGB(
                                                              255, 35, 35, 35),
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
                                                  right: mediaQuery.size.width *
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
                                                height: mediaQuery.size.height *
                                                    0.002),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: mediaQuery.size.width *
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
                                                height: mediaQuery.size.height *
                                                    0.002),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: mediaQuery.size.width *
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
                                                height: mediaQuery.size.height *
                                                    0.002),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: mediaQuery.size.width *
                                                      0.05),
                                              child: Text(
                                                'Project ID: $projectID',
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // You can access and display other properties from projectData here
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
                return const Text("");
              })),
    );
  }
}
