import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quality_control_tracker/image_viewer.dart';

class InspectorHomePage extends StatefulWidget {
  final String projectIDQuery;

  const InspectorHomePage({
    Key? key,
    required this.projectIDQuery,
  }) : super(key: key);

  @override
  State<InspectorHomePage> createState() => _InspectorHomePageState();
}

class _InspectorHomePageState extends State<InspectorHomePage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    DatabaseReference projectDetailsRef = FirebaseDatabase.instance
        .ref()
        .child('projects/${widget.projectIDQuery}');

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
              'Information',
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

                String projectImage = map['projectImage'];
                String projectName = map['projectName'];
                String projectLocation = map['projectLocation'];
                String inspectorName = map['inspector'];
                String projectDeadline = map['projectDeadline'];
                String owner = map['owner'];

                String projectManager = map['projectManager'];
                String plumber = map['plumber'];
                String painter = map['painter'];
                String mason = map['mason'];
                String laborer = map['laborer'];
                String electrician = map['electrician'];
                String welder = map['welder'];
                String carpenter = map['carpenter'];
                String landscaper = map['landscaper'];
                String hvac = map['HVAC'];
                String technician = map['technician'];

                return SizedBox(
                  width: mediaQuery.size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: mediaQuery.size.height,
                            width: mediaQuery.size.width,
                            child: SafeArea(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return DetailScreen(
                                      imageUrl: projectImage,
                                      projectID: widget.projectIDQuery,
                                    );
                                  }));
                                },
                                // Image (kindly consult Jiiroo if you can't understand the code ty. ヾ(≧▽≦*)o)
                                child: Hero(
                                  tag: widget.projectIDQuery,
                                  child: ClipRRect(
                                    child: projectImage == "None"
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
                                            image: NetworkImage(projectImage),
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
                          Positioned(
                            top: 200,
                            bottom: 0,
                            child: Material(
                              color: const Color(0xFFDCE4E9),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 1,
                                height:
                                    MediaQuery.of(context).size.height / 1.2,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width / 15,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                          bottom: 5,
                                        ),
                                        child: Text(
                                          "Project Name ",
                                          style: TextStyle(
                                            fontFamily: 'Karla Regular',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50,
                                            color: Color(0xFF221540),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        projectName,
                                        style: TextStyle(
                                          fontFamily: 'Rubik Bold',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              35,
                                          color: const Color(0xFF221540),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 5,
                                        ),
                                        child: Text(
                                          'Inspector In-Charge ',
                                          style: TextStyle(
                                            fontFamily: 'Karla Regular',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50,
                                            color: Color(0xFF221540),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        inspectorName,
                                        style: TextStyle(
                                          fontFamily: 'Rubik Bold',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              35,
                                          color: Color(0xFF221540),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                          bottom: 5,
                                        ),
                                        child: Text(
                                          'Project Location ',
                                          style: TextStyle(
                                            fontFamily: 'Karla Regular',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50,
                                            color: Color(0xFF221540),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        projectLocation,
                                        style: TextStyle(
                                          fontFamily: 'Rubik Bold',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              35,
                                          color: const Color(0xFF221540),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 5,
                                        ),
                                        child: Text(
                                          "Project Deadline",
                                          // "Submission Date: ",
                                          style: TextStyle(
                                            fontFamily: 'Karla Regular',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50,
                                            color: const Color(0xFF221540),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        projectDeadline,
                                        // "Submission Date: ",
                                        style: TextStyle(
                                          fontFamily: 'Rubik Bold',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              35,
                                          color: const Color(0xFF221540),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding:
                                      //       const EdgeInsets.symmetric(horizontal: 16.0),
                                      //   child: Text(
                                      //     "Project Owner: $owner",
                                      //     style: const TextStyle(
                                      //       fontSize: 16,
                                      //     ),
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Project Team:",
                                        style: TextStyle(
                                          fontFamily: 'Karla Regular',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              50,
                                          color: const Color(0xFF221540),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "Project Manager:",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "Plumber: ",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "Painter: ",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "Mason: ",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "Laborer: ",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "Electrician: ",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "Welder:",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "Carpenter: ",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "Landscaper: ",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "HVAC: ",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "Technician: ",
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Color(0xFF221540),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 80,
                                          ),
                                          Column(
                                            children: [
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                projectManager,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                plumber,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                painter,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                mason,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                laborer,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                electrician,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                welder,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                carpenter,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                landscaper,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                              Text(
                                                hvac,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                              Text(
                                                technician,
                                                style: const TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12,
                                                  color: Color(0xFF221540),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
